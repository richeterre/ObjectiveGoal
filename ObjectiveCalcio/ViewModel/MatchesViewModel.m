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
#import <libextobjc/EXTScope.h>

@interface MatchesViewModel ()

@property (nonatomic, strong) NSArray *matches;

@end

@implementation MatchesViewModel

- (instancetype)initWithAPIClient:(APIClient *)apiClient {
    self = [super init];
    if (!self) return nil;

    @weakify(self);
    [self.didBecomeActiveSignal subscribeNext:^(id _) {
        @strongify(self);
        RAC(self, matches) = [apiClient fetchMatches];
    }];

    _updatedContentSignal = [[RACObserve(self, matches) ignore:nil] mapReplace:@(YES)];

    return self;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.matches.count;
}

- (NSString *)homePlayersAtRow:(NSInteger)row inSection:(NSInteger)section {
    Match *match = [self matchAtRow:row inSection:section];
    return match.homePlayers;
}

- (NSString *)awayPlayersAtRow:(NSInteger)row inSection:(NSInteger)section {
    Match *match = [self matchAtRow:row inSection:section];
    return match.awayPlayers;
}

- (NSString *)resultAtRow:(NSInteger)row inSection:(NSInteger)section {
    Match *match = [self matchAtRow:row inSection:section];
    return [NSString stringWithFormat:@"%lu:%lu", (unsigned long)match.homeGoals, (unsigned long)match.awayGoals];
}

#pragma mark - Internal Helpers

- (Match *)matchAtRow:(NSInteger)row inSection:(NSInteger)section {
    return self.matches[row];
}

@end
