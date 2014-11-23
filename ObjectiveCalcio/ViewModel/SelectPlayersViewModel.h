//
//  SelectPlayersViewModel.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@class APIClient;

@interface SelectPlayersViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;

- (instancetype)initWithAPIClient:(APIClient *)apiClient selectedPlayers:(NSArray *)selectedPlayers;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)playerNameAtRow:(NSInteger)row inSection:(NSInteger)section;

@end
