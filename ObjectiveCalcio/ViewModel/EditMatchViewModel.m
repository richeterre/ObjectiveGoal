//
//  EditMatchViewModel.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "EditMatchViewModel.h"
#import "SelectPlayersViewModel.h"
#import "APIClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EditMatchViewModel ()

@property (nonatomic, strong) APIClient *apiClient;

@end

@implementation EditMatchViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAPIClient:(APIClient *)apiClient
{
    self = [super init];
    if (!self) return nil;

    _apiClient = apiClient;

    _name = @"New Match";
    _homeGoals = 0;
    _awayGoals = 0;
    _homePlayers = @[];
    _awayPlayers = @[];

    NSString *(^formatGoalsBlock)(NSNumber *) = ^(NSNumber *goals){
        return [NSString stringWithFormat:@"%lu", (unsigned long)goals.unsignedIntegerValue];
    };

    RAC(self, homeGoalsString) = [RACObserve(self, homeGoals) map:formatGoalsBlock];
    RAC(self, awayGoalsString) = [RACObserve(self, awayGoals) map:formatGoalsBlock];

    return self;
}

- (instancetype)init {
    return [self initWithAPIClient:nil];
}

- (void)willDismiss {
    [self.apiClient createMatchWithHomePlayers:@"Home" awayPlayers:@"Away" homeGoals:self.homeGoals awayGoals:self.awayGoals];
}

#pragma mark - View Models

- (SelectPlayersViewModel *)selectHomePlayersViewModel {
    return [[SelectPlayersViewModel alloc] initWithAPIClient:self.apiClient selectedPlayers:self.homePlayers];
}

- (SelectPlayersViewModel *)selectAwayPlayersViewModel {
    return [[SelectPlayersViewModel alloc] initWithAPIClient:self.apiClient selectedPlayers:self.awayPlayers];
}

@end
