//
//  SelectPlayersViewModelTests.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SelectPlayersViewModel.h"
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

- (void)testProgressIndicatorVisibleSignal {
    XCTestExpectation *visibleExpectation = [self expectationWithDescription:@"progressIndicatorVisibleExpectation"];
    XCTestExpectation *hiddenExpectation = [self expectationWithDescription:@"progressIndicatorHiddenExpectation"];

    id mockAPIClient = [TestHelper mockAPIClientReturningPlayers:[NSObject new]];
    self.sut = [[SelectPlayersViewModel alloc] initWithAPIClient:mockAPIClient initialPlayers:nil];

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

@end
