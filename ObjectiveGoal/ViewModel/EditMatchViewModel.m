//
//  EditMatchViewModel.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "EditMatchViewModel.h"
#import "Match.h"
#import "Player.h"
#import "ManagePlayersViewModel.h"
#import "APIClient.h"
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EditMatchViewModel ()

@property (nonatomic, strong) APIClient *apiClient;

@end

@implementation EditMatchViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAPIClient:(APIClient *)apiClient match:(Match *)match
{
    self = [super init];
    if (!self) return nil;

    _apiClient = apiClient;

    BOOL isEditing = match != nil;

    if (isEditing) {
        _name = @"Edit Match";
        _homeGoals = match.homeGoals;
        _awayGoals = match.awayGoals;
        _homePlayers = match.homePlayers;
        _awayPlayers = match.awayPlayers;
    } else {
        _name = @"New Match";
        _homeGoals = 0;
        _awayGoals = 0;
        _homePlayers = [NSSet set];
        _awayPlayers = [NSSet set];
    }

    RACSignal *validInputSignal = [RACSignal
        combineLatest:@[RACObserve(self, homePlayers), RACObserve(self, awayPlayers)]
        reduce:^(NSSet *homePlayers, NSSet *awayPlayers){
            return @(homePlayers.count > 0 && awayPlayers.count > 0);
        }];

    @weakify(self);

    RACSignal *(^saveBlock)(id) = ^(id _){
        @strongify(self);
        return [self saveSignalForMatch:match];
    };

    _saveCommand = [[RACCommand alloc] initWithEnabled:validInputSignal signalBlock:saveBlock];

    _progressIndicatorVisibleSignal = _saveCommand.executing;

    NSString *(^formatGoalsBlock)(NSNumber *) = ^(NSNumber *goals){
        return [NSString stringWithFormat:@"%lu", (unsigned long)goals.unsignedIntegerValue];
    };

    RAC(self, homeGoalsString) = [RACObserve(self, homeGoals) map:formatGoalsBlock];
    RAC(self, awayGoalsString) = [RACObserve(self, awayGoals) map:formatGoalsBlock];

    NSString *(^formatPlayersBlock)(NSSet *) = ^(NSSet *players){
        if (players.count > 0) {
            return [[Player sortedPlayerNamesFromPlayers:players] componentsJoinedByString:@", "];
        } else {
            return @"Set Players";
        }
    };

    RAC(self, homePlayersString) = [RACObserve(self, homePlayers) map:formatPlayersBlock];
    RAC(self, awayPlayersString) = [RACObserve(self, awayPlayers) map:formatPlayersBlock];

    return self;
}

- (instancetype)initWithAPIClient:(APIClient *)apiClient {
    return [self initWithAPIClient:apiClient match:nil];
}

- (instancetype)init {
    return [self initWithAPIClient:nil];
}

#pragma mark - View Models

- (ManagePlayersViewModel *)manageHomePlayersViewModel {
    ManagePlayersViewModel *manageHomePlayersViewModel = [[ManagePlayersViewModel alloc] initWithAPIClient:self.apiClient initialPlayers:self.homePlayers disabledPlayers:self.awayPlayers];
    RAC(self, homePlayers) = manageHomePlayersViewModel.selectedPlayersSignal;
    return manageHomePlayersViewModel;
}

- (ManagePlayersViewModel *)manageAwayPlayersViewModel {
    ManagePlayersViewModel *manageAwayPlayersViewModel = [[ManagePlayersViewModel alloc] initWithAPIClient:self.apiClient initialPlayers:self.awayPlayers disabledPlayers:self.homePlayers];
    RAC(self, awayPlayers) = manageAwayPlayersViewModel.selectedPlayersSignal;
    return manageAwayPlayersViewModel;
}

#pragma mark - Internal Helpers

- (RACSignal *)saveSignalForMatch:(Match *)match {
    if (match) {
        return [self.apiClient updateMatch:match withHomePlayers:self.homePlayers awayPlayers:self.awayPlayers homeGoals:self.homeGoals awayGoals:self.awayGoals];
    } else {
        return [self.apiClient createMatchWithHomePlayers:self.homePlayers awayPlayers:self.awayPlayers homeGoals:self.homeGoals awayGoals:self.awayGoals];
    }
}

@end
