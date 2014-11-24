//
//  MatchesViewModel.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveViewModel/ReactiveViewModel.h>

@class APIClient, EditMatchViewModel;

@interface MatchesViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *progressIndicatorVisibleSignal;
@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;

- (instancetype)initWithAPIClient:(APIClient *)apiClient;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)homePlayersAtRow:(NSInteger)row inSection:(NSInteger)section;
- (NSString *)awayPlayersAtRow:(NSInteger)row inSection:(NSInteger)section;
- (NSString *)resultAtRow:(NSInteger)row inSection:(NSInteger)section;

- (EditMatchViewModel *)editViewModelForNewMatch;

@end
