//
//  SelectPlayersViewModel.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "SelectPlayersViewModel.h"
#import "APIClient.h"
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SelectPlayersViewModel ()

@property (nonatomic, strong) NSArray *players;
@property (nonatomic, copy) NSSet *selectedPlayers;

@end

@implementation SelectPlayersViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAPIClient:(APIClient *)apiClient initialPlayers:(NSSet *)initialPlayers {
    self = [super init];
    if (!self) return nil;

    _selectedPlayers = [initialPlayers copy];
    _selectedPlayersSignal = RACObserve(self, selectedPlayers);

    RACSignal *refreshSignal = self.didBecomeActiveSignal;
    _updatedContentSignal = [[RACObserve(self, players) ignore:nil] mapReplace:@(YES)];

    @weakify(self);
    [refreshSignal subscribeNext:^(id _) {
        @strongify(self);
        RAC(self, players) = [apiClient fetchPlayers];
    }];

    return self;
}

#pragma mark - Content

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.players.count;
}

- (NSString *)playerNameAtRow:(NSInteger)row inSection:(NSInteger)section {
    return [self playerAtRow:row inSection:section];
}

- (BOOL)playerSelectedAtRow:(NSInteger)row inSection:(NSInteger)section {
    NSString *player = [self playerAtRow:row inSection:section];
    return [self.selectedPlayers containsObject:player];
}

#pragma mark - Player Selection

- (void)selectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section {
    NSString *player = [self playerAtRow:row inSection:section];
    [self selectPlayer:player];
}

- (void)deselectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section {
    NSString *player = [self playerAtRow:row inSection:section];
    [self deselectPlayer:player];
}

#pragma mark - Internal Helpers

- (NSString *)playerAtRow:(NSInteger)row inSection:(NSInteger)section {
    return self.players[row];
}

- (void)selectPlayer:(NSString *)player {
    self.selectedPlayers = [self.selectedPlayers setByAddingObject:player];
}

- (void)deselectPlayer:(NSString *)player {
    NSMutableSet *mutableSelectedPlayers = [self.selectedPlayers mutableCopy];
    [mutableSelectedPlayers removeObject:player];
    self.selectedPlayers = [mutableSelectedPlayers copy];
}

@end
