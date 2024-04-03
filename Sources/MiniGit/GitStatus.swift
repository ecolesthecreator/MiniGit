//
//  GitStatus.swift
//  Implementation of StatusProtocol to host the result of the `git status` command
//
//  Created by Lightech on 10/24/2048.
//

import SwiftUI
import XGit

@available(iOS 14, macOS 11.0, *)
public class GitStatus: StatusProtocol, ObservableObject {

    // Copy from git_repository_state_t, declared in libgit2 repository.h
    public enum GitRepositoryState: Int32, CustomStringConvertible {
        case NONE
        case MERGE
        case REVERT
        case REVERT_SEQUENCE
        case CHERRYPICK
        case CHERRYPICK_SEQUENCE
        case BISECT
        case REBASE
        case REBASE_INTERACTIVE
        case REBASE_MERGE
        case APPLY_MAILBOX
        case APPLY_MAILBOX_OR_REBASE

        public var description: String {
            switch self {

            case .NONE:
                return "None"
            case .MERGE:
                return "Merge"
            case .REVERT:
                return "Revert"
            case .REVERT_SEQUENCE:
                return "Revert Sequence"
            case .CHERRYPICK:
                return "Cherrypick"
            case .CHERRYPICK_SEQUENCE:
                return "Cherrypick Sequence"
            case .BISECT:
                return "Bisect"
            case .REBASE:
                return "Rebase"
            case .REBASE_INTERACTIVE:
                return "Interactive Rebase"
            case .REBASE_MERGE:
                return "Merge Rebase"
            case .APPLY_MAILBOX:
                return "Apply Mailbox"
            case .APPLY_MAILBOX_OR_REBASE:
                return "Apply Mailbox or Rebase"
            }
        }
    }

    @Published public var currentBranch: String = ""
    @Published public var stagedChanges: Diff = Diff()
    @Published public var unstagedChanges: Diff = Diff()
    @Published public var state: GitRepositoryState = .NONE

    public func setCurrentBranch(_ branchName: String) {
        self.currentBranch = branchName
    }

    public func setStagedChanges(_ changes: Diff) {
        self.stagedChanges = changes
    }

    public func setUnstagedChanges(_ changes: Diff) {
        self.unstagedChanges = changes
    }

    public func setState(_ state: Int32) {
        if let s = GitRepositoryState(rawValue: state) {
            self.state = s
        } else {
            print("Invalid repository state code \(state)")
        }
    }
}
