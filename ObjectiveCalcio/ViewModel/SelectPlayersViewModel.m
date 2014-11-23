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

@end

@implementation SelectPlayersViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAPIClient:(APIClient *)apiClient selectedPlayers:(NSArray *)selectedPlayers {
    self = [super init];
    if (!self) return nil;

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
    return self.players[row];
}

@end
