//
//  APIClient.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "APIClient.h"
#import "Match.h"
#import "Player.h"
#import "RankingEngine.h"
#import "APISessionManager.h"
#import <AFNetworking-RACExtensions/AFHTTPSessionManager+RACSupport.h>

static NSTimeInterval const APIClientFakeLatency = 0.5;

@interface APIClient ()

@property (nonatomic, strong, readonly) APISessionManager *apiSessionManager;

@end

@implementation APIClient

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _apiSessionManager = [[APISessionManager alloc] init];

    return self;
}

#pragma mark - Matches

- (RACSignal *)fetchMatches {
    return [[self.apiSessionManager rac_GET:@"matches" parameters:nil]
        map:^(RACTuple *tuple) {
            NSArray *matchesJSONArray = tuple.first;
            return [MTLJSONAdapter modelsOfClass:Match.class fromJSONArray:matchesJSONArray error:NULL];
        }];
}

- (RACSignal *)createMatchWithHomePlayers:(NSSet *)homePlayers awayPlayers:(NSSet *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    NSArray *homePlayerIdentifiers = [Player identifiersForPlayers:homePlayers].allObjects;
    NSArray *awayPlayerIdentifiers = [Player identifiersForPlayers:awayPlayers].allObjects;

    NSDictionary *parameters = @{
        @"home_player_ids": homePlayerIdentifiers,
        @"away_player_ids": awayPlayerIdentifiers,
        @"home_goals": @(homeGoals),
        @"away_goals": @(awayGoals)
    };
    return [[self.apiSessionManager rac_POST:@"matches" parameters:parameters]
        map:^(RACTuple *tuple) {
            NSHTTPURLResponse *response = tuple.second;
            return response.statusCode == 201 ? @(YES) : @(NO);
        }];
}

- (RACSignal *)updateMatch:(Match *)match withHomePlayers:(NSSet *)homePlayers awayPlayers:(NSSet *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    return [[RACSignal return:@(NO)] delay:APIClientFakeLatency];
}

- (RACSignal *)deleteMatch:(Match *)match {
    NSString *path = [NSString stringWithFormat:@"matches/%@", match.identifier];
    return [[self.apiSessionManager rac_DELETE:path parameters:nil]
        map:^(RACTuple *tuple) {
            NSHTTPURLResponse *response = tuple.second;
            return response.statusCode == 200 ? @(YES) : @(NO);
        }];
}

#pragma mark - Players

- (RACSignal *)fetchPlayers {
    return [[[self.apiSessionManager rac_GET:@"players" parameters:nil]
        map:^(RACTuple *tuple) {
            NSArray *playersJSONArray = tuple.first;
            return [MTLJSONAdapter modelsOfClass:Player.class fromJSONArray:playersJSONArray error:NULL];
        }]
        catchTo:[RACSignal return:@[]]];
}

- (RACSignal *)fetchRankedPlayers {
    return [[[RACSignal
        combineLatest:@[self.fetchPlayers, self.fetchMatches]]
        map:^(RACTuple *tuple) {
            RACTupleUnpack(NSArray *players, NSArray *matches) = tuple;
            return [RankingEngine rankedPlayersFromPlayers:players basedOnMatches:matches];
        }]
        switchToLatest];
}

- (RACSignal *)createPlayerWithName:(NSString *)name {
    NSDictionary *parameters = @{ @"name": name };
    return [[self.apiSessionManager rac_POST:@"players" parameters:parameters]
        map:^(RACTuple *tuple) {
            NSHTTPURLResponse *response = tuple.second;
            return response.statusCode == 201 ? @(YES) : @(NO);
        }];
}

@end
