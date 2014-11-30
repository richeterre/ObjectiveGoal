//
//  NewPlayerViewModel.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 30/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "NewPlayerViewModel.h"
#import "APIClient.h"

@implementation NewPlayerViewModel

- (instancetype)initWithAPIClient:(APIClient *)apiClient {
    self = [super init];
    if (!self) return nil;

    _validInputSignal = [RACObserve(self, inputText) map:^(NSString *text) {
        return @(text.length > 0);
    }];

    return self;
}

@end
