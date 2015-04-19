//
//  MatchesViewModel.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchesViewModel.h"
#import "Changeset.h"
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

    @weakify(self);

    _deleteMatchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        NSParameterAssert([indexPath isKindOfClass:NSIndexPath.class]);

        // Return signal for delete operation of match at given index path
        @strongify(self);
        Match *match = [self matchAtRow:indexPath.row inSection:indexPath.section];
        return [self.apiClient deleteMatch:match];
    }];

    // Force refresh after every delete operation, whether successful or not
    RACSignal *forcedRefreshSignal = [_deleteMatchCommand.executionSignals flatten];

    RACSignal *refreshSignal = [self.didBecomeActiveSignal merge:forcedRefreshSignal];

    RACSignal *updatedContentSignal = [RACObserve(self, matches) ignore:nil];

    _contentChangesSignal = [updatedContentSignal
        combinePreviousWithStart:@[] reduce:^(NSArray *previousMatches, NSArray *currentMatches) {
            return [Changeset changesetOfIndexPathsFromItems:previousMatches toItems:currentMatches];
        }];

    _refreshIndicatorVisibleSignal = [RACSignal merge:@[
        [refreshSignal mapReplace:@(YES)],
        [updatedContentSignal mapReplace:@(NO)]
    ]];

    _deletionIndicatorVisibleSignal = _deleteMatchCommand.executing;

    RAC(self, matches) = [[refreshSignal map:^(id _) {
        @strongify(self);
        return [[self.apiClient fetchMatches] catchTo:[RACSignal return:@[]]];
    }] switchToLatest];

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

- (EditMatchViewModel *)editViewModelForMatchAtRow:(NSInteger)row inSection:(NSInteger)section {
    Match *match = [self matchAtRow:row inSection:section];
    return [[EditMatchViewModel alloc] initWithAPIClient:self.apiClient match:match];
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
