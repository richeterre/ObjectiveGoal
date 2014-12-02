//
//  SelectPlayersViewModel.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "SelectPlayersViewModel.h"
#import "Player.h"
#import "APIClient.h"
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SelectPlayersViewModel ()

@property (nonatomic, strong) APIClient *apiClient;

@property (nonatomic, strong) NSArray *players;
@property (nonatomic, copy) NSSet *selectedPlayers;
@property (nonatomic, copy) NSSet *disabledPlayers;

@end

@implementation SelectPlayersViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAPIClient:(APIClient *)apiClient initialPlayers:(NSSet *)initialPlayers disabledPlayers:(NSSet *)disabledPlayers {
    self = [super init];
    if (!self) return nil;

    _apiClient = apiClient;
    _selectedPlayers = [initialPlayers copy] ?: [NSSet set];
    _selectedPlayersSignal = RACObserve(self, selectedPlayers);
    _disabledPlayers = [disabledPlayers copy] ?: [NSSet set];

    _validPlayerInputSignal = [RACObserve(self, playerInputName) map:^(NSString *name) {
        return @(name.length > 0);
    }];

    _updatedContentSignal = [[RACObserve(self, players) ignore:nil] mapReplace:@(YES)];

    @weakify(self);

    _savePlayerCommand = [[RACCommand alloc] initWithEnabled:_validPlayerInputSignal signalBlock:^RACSignal *(id _) {
        @strongify(self);
        return [self.apiClient createPlayerWithName:self.playerInputName];
    }];

    RACSignal *playerAddedSignal = [_savePlayerCommand.executionSignals flatten];

    RACSignal *refreshSignal = [RACSignal
        merge:@[
            self.didBecomeActiveSignal,
            playerAddedSignal
        ]];

    [refreshSignal subscribeNext:^(id _) {
        @strongify(self);
        RAC(self, players) = [apiClient fetchPlayers];
    }];

    RACSignal *isRefreshingSignal = [RACSignal
        merge:@[
            [refreshSignal mapReplace:@(YES)],
            [_updatedContentSignal mapReplace:@(NO)]
        ]];

    RACSignal *isSavingSignal = _savePlayerCommand.executing;

    _progressIndicatorVisibleSignal = [[RACSignal
        combineLatest:@[isRefreshingSignal, isSavingSignal]]
        or];

    return self;
}

- (instancetype)init {
    return [self initWithAPIClient:nil initialPlayers:nil disabledPlayers:nil];
}

#pragma mark - Content

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.players.count;
}

- (NSString *)playerNameAtRow:(NSInteger)row inSection:(NSInteger)section {
    Player *player = [self playerAtRow:row inSection:section];
    return player.name;
}

- (BOOL)isPlayerSelectedAtRow:(NSInteger)row inSection:(NSInteger)section {
    Player *player = [self playerAtRow:row inSection:section];
    return [self.selectedPlayers containsObject:player];
}

- (BOOL)canSelectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section {
    Player *player = [self playerAtRow:row inSection:section];
    return ![self.disabledPlayers containsObject:player];
}

#pragma mark - Player Selection

- (void)selectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section {
    Player *player = [self playerAtRow:row inSection:section];
    [self selectPlayer:player];
}

- (void)deselectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section {
    Player *player = [self playerAtRow:row inSection:section];
    [self deselectPlayer:player];
}

#pragma mark - Internal Helpers

- (Player *)playerAtRow:(NSInteger)row inSection:(NSInteger)section {
    return self.players[row];
}

- (void)selectPlayer:(Player *)player {
    self.selectedPlayers = [self.selectedPlayers setByAddingObject:player];
}

- (void)deselectPlayer:(Player *)player {
    NSMutableSet *mutableSelectedPlayers = [self.selectedPlayers mutableCopy];
    [mutableSelectedPlayers removeObject:player];
    self.selectedPlayers = [mutableSelectedPlayers copy];
}

@end
