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

static NSString * const APIClientUserDefaultsKeyMatches = @"Matches";
static NSTimeInterval const APIClientFakeLatency = 0.5;

@interface APIClient ()

@property (nonatomic, copy) NSArray *matches;

@end

@implementation APIClient

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

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

#pragma mark - Players

- (RACSignal *)fetchPlayers {
    NSArray *players = @[
        [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Alice"],
        [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Bob"],
        [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Charlie"],
        [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Dora"]
    ];
    return [[RACSignal return:players] delay:APIClientFakeLatency];
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
