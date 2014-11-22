//
//  EditMatchViewModel.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "EditMatchViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation EditMatchViewModel

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _name = @"New Match";

    RAC(self, homeGoalsString) = [RACObserve(self, homeGoals) map:^(NSNumber *goals) {
        return [NSString stringWithFormat:@"%lu", (unsigned long)goals.unsignedIntegerValue];
    }];

    RAC(self, awayGoalsString) = [RACObserve(self, awayGoals) map:^(NSNumber *goals) {
        return [NSString stringWithFormat:@"%lu", (unsigned long)goals.unsignedIntegerValue];
    }];

    return self;
}

@end
