//
//  SelectPlayersViewModelTests.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SelectPlayersViewModel.h"
#import "Player.h"
#import "APIClient.h"
#import "TestHelper.h"
#import <OCMock/OCMock.h>

@interface SelectPlayersViewModelTests : XCTestCase

@property (nonatomic, strong) SelectPlayersViewModel *sut;

@end

@implementation SelectPlayersViewModelTests

- (void)setUp {
    [super setUp];
    self.sut = [[SelectPlayersViewModel alloc] init];
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
    [[mockAPIClient expect] fetchPlayers];

    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:nil disabledPlayers:nil];
    self.sut.active = YES;

    [mockAPIClient verify];
}

- (void)testNumberOfRowsAfterFetching {
    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:@[[NSObject new]]];

    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:nil disabledPlayers:nil];
    self.sut.active = YES;
    XCTAssertEqual([self.sut numberOfItemsInSection:0], 1);
}

- (void)testProgressIndicatorVisibleSignal {
    XCTestExpectation *visibleExpectation = [self expectationWithDescription:@"Progress indicator should be visible"];
    XCTestExpectation *hiddenExpectation = [self expectationWithDescription:@"Progress indicator should be hidden"];

    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:@[[NSObject new]]];
    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:nil disabledPlayers:nil];

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

- (void)testInitialPlayersAreSelected {
    NSSet *initialPlayers = [NSSet setWithObject:[self samplePlayers].firstObject];

    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:[self samplePlayers]];
    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:initialPlayers disabledPlayers:nil];
    self.sut.active = YES;

    XCTAssertTrue([self.sut isPlayerSelectedAtRow:0 inSection:0]);
    XCTAssertFalse([self.sut isPlayerSelectedAtRow:1 inSection:0]);
}

- (void)testDisabledPlayersCannotBeSelected {
    NSSet *disabledPlayers = [NSSet setWithObject:[self samplePlayers].firstObject];

    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:[self samplePlayers]];
    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:nil disabledPlayers:disabledPlayers];
    self.sut.active = YES;

    XCTAssertFalse([self.sut canSelectPlayerAtRow:0 inSection:0]);
    XCTAssertTrue([self.sut canSelectPlayerAtRow:1 inSection:0]);
}

- (void)testSelectPlayer {
    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:[self samplePlayers]];
    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:nil disabledPlayers:nil];
    self.sut.active = YES;

    [self.sut selectPlayerAtRow:0 inSection:0];

    XCTAssertTrue([self.sut isPlayerSelectedAtRow:0 inSection:0]);
    XCTAssertFalse([self.sut isPlayerSelectedAtRow:1 inSection:0]);
}

- (void)testDeselectPlayer {
    NSSet *initialPlayers = [NSSet setWithArray:[self samplePlayers]];

    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:[self samplePlayers]];
    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:initialPlayers disabledPlayers:nil];
    self.sut.active = YES;

    [self.sut deselectPlayerAtRow:0 inSection:0];

    XCTAssertFalse([self.sut isPlayerSelectedAtRow:0 inSection:0]);
    XCTAssertTrue([self.sut isPlayerSelectedAtRow:1 inSection:0]);
}

- (void)testPlayerInputValidation {
    XCTestExpectation *emptyInvalidExpectation = [self expectationWithDescription:@"Empty player name should be invalid"];

    // Skip first value to monitor signal changes after providing first input
    RACDisposable *disposable = [[self.sut.validPlayerInputSignal skip:1] subscribeNext:^(NSNumber *valid) {
        XCTAssertTrue([valid isKindOfClass:NSNumber.class]);
        if (!valid.boolValue) {
            [emptyInvalidExpectation fulfill];
        }
    }];

    self.sut.playerInputName = @"";

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        [disposable dispose];
    }];
}

#pragma mark - Internal Helpers

- (NSArray *)samplePlayers {
    return @[
        [[Player alloc] initWithIdentifier:@"a" name:@"A"],
        [[Player alloc] initWithIdentifier:@"b" name:@"B"]
    ];
}

@end
