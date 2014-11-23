//
//  EditMatchViewModel.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "EditMatchViewModel.h"
#import "Player.h"
#import "SelectPlayersViewModel.h"
#import "APIClient.h"
#import <libextobjc/EXTScope.h>
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
    _homePlayers = [NSSet set];
    _awayPlayers = [NSSet set];

    RACSignal *validInputSignal = [RACSignal
        combineLatest:@[RACObserve(self, homePlayers), RACObserve(self, awayPlayers)]
        reduce:^(NSSet *homePlayers, NSSet *awayPlayers){
            return @(homePlayers.count > 0 && awayPlayers.count > 0);
        }];

    @weakify(self);

    _saveCommand = [[RACCommand alloc]
        initWithEnabled:validInputSignal
        signalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.apiClient createMatchWithHomePlayers:self.homePlayers awayPlayers:self.awayPlayers homeGoals:self.homeGoals awayGoals:self.awayGoals];
        }];

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

- (instancetype)init {
    return [self initWithAPIClient:nil];
}

#pragma mark - View Models

- (SelectPlayersViewModel *)selectHomePlayersViewModel {
    SelectPlayersViewModel *selectHomePlayersViewModel = [[SelectPlayersViewModel alloc] initWithAPIClient:self.apiClient initialPlayers:self.homePlayers];
    RAC(self, homePlayers) = selectHomePlayersViewModel.selectedPlayersSignal;
    return selectHomePlayersViewModel;
}

- (SelectPlayersViewModel *)selectAwayPlayersViewModel {
    SelectPlayersViewModel *selectAwayPlayersViewModel = [[SelectPlayersViewModel alloc] initWithAPIClient:self.apiClient initialPlayers:self.awayPlayers];
    RAC(self, awayPlayers) = selectAwayPlayersViewModel.selectedPlayersSignal;
    return selectAwayPlayersViewModel;
}

@end
