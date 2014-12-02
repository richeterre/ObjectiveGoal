//
//  RankedPlayersViewModel.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RankedPlayersViewModel.h"
#import "APIClient.h"
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RankedPlayersViewModel ()

@property (nonatomic, strong) NSArray *players;

@end

@implementation RankedPlayersViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAPIClient:(APIClient *)apiClient {
    self = [super init];
    if (!self) return nil;

    RACSignal *refreshSignal = self.didBecomeActiveSignal;

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

@end
