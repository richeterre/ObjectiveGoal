//
//  APIClient.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "APIClient.h"
#import "Match.h"

@implementation APIClient

- (RACSignal *)fetchMatches {
    NSArray *matches = @[
        [[Match alloc] initWithHomePlayers:@"Alice & Bob" awayPlayers:@"Charlie & Dora" homeGoals:3 awayGoals:2],
        [[Match alloc] initWithHomePlayers:@"Charlie & Bob" awayPlayers:@"Alice & Dora" homeGoals:0 awayGoals:2]
    ];

    return [[RACSignal return:matches] delay:1];
}

@end
