//
//  APIClient.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "APIClient.h"
#import "Match.h"

static NSString * const APIClientUserDefaultsKeyMatches = @"Matches";

@interface APIClient ()

@property (nonatomic, copy) NSArray *matches;

@end

@implementation APIClient

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _matches = [self persistedMatches] ?: @[];

    return self;
}

- (RACSignal *)fetchMatches {
    return [[RACSignal return:self.matches] delay:1];
}

- (void)createMatchWithHomePlayers:(NSString *)homePlayers awayPlayers:(NSString *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    Match *newMatch = [[Match alloc] initWithHomePlayers:homePlayers awayPlayers:awayPlayers homeGoals:homeGoals awayGoals:awayGoals];
    self.matches = [self.matches arrayByAddingObject:newMatch];
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
            : nil);
}

@end
