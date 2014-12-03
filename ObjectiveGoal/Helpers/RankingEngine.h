//
//  RankingEngine.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 03/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface RankingEngine : NSObject

+ (RACSignal *)rankedPlayersFromPlayers:(NSArray *)players basedOnMatches:(NSArray *)matches;

@end
