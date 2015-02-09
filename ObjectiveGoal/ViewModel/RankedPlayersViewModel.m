//
//  RankedPlayersViewModel.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RankedPlayersViewModel.h"
#import "Player.h"
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

    _updatedContentSignal = [[[RACObserve(self, players) ignore:nil]
        mapReplace:@(YES)]
        deliverOn:RACScheduler.mainThreadScheduler];

    RACSignal *refreshSignal = self.didBecomeActiveSignal;

    _progressIndicatorVisibleSignal = [RACSignal merge:@[
        [refreshSignal mapReplace:@(YES)],
        [_updatedContentSignal mapReplace:@(NO)]
    ]];

    @weakify(self);
    RAC(self, players) = [[refreshSignal map:^(id _) {
        @strongify(self);
        return [apiClient fetchRankedPlayers];
    }] switchToLatest];

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
    Player *player = [self playerAtRow:row inSection:section];
    return player.name;
}

- (NSString *)playerRatingAtRow:(NSInteger)row inSection:(NSInteger)section {
    // Create static number formatter as it's very expensive
    static NSNumberFormatter *_numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _numberFormatter.minimumFractionDigits = 1;
        _numberFormatter.maximumFractionDigits = 1;
    });

    // Format player rating
    Player *player = [self playerAtRow:row inSection:section];
    return [_numberFormatter stringFromNumber:@(player.rating)];
}

#pragma mark - Internal Helpers

- (Player *)playerAtRow:(NSInteger)row inSection:(NSInteger)section {
    return self.players[row];
}

@end
