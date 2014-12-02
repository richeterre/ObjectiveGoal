//
//  RankedPlayersViewModelTests.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RankedPlayersViewModel.h"

@interface RankedPlayersViewModelTests : XCTestCase

@property (nonatomic, strong) RankedPlayersViewModel *sut;

@end

@implementation RankedPlayersViewModelTests

- (void)setUp {
    [super setUp];

    self.sut = [[RankedPlayersViewModel alloc] init];
}

- (void)tearDown {
    self.sut = nil;

    [super tearDown];
}

- (void)testNumberOfSections {
    XCTAssertEqual([self.sut numberOfSections], 1);
}

- (void)testThatNumberOfItemsIsInitiallyZero {
    XCTAssertEqual([self.sut numberOfItemsInSection:0], 0);
}

@end
