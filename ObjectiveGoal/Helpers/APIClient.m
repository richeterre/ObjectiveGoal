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
#import <NSArray+BlocksKit.h>

static NSString * const APIClientUserDefaultsKeyMatches = @"Matches";
static NSTimeInterval const APIClientFakeLatency = 0.5;

@interface APIClient ()

@property (nonatomic, strong, readonly) APISessionManager *apiSessionManager;
@property (nonatomic, copy) NSArray *matches;

@end

@implementation APIClient

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _apiSessionManager = [[APISessionManager alloc] init];
    _matches = [self persistedMatches];

    return self;
}

#pragma mark - Matches

- (RACSignal *)fetchMatches {
    return [[RACSignal return:self.matches] delay:APIClientFakeLatency];
}

- (RACSignal *)createMatchWithHomePlayers:(NSSet *)homePlayers awayPlayers:(NSSet *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    Match *newMatch = [[Match alloc] initWithHomePlayers:homePlayers awayPlayers:awayPlayers homeGoals:homeGoals awayGoals:awayGoals];

    self.matches = [self.matches arrayByAddingObject:newMatch];
    return [[RACSignal return:@(YES)] delay:APIClientFakeLatency];
}

- (RACSignal *)updateMatch:(Match *)match withHomePlayers:(NSSet *)homePlayers awayPlayers:(NSSet *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    if (![self.matches containsObject:match]) {
        // No match found => Failure
        return [[RACSignal return:@(NO)] delay:APIClientFakeLatency];
    } else {
        self.matches = [self.matches bk_map:^(Match *existingMatch) {
            if ([existingMatch isEqual:match]) {
                // Replace with updated match
                return [[Match alloc] initWithHomePlayers:homePlayers awayPlayers:awayPlayers homeGoals:homeGoals awayGoals:awayGoals];
            }
            return existingMatch;
        }];

        // Match updated => Success
        return [[RACSignal return:@(YES)] delay:APIClientFakeLatency];
    }
}

- (RACSignal *)deleteMatch:(Match *)match {
    if (![self.matches containsObject:match]) {
        // No match found => Failure
        return [[RACSignal return:@(NO)] delay:APIClientFakeLatency];
    } else {
        self.matches = [self.matches bk_reject:^(Match *existingMatch) {
            return [existingMatch isEqual:match];
        }];

        // Match deleted => Success
        return [[RACSignal return:@(YES)] delay:APIClientFakeLatency];
    }
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
            return response.statusCode == 200 ? @(YES) : @(NO);
        }];
}

#pragma mark - Persistence

- (void)persist {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSData *archivedMatches = [NSKeyedArchiver archivedDataWithRootObject:self.matches];
    [userDefaults setObject:archivedMatches forKey:APIClientUserDefaultsKeyMatches];

    [userDefaults synchronize];
}

- (NSArray *)persistedMatches {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedMatches = [userDefaults objectForKey:APIClientUserDefaultsKeyMatches];

    return (archivedMatches
            ? [NSKeyedUnarchiver unarchiveObjectWithData:archivedMatches]
            : @[]);
}

@end
