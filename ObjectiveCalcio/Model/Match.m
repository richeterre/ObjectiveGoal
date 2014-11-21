//
//  Match.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "Match.h"

@implementation Match

#pragma mark - Lifecycle

- (instancetype)initWithHomePlayers:(NSString *)homePlayers awayPlayers:(NSString *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    self = [super init];
    if (!self) return nil;

    _homePlayers = homePlayers;
    _awayPlayers = awayPlayers;
    _homeGoals = homeGoals;
    _awayGoals = awayGoals;

    return self;
}
@end
