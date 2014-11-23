//
//  MatchesViewModel.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchesViewModel.h"
#import "Match.h"
#import "Player.h"
#import "EditMatchViewModel.h"
#import "APIClient.h"
#import <libextobjc/EXTScope.h>

@interface MatchesViewModel ()

@property (nonatomic, strong) APIClient *apiClient;
@property (nonatomic, strong) NSArray *matches;

@end

@implementation MatchesViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAPIClient:(APIClient *)apiClient {
    self = [super init];
    if (!self) return nil;

    _apiClient = apiClient;

    RACSignal *refreshSignal = self.didBecomeActiveSignal;

    _updatedContentSignal = [[RACObserve(self, matches) ignore:nil] mapReplace:@(YES)];

    _progressIndicatorVisibleSignal = [RACSignal
        merge:@[
            [refreshSignal mapReplace:@(YES)],
            [_updatedContentSignal mapReplace:@(NO)]
        ]];

    @weakify(self);
    [refreshSignal subscribeNext:^(id _) {
        @strongify(self);
        RAC(self, matches) = [apiClient fetchMatches];
    }];

    return self;
}

- (instancetype)init {
    return [self initWithAPIClient:nil];
}

#pragma mark - Content

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.matches.count;
}

- (NSString *)homePlayersAtRow:(NSInteger)row inSection:(NSInteger)section {
    Match *match = [self matchAtRow:row inSection:section];
    return [self namesOfPlayers:match.homePlayers];
}

- (NSString *)awayPlayersAtRow:(NSInteger)row inSection:(NSInteger)section {
    Match *match = [self matchAtRow:row inSection:section];
    return [self namesOfPlayers:match.awayPlayers];
}

- (NSString *)resultAtRow:(NSInteger)row inSection:(NSInteger)section {
    Match *match = [self matchAtRow:row inSection:section];
    return [NSString stringWithFormat:@"%lu:%lu", (unsigned long)match.homeGoals, (unsigned long)match.awayGoals];
}

#pragma mark - View Models

- (EditMatchViewModel *)editViewModelForNewMatch {
    return [[EditMatchViewModel alloc] initWithAPIClient:self.apiClient];
}

#pragma mark - Internal Helpers

- (Match *)matchAtRow:(NSInteger)row inSection:(NSInteger)section {
    return self.matches[row];
}

- (NSString *)namesOfPlayers:(NSSet *)players {
    NSArray *sortedPlayerNames = [Player sortedPlayerNamesFromPlayers:players];
    return [sortedPlayerNames componentsJoinedByString:@", "];
}

@end
