//
//  MatchesViewModelTests.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MatchesViewModel.h"
#import "APIClient.h"

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

- (void)testThatUpdatedContentSignalIsSetUp {
    XCTAssertNotNil(self.sut.updatedContentSignal);
}

@end
