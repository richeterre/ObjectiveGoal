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
#import <libextobjc/EXTKeyPathCoding.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSUInteger const RankingEnginePointsWin = 3;
static NSUInteger const RankingEnginePointsTie = 1;
static NSUInteger const RankingEnginePointsLoss = 0;

@implementation RankingEngine

#pragma mark - Ranking

+ (RACSignal *)rankedPlayersFromPlayers:(NSArray *)players basedOnMatches:(NSArray *)matches {

    // Sort players on background thread
    return [RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault] block:^(id<RACSubscriber> subscriber) {

        // Map unrated to rated players
        NSArray *ratedPlayers = [players bk_map:^(Player *player) {
            NSArray *relevantMatches = [matches bk_select:^BOOL(Match *match) {
                return ([match.homePlayers containsObject:player]
                        || [match.awayPlayers containsObject:player]);
            }];

            // Accumulate points from player's own matches
            NSInteger points = [relevantMatches bk_reduceInteger:0 withBlock:^NSInteger(NSInteger points, Match *match) {
                return points + [RankingEngine pointsForPlayer:player fromMatch:match];
            }];

            // Return new rated player
            CGFloat rating = [RankingEngine ratingForPoints:points fromNumberOfMatches:relevantMatches.count];
            return [[Player alloc] initWithIdentifier:player.identifier name:player.name rating:rating];
        }];

        NSSortDescriptor *ratingDescriptor = [NSSortDescriptor sortDescriptorWithKey:@keypath(Player.new, rating) ascending:NO];
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@keypath(Player.new, name) ascending:YES];

        NSArray *rankedPlayers = [ratedPlayers sortedArrayUsingDescriptors:@[ratingDescriptor, nameDescriptor]];

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

+ (CGFloat)ratingForPoints:(NSUInteger)points fromNumberOfMatches:(NSUInteger)numberOfMatches {
    if (numberOfMatches > 0) {
        return (CGFloat)points / (RankingEnginePointsWin * numberOfMatches) * 10;
    }
    return PlayerDefaultRating;
}

@end
