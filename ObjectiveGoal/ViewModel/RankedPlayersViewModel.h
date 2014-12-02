//
//  RankedPlayersViewModel.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@class APIClient;

@interface RankedPlayersViewModel : RVMViewModel

- (instancetype)initWithAPIClient:(APIClient *)apiClient;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

@end
