//
//  Credential.swift
//  Implementation of the CredentialProtocol to supply the credential to network-related commands
//
//  Created by Lightech on 10/24/2048.
//

import SwiftUI
import XGit

public enum CredentialKind: String, CaseIterable, Identifiable, Codable {
    case ssh
    case password
    public var id: String { self.rawValue }
}

public protocol GitCredential: CredentialProtocol {
    // Unique identifier
    var id: String { get set }
    var kind: CredentialKind { get set }

    // The remote URLs this credential applies: when the remote URL starts with this string
    var targetURL: String { get set }

    // For basic authentication
    var userName: String? { get set }
    var password: (() -> String?)? { get }

    // For SSH authentication
    var publicKey: String? { get set }
    var privateKey: (() -> String?)? { get }
}

public class KeychainCredential: CredentialProtocol, Identifiable, GitCredential {
    public func isSSHAuthenticationMethod() -> Bool {
        return kind == .ssh
    }
    
    public func getSSHPublic() -> String {
        return publicKey ?? ""
    }
    
    public func getSSHPrivate() -> String {
        return privateKey?() ?? ""
    }
    
    // Unique identifier
    public var id: String
    public var kind: CredentialKind

    // The remote URLs this credential applies: when the remote URL starts with this string
    public var targetURL: String

    // For basic authentication
    public var userName: String?
    public var password: (() -> String?)?

    // For SSH authentication
    public var publicKey: String?
    public var privateKey: (() -> String?)?

    public init(
        id: String,
        kind: CredentialKind,
        targetURL: String,
        userName: String,
        password: @escaping @autoclosure () -> String
    ) {
        self.id = id
        self.kind = kind
        self.targetURL = targetURL
        self.userName = userName
        self.password = password
    }

    public init(
        id: String,
        kind: CredentialKind,
        targetURL: String,
        publicKey: String,
        privateKey: @escaping @autoclosure () -> String
    ) {
        self.id = id
        self.userName = "git"
        self.kind = kind
        self.targetURL = targetURL
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

    public func isUserNamePasswordAuthenticationMethod() -> Bool {
        return kind == .password
    }

    public func getUserName() -> String {
        return userName!
    }

    public func getPassword() -> String {
        return (password?()) ?? ""
    }
}

@available(iOS 14, macOS 11.0, *)
public class Credential: Identifiable, Codable, GitCredential {
    // Unique identifier
    public var id: String
    public var kind: CredentialKind

    // The remote URLs this credential applies: when the remote URL starts with this string
    public var targetURL: String

    // For basic authentication
    public var userName: String?
    private var _password: String?

    public var password: (() -> String?)? {
        { [weak self] in
            return self?._password
        }
    }

    // For SSH authentication
    public var publicKey: String?
    private var _privateKey: String?

    public var privateKey: (() -> String?)? {
        { [weak self] in
            return self?._privateKey
        }
    }

    public init(id: String, kind: CredentialKind, targetURL: String, userName: String, password: String) {
        self.id = id
        self.kind = kind
        self.targetURL = targetURL
        self.userName = userName
        self._password = password
    }

    public init(id: String, kind: CredentialKind, targetURL: String, publicKey: String, privateKey: String) {
        self.id = id
        self.kind = kind
        self.targetURL = targetURL
        self.publicKey = publicKey
        self._privateKey = privateKey
    }

    public func isUserNamePasswordAuthenticationMethod() -> Bool {
        return kind == .password
    }

    public func isSSHAuthenticationMethod() -> Bool {
        kind == .ssh
    }

    public func getUserName() -> String {
        return userName!
    }

    public func getPassword() -> String {
        return _password!
    }

    public func getSSHPublic() -> String {
        return publicKey ?? ""
    }

    public func getSSHPrivate() -> String {
        return privateKey?() ?? ""
    }
}
