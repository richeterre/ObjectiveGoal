//
//  MatchesViewModelTests.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Match.h"
#import "Player.h"
#import "MatchesViewModel.h"
#import "EditMatchViewModel.h"
#import "APIClient.h"
#import "TestHelper.h"
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MatchesViewModelTests : XCTestCase

@property (nonatomic, strong) MatchesViewModel *sut;

@end

@implementation MatchesViewModelTests

- (void)setUp {
    [super setUp];
    self.sut = [[MatchesViewModel alloc] init];
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

- (void)testThatMatchesAreFetchedWhenActive {
    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    [[mockAPIClient expect] fetchMatches];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;

    [mockAPIClient verify];
}

- (void)testNumberOfItemsAfterFetching {
    id mockAPIClient = [TestHelper mockAPIClientReturningMatches:@[[NSObject new]]];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqual([self.sut numberOfItemsInSection:0], 1);
}

- (void)testHomePlayersAreShownAlphabetically {
    NSSet *homePlayers = [NSSet setWithArray:@[
        [[Player alloc] initWithIdentifier:nil name:@"C"],
        [[Player alloc] initWithIdentifier:nil name:@"A"],
        [[Player alloc] initWithIdentifier:nil name:@"B"]
    ]];
    id mockMatch = [OCMockObject mockForClass:Match.class];
    [[[mockMatch expect] andReturn:homePlayers] homePlayers];

    id mockAPIClient = [TestHelper mockAPIClientReturningMatches:@[mockMatch]];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqualObjects([self.sut homePlayersAtRow:0 inSection:0], @"A, B, C");
}

- (void)testAwayPlayersAreShownAlphabetically {
    NSSet *awayPlayers = [NSSet setWithArray:@[
        [[Player alloc] initWithIdentifier:nil name:@"C"],
        [[Player alloc] initWithIdentifier:nil name:@"A"],
        [[Player alloc] initWithIdentifier:nil name:@"B"]
    ]];
    id mockMatch = [OCMockObject mockForClass:Match.class];
    [[[mockMatch expect] andReturn:awayPlayers] awayPlayers];

    id mockAPIClient = [TestHelper mockAPIClientReturningMatches:@[mockMatch]];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqualObjects([self.sut awayPlayersAtRow:0 inSection:0], @"A, B, C");
}

- (void)testResult {
    NSString *result = @"1:7";
    id mockMatch = [OCMockObject mockForClass:Match.class];
    [[[mockMatch expect] andReturnValue:OCMOCK_VALUE(1)] homeGoals];
    [[[mockMatch expect] andReturnValue:OCMOCK_VALUE(7)] awayGoals];

    id mockAPIClient = [TestHelper mockAPIClientReturningMatches:@[mockMatch]];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqualObjects([self.sut resultAtRow:0 inSection:0], result);
}

- (void)testThatUpdatedContentSignalIsSetUp {
    XCTAssertNotNil(self.sut.updatedContentSignal);
}

- (void)testThatUpdatedContentSignalSendsNext {
    XCTestExpectation *expectation = [self expectationWithDescription:@"updatedContentSignal should fire"];

    id mockAPIClient = [TestHelper mockAPIClientReturningMatches:@[[NSObject new]]];
    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];

    RACDisposable *disposable = [self.sut.updatedContentSignal subscribeNext:^(id x) {
        [expectation fulfill];

        XCTAssertEqual(x, @(YES));
    }];

    self.sut.active = YES;

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        [disposable dispose];
    }];
}

- (void)testProgressIndicatorVisibleSignal {
    XCTestExpectation *visibleExpectation = [self expectationWithDescription:@"Progress indicator should be visible"];
    XCTestExpectation *hiddenExpectation = [self expectationWithDescription:@"Progress indicator should be hidden"];

    id mockAPIClient = [TestHelper mockAPIClientReturningMatches:@[[NSObject new]]];
    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];

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

- (void)testEditViewModelForNewMatch {
    id editViewModel = [self.sut editViewModelForNewMatch];
    XCTAssertTrue([editViewModel isKindOfClass:EditMatchViewModel.class]);
}

@end
