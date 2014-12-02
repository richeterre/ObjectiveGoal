//
//  RankedPlayersViewModelTests.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RankedPlayersViewModel.h"
#import "APIClient.h"
#import "TestHelper.h"
#import <OCMock/OCMock.h>

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

- (void)testThatPlayersAreFetchedWhenActive {
    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    [[mockAPIClient expect] fetchPlayers];

    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;

    [mockAPIClient verify];
}

- (void)testNumberOfItemsAfterFetching {
    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:@[[NSObject new]]];

    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqual([self.sut numberOfItemsInSection:0], 1);
}

@end
