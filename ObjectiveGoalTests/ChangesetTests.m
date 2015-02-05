//
//  ChangesetTests.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 05/02/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UITableView.h>
#import "Changeset.h"

@interface ChangesetTests : XCTestCase

@end

@implementation ChangesetTests

- (void)testChangesetBetweenEmptyArrays
{
    Changeset *changeset = [Changeset changesetOfIndexPathsFromItems:@[] toItems:@[]];

    XCTAssertEqual(changeset.deletions.count, 0);
    XCTAssertEqual(changeset.insertions.count, 0);
}

- (void)testChangesetFromEmptyToNonEmptyArray
{
    Changeset *changeset = [Changeset changesetOfIndexPathsFromItems:@[] toItems:@[[NSObject new]]];

    XCTAssertEqual(changeset.deletions.count, 0);
    XCTAssertEqual(changeset.insertions.count, 1);
    XCTAssertEqual(changeset.insertions.firstObject, [NSIndexPath indexPathForRow:0 inSection:0]);
}

- (void)testChangesetFromNonEmptyToEmptyArray
{
    Changeset *changeset = [Changeset changesetOfIndexPathsFromItems:@[[NSObject new]] toItems:@[]];

    XCTAssertEqual(changeset.deletions.count, 1);
    XCTAssertEqual(changeset.deletions.firstObject, [NSIndexPath indexPathForRow:0 inSection:0]);
    XCTAssertEqual(changeset.insertions.count, 0);
}

- (void)testChangesetWithInsertedItems
{
    NSObject *firstItem = [NSObject new];
    NSObject *secondItem = [NSObject new];
    NSObject *firstInsertedItem = [NSObject new];
    NSObject *secondInsertedItem = [NSObject new];

    Changeset *changeset = [Changeset
        changesetOfIndexPathsFromItems:@[firstItem, secondItem]
        toItems:@[firstItem, firstInsertedItem, secondItem, secondInsertedItem]];

    XCTAssertEqual(changeset.deletions.count, 0);
    XCTAssertEqual(changeset.insertions.count, 2);
    XCTAssertEqual(changeset.insertions[0], [NSIndexPath indexPathForRow:1 inSection:0]);
    XCTAssertEqual(changeset.insertions[1], [NSIndexPath indexPathForRow:3 inSection:0]);
}

- (void)testChangesetWithDeletedItems
{
    NSObject *firstItem = [NSObject new];
    NSObject *secondItem = [NSObject new];
    NSObject *thirdItem = [NSObject new];
    NSObject *fourthItem = [NSObject new];

    Changeset *changeset = [Changeset
                            changesetOfIndexPathsFromItems:@[firstItem, secondItem, thirdItem, fourthItem]
                            toItems:@[firstItem, thirdItem]];

    XCTAssertEqual(changeset.deletions.count, 2);
    XCTAssertEqual(changeset.deletions[0], [NSIndexPath indexPathForRow:1 inSection:0]);
    XCTAssertEqual(changeset.deletions[1], [NSIndexPath indexPathForRow:3 inSection:0]);
    XCTAssertEqual(changeset.insertions.count, 0);
}

- (void)testChangesetWithDeletedAndInsertedItems
{
    NSObject *firstItem = [NSObject new];
    NSObject *secondItem = [NSObject new];
    NSObject *thirdItem = [NSObject new];
    NSObject *fourthItem = [NSObject new];

    NSObject *firstInsertedItem = [NSObject new];
    NSObject *secondInsertedItem = [NSObject new];

    Changeset *changeset = [Changeset
                            changesetOfIndexPathsFromItems:@[firstItem, secondItem, thirdItem, fourthItem]
                            toItems:@[firstInsertedItem, firstItem, secondInsertedItem, thirdItem]];

    XCTAssertEqual(changeset.deletions.count, 2);
    XCTAssertEqual(changeset.deletions[0], [NSIndexPath indexPathForRow:1 inSection:0]);
    XCTAssertEqual(changeset.deletions[1], [NSIndexPath indexPathForRow:3 inSection:0]);

    XCTAssertEqual(changeset.insertions.count, 2);
    XCTAssertEqual(changeset.insertions[0], [NSIndexPath indexPathForRow:0 inSection:0]);
    XCTAssertEqual(changeset.insertions[1], [NSIndexPath indexPathForRow:2 inSection:0]);
}

@end
