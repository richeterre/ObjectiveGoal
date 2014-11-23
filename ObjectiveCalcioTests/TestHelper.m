//
//  TestHelper.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "TestHelper.h"
#import "APIClient.h"
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/RACSignal.h>

@implementation TestHelper

+ (OCMockObject *)mockAPIClientReturningMatches:(id)matches {
    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    RACSignal *instantResponse = [RACSignal return:@[matches]];
    [[[mockAPIClient stub] andReturn:instantResponse] fetchMatches];
    return mockAPIClient;
}

+ (OCMockObject *)mockAPIClientReturningPlayers:(id)players {
    id mockAPIClient = [OCMockObject mockForClass:APIClient.class];
    RACSignal *instantResponse = [RACSignal return:@[players]];
    [[[mockAPIClient stub] andReturn:instantResponse] fetchPlayers];
    return mockAPIClient;
}

@end
