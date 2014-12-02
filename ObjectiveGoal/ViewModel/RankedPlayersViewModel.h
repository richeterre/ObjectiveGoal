//
//  RankedPlayersViewModel.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@class APIClient, RACSignal;

@interface RankedPlayersViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;

- (instancetype)initWithAPIClient:(APIClient *)apiClient;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)playerNameAtRow:(NSInteger)row inSection:(NSInteger)section;

@end
