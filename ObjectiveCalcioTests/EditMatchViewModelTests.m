//
//  EditMatchViewModelTests.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EditMatchViewModel.h"

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

@end
