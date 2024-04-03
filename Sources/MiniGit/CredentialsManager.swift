//
//  CredentialsManager.swift
//  A simple JSON-backed credentials manager
//
//  Created by Lightech on 10/24/2048.
//

import SwiftUI

public protocol CredentialProvider {
    associatedtype Cred: GitCredential
    func fetchCredentials() -> [Cred]
    func addOrUpdate(oldCredential: Cred?, cred: Cred) throws
    func remove(offsets: IndexSet)
    func getCredentialForUrl(url: String) -> Cred?
}

public class FileSystemCredentialManager: CredentialProvider {
    var credentialsFileUrl: URL

    public init(credentialsFileUrl: URL) {
        // Load credentials from file
        self.credentialsFileUrl = credentialsFileUrl
    }

    public func fetchCredentials() -> [Credential] {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: credentialsFileUrl)
            return try decoder.decode([Credential].self, from: data)
        } catch let error {
            print(error)
            return []
        }
    }

    func save(credentials: [Credential]) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(credentials)
        FileManager.default.createFile(atPath: credentialsFileUrl.path,
                                       contents: data,
                                       attributes: nil)
    }

    public func remove(offsets: IndexSet) {
        var allCredentials = fetchCredentials()
        allCredentials.remove(atOffsets: offsets)
        do {
            try save(credentials: allCredentials)
        } catch let error {
            print(error)
        }
    }

    public func addOrUpdate(oldCredential oldcred: Credential?, cred: Credential) throws {
        var allCredentials = fetchCredentials()
        if let old_cred = oldcred {
            // Update the old credential with new information
            if let old_cred_index = allCredentials.firstIndex(where: {$0.id == old_cred.id}) {
                allCredentials.remove(at: old_cred_index)
                allCredentials.insert(cred, at: old_cred_index) // Check ID?
                try save(credentials: allCredentials)
            } else {
                print("Cannot find the old credential in the list! Something is wrong!")
            }
        } else {
            // Add a new credential to the list
            if cred.id == "" {
                throw ActionError(message: "The credential ID must not be empty!")
            }
            else if allCredentials.firstIndex(where: {$0.id == cred.id}) != nil {
                throw ActionError(message: "The credential with the same ID already exists. Cannot add another one.")
            } else {
                allCredentials.append(cred)
                try save(credentials: allCredentials)
            }
        }
    }

    public func getCredentialForUrl(url: String) -> Credential? {
        var allCredentials = fetchCredentials()
        return allCredentials.first(where: { url.hasPrefix($0.targetURL) })
    }
}

@available(iOS 14, macOS 11.0, *)
public class CredentialsManager: ObservableObject {

    @Published public var allCredentials = [any GitCredential]()
    private let credentialProvider: any CredentialProvider

    public init(provider: any CredentialProvider) {
        self.credentialProvider = provider
        allCredentials = credentialProvider.fetchCredentials()
    }

    public func remove(offsets: IndexSet) {
        credentialProvider.remove(offsets: offsets)
    }

    public func getCredentialForUrl(url: String) -> GitCredential? {
        return credentialProvider.getCredentialForUrl(url: url)
    }
}
