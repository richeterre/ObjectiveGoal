//
//  EditMatchViewModelTests.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EditMatchViewModel.h"
#import "Player.h"
#import "APIClient.h"
#import <OCMock/OCMock.h>

@interface EditMatchViewModelTests : XCTestCase

@property (nonatomic, strong) EditMatchViewModel *sut;

@end

@implementation EditMatchViewModelTests

- (void)setUp {
    [super setUp];
    self.sut = [[EditMatchViewModel alloc] init];
}

- (void)tearDown {
    self.sut = nil;
    [super tearDown];
}

- (void)testName {
    XCTAssertEqualObjects(self.sut.name, @"New Match");
}

- (void)testHomeGoalsString {
    self.sut.homeGoals = 1;
    XCTAssertEqualObjects(self.sut.homeGoalsString, @"1");
}

- (void)testAwayGoalsString {
    self.sut.awayGoals = 1;
    XCTAssertEqualObjects(self.sut.awayGoalsString, @"1");
}

- (void)testHomePlayersString {
    self.sut.homePlayers = [NSSet setWithArray:@[
        [[Player alloc] initWithIdentifier:nil name:@"B"],
        [[Player alloc] initWithIdentifier:nil name:@"A"]
    ]];
    XCTAssertEqualObjects(self.sut.homePlayersString, @"A, B");
}

- (void)testAwayPlayersString {
    self.sut.awayPlayers = [NSSet setWithArray:@[
        [[Player alloc] initWithIdentifier:nil name:@"B"],
        [[Player alloc] initWithIdentifier:nil name:@"A"]
    ]];
    XCTAssertEqualObjects(self.sut.awayPlayersString, @"A, B");
}

// TODO: Add tests for input validation:
// * Save button disabled when home team is empty
// * Save button disabled when away team is empty
// * Save button enabled when neither team is empty

- (void)testTappingSaveButtonCreatesMatch {
    NSSet *homePlayers = [NSSet setWithArray:@[
        [[Player alloc] initWithIdentifier:nil name:@"A"],
        [[Player alloc] initWithIdentifier:nil name:@"B"]
    ]];
    NSSet *awayPlayers = [NSSet setWithArray:@[
        [[Player alloc] initWithIdentifier:nil name:@"C"],
        [[Player alloc] initWithIdentifier:nil name:@"D"]
    ]];
    NSUInteger homeGoals = 1;
    NSUInteger awayGoals = 0;

    XCTestExpectation *expectation = [self expectationWithDescription:@"createMatchExpectation"];

    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    [[[mockAPIClient expect] andReturn:[RACSignal return:@(YES)]] createMatchWithHomePlayers:homePlayers awayPlayers:awayPlayers homeGoals:homeGoals awayGoals:awayGoals];

    self.sut = [[EditMatchViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.homePlayers = homePlayers;
    self.sut.awayPlayers = awayPlayers;
    self.sut.homeGoals = homeGoals;
    self.sut.awayGoals = awayGoals;

    RACDisposable *disposable = [[self.sut.saveCommand execute:nil] subscribeNext:^(id x) {
        XCTAssertEqual(x, @(YES));
        [expectation fulfill];
    }];

    [mockAPIClient verify];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        [disposable dispose];
    }];
}

@end
