//
//  RankingEngine.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 03/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RankingEngine.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation RankingEngine

+ (RACSignal *)rankedPlayersFromPlayers:(NSArray *)players basedOnMatches:(NSArray *)matches {
    return [RACSignal return:players];
}

@end
