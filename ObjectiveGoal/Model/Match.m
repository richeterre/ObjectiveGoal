//
//  Match.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "Match.h"
#import "Player.h"
#import <libextobjc/EXTKeyPathCoding.h>

@interface Match ()

@property (nonatomic, copy, readonly) NSArray *homePlayersArray;
@property (nonatomic, copy, readonly) NSArray *awayPlayersArray;

@end

@implementation Match

#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @keypath(Match.new, identifier): @"id",
        @keypath(Match.new, homePlayersArray): @"home_players",
        @keypath(Match.new, awayPlayersArray): @"away_players",
        @keypath(Match.new, homeGoals): @"home_goals",
        @keypath(Match.new, awayGoals): @"away_goals"
    };
}

+ (NSValueTransformer *)homePlayersArrayJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Player.class];
}

+ (NSValueTransformer *)awayPlayersArrayJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Player.class];
}

#pragma mark - Lifecycle

- (instancetype)initWithIdentifier:(NSString *)identifier HomePlayers:(NSSet *)homePlayers awayPlayers:(NSSet *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    self = [super init];
    if (!self) return nil;

    _identifier = [identifier copy];
    _homePlayersArray = [homePlayers allObjects];
    _awayPlayersArray = [awayPlayers allObjects];
    _homeGoals = homeGoals;
    _awayGoals = awayGoals;

    return self;
}

#pragma mark - Custom Accessors

- (NSSet *)homePlayers {
    return [NSSet setWithArray:_homePlayersArray];
}

- (NSSet *)awayPlayers {
    return [NSSet setWithArray:_awayPlayersArray];
}

@end
