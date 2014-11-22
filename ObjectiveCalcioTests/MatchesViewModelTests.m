//
//  MatchesViewModelTests.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Match.h"
#import "MatchesViewModel.h"
#import "APIClient.h"
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MatchesViewModelTests : XCTestCase

@property (nonatomic, strong) MatchesViewModel *sut;

@end

@implementation MatchesViewModelTests

- (void)setUp {
    [super setUp];
    APIClient *apiClient = [[APIClient alloc] init]; // TODO: Replace by proper mock
    self.sut = [[MatchesViewModel alloc] initWithAPIClient:apiClient];
}

- (void)tearDown {
    self.sut = nil;
    [super tearDown];
}

- (void)testNumberOfSections {
    XCTAssertEqual([self.sut numberOfSections], 1);
}

- (void)testThatNumberOfRowsIsInitiallyZero {
    XCTAssertEqual([self.sut numberOfItemsInSection:0], 0);
}

- (void)testThatMatchesAreFetchedWhenActive {
    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    [[mockAPIClient expect] fetchMatches];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;

    [mockAPIClient verify];
}

- (void)testNumberOfRowsAfterFetching {
    id mockAPIClient = [self mockAPIClientReturningObject:[NSObject new]];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqual([self.sut numberOfItemsInSection:0], 1);
}

- (void)testHomePlayers {
    NSString *homePlayers = @"Home Players";
    id mockMatch = [OCMockObject mockForClass:Match.class];
    [[[mockMatch expect] andReturn:homePlayers] homePlayers];

    id mockAPIClient = [self mockAPIClientReturningObject:mockMatch];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqual([self.sut homePlayersAtRow:0 inSection:0], homePlayers);
}

- (void)testAwayPlayers {
    NSString *awayPlayers = @"Away Players";
    id mockMatch = [OCMockObject mockForClass:Match.class];
    [[[mockMatch expect] andReturn:awayPlayers] awayPlayers];

    id mockAPIClient = [self mockAPIClientReturningObject:mockMatch];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqual([self.sut awayPlayersAtRow:0 inSection:0], awayPlayers);
}

- (void)testResult {
    NSString *result = @"1:7";
    id mockMatch = [OCMockObject mockForClass:Match.class];
    [[[mockMatch expect] andReturnValue:OCMOCK_VALUE(1)] homeGoals];
    [[[mockMatch expect] andReturnValue:OCMOCK_VALUE(7)] awayGoals];

    id mockAPIClient = [self mockAPIClientReturningObject:mockMatch];

    self.sut = [[MatchesViewModel alloc] initWithAPIClient:mockAPIClient];
    self.sut.active = YES;
    XCTAssertEqualObjects([self.sut resultAtRow:0 inSection:0], result);
}

- (void)testThatUpdatedContentSignalIsSetUp {
    XCTAssertNotNil(self.sut.updatedContentSignal);
}

#pragma mark - Internal Helpers

- (OCMockObject *)mockAPIClientReturningObject:(id)object {
    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    RACSignal *instantResponse = [RACSignal return:@[object]];
    [[[mockAPIClient stub] andReturn:instantResponse] fetchMatches];
    return mockAPIClient;
}

@end
