//
//  RankingEngine.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 03/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RankingEngine.h"
#import "Match.h"
#import "Player.h"
#import <BlocksKit/NSArray+BlocksKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSUInteger const RankingEnginePointsWin = 3;
static NSUInteger const RankingEnginePointsTie = 1;
static NSUInteger const RankingEnginePointsLoss = 0;

@implementation RankingEngine

#pragma mark - Ranking

+ (RACSignal *)rankedPlayersFromPlayers:(NSArray *)players basedOnMatches:(NSArray *)matches {

    // Define block that compares two players
    NSComparisonResult (^comparePlayersBlock)(Player *, Player *) = ^(Player *first, Player *second) {
        NSInteger firstPoints = [matches
            bk_reduceInteger:0 withBlock:^NSInteger(NSInteger points, Match *match) {
                return points + [RankingEngine pointsForPlayer:first fromMatch:match];
            }];
        NSInteger secondPoints = [matches
            bk_reduceInteger:0 withBlock:^NSInteger(NSInteger points, Match *match) {
                return points + [RankingEngine pointsForPlayer:second fromMatch:match];
            }];

        if (firstPoints > secondPoints) {
            return NSOrderedAscending;
        } else if (firstPoints < secondPoints) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    };

    // Sort players on background thread
    return [RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault] block:^(id<RACSubscriber> subscriber) {
        NSArray *rankedPlayers = [players sortedArrayUsingComparator:comparePlayersBlock];

        [subscriber sendNext:rankedPlayers];
        [subscriber sendCompleted];
    }];
}

#pragma mark - Internal Helpers

+ (NSUInteger)pointsForPlayer:(Player *)player fromMatch:(Match *)match {
    BOOL isHomePlayer = [match.homePlayers containsObject:player];
    BOOL isAwayPlayer = [match.awayPlayers containsObject:player];

    if (!isHomePlayer && !isAwayPlayer) return 0; // Didn't play in this match

    if (match.homeGoals > match.awayGoals) {
        return isHomePlayer ? RankingEnginePointsWin : RankingEnginePointsLoss;
    } else if (match.homeGoals < match.awayGoals) {
        return isHomePlayer ? RankingEnginePointsLoss : RankingEnginePointsWin;
    } else {
        return RankingEnginePointsTie;
    }
}

@end
