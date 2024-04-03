//
//  DiffDelta.h
//  Declaration of DiffDelta class which is data converted from libgit2's git_diff_delta
//
//  Created by Lightech on 10/24/2048.
//

#import "DiffFile.h"
#import "DiffHunk.h"

/// The type of change that this delta represents.
///
/// GTDeltaTypeUnmodified - No Change.
/// GTDeltaTypeAdded      - The file was added to the index.
/// GTDeltaTypeDeleted    - The file was removed from the working directory.
/// GTDeltaTypeModified   - The file was modified.
/// GTDeltaTypeRenamed    - The file has been renamed.
/// GTDeltaTypeCopied     - The file was duplicated.
/// GTDeltaTypeIgnored    - The file was ignored by git.
/// GTDeltaTypeUntracked  - The file has been added to the working directory
///                             and is therefore currently untracked.
/// GTDeltaTypeTypeChange - The file has changed from a blob to either a
///                             submodule, symlink or directory. Or vice versa.
/// GTDeltaTypeConflicted - The file is conflicted in the working directory.
typedef NS_ENUM(NSUInteger, DiffDeltaType) {
    DiffDeltaTypeUnmodified = 0,
    DiffDeltaTypeAdded = 1,
    DiffDeltaTypeDeleted = 2,
    DiffDeltaTypeModified = 3,
    DiffDeltaTypeRenamed = 4,
    DiffDeltaTypeCopied = 5,
    DiffDeltaTypeIgnored = 6,
    DiffDeltaTypeUntracked = 7,
    DiffDeltaTypeTypeChange = 8,
    DiffDeltaTypeUnreadable = 9,
    DiffDeltaTypeConflicted = 10,
};

@interface DiffDelta: NSObject

/**
 * ID to conform to SwiftUI's Identifiable
 */
@property (readonly, nonnull) NSUUID *id;

/**
 * The old file (base of comparison)
 */
@property (readonly, nonnull) DiffFile *theOldFile;

/**
 * The new file (target of comparison)
 *     base + this diff = target
 *
 * Note: We would like to write newFile but Objective-C doesn't like that.
 */
@property (readonly, nonnull) DiffFile *theNewFile;

@property (readonly) DiffDeltaType type;

/**
 * The list of diff hunks
 */
@property (readonly, nonnull) NSArray<DiffHunk*> *hunks;

@end
