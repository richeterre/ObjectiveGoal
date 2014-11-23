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

- (instancetype)initWithHomePlayers:(NSSet *)homePlayers awayPlayers:(NSSet *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    self = [super init];
    if (!self) return nil;

    _homePlayers = [homePlayers copy];
    _awayPlayers = [awayPlayers copy];
    _homeGoals = homeGoals;
    _awayGoals = awayGoals;

    return self;
}
@end
