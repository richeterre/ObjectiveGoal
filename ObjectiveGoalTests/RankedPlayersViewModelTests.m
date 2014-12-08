//
//  RankedPlayersViewModelTests.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RankedPlayersViewModel.h"
#import "Player.h"
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

- (void)testThatPlayersAreFetchedInRankedOrderWhenActive {
    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    [[mockAPIClient expect] fetchRankedPlayers];

    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;

    [mockAPIClient verify];
}

- (void)testProgressIndicatorVisibleSignal {
    XCTestExpectation *visibleExpectation = [self expectationWithDescription:@"Progress indicator should be visible"];
    XCTestExpectation *hiddenExpectation = [self expectationWithDescription:@"Progress indicator should be hidden"];

    id mockAPIClient = [TestHelper mockAPIClientReturningRankedPlayers:@[[NSObject new]]];
    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];

    RACDisposable *disposable = [self.sut.progressIndicatorVisibleSignal subscribeNext:^(NSNumber *visible) {
        XCTAssertTrue([visible isKindOfClass:NSNumber.class]);
        if (visible.boolValue) {
            [visibleExpectation fulfill];
        } else {
            [hiddenExpectation fulfill];
        }
    }];

    self.sut.active = YES;

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        [disposable dispose];
    }];
}

- (void)testNumberOfItemsAfterFetching {
    id mockAPIClient = [TestHelper mockAPIClientReturningRankedPlayers:@[[NSObject new]]];

    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqual([self.sut numberOfItemsInSection:0], 1);
}

- (void)testThatUpdatedContentSignalSendsNext {
    XCTestExpectation *expectation = [self expectationWithDescription:@"updatedContentSignal should fire"];

    id mockAPIClient = [TestHelper mockAPIClientReturningRankedPlayers:@[[NSObject new]]];
    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];

    RACDisposable *disposable = [self.sut.updatedContentSignal subscribeNext:^(id x) {
        [expectation fulfill];

        XCTAssertEqual(x, @(YES));
    }];

    self.sut.active = YES;

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        [disposable dispose];
    }];
}

- (void)testPlayerName {
    Player *samplePlayer = [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"A"];

    id mockAPIClient = [TestHelper mockAPIClientReturningRankedPlayers:@[samplePlayer]];
    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqualObjects([self.sut playerNameAtRow:0 inSection:0], @"A");
}

- (void)testPlayerPoints {
    NSArray *samplePlayers = @[
        [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"A" rating:5],
        [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"B" rating:4.95],
        [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"B" rating:5.04]
    ];

    id mockAPIClient = [TestHelper mockAPIClientReturningRankedPlayers:samplePlayers];
    self.sut = [[RankedPlayersViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqualObjects([self.sut playerRatingAtRow:0 inSection:0], @"5.0");
    XCTAssertEqualObjects([self.sut playerRatingAtRow:1 inSection:0], @"5.0");
    XCTAssertEqualObjects([self.sut playerRatingAtRow:2 inSection:0], @"5.0");
}

@end
