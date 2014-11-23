//
//  EditMatchViewModel.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@class APIClient, SelectPlayersViewModel, RACCommand;

@interface EditMatchViewModel : RVMViewModel

- (instancetype)initWithAPIClient:(APIClient *)apiClient;

@property (nonatomic, strong, readonly) RACSignal *progressIndicatorVisibleSignal;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *homeGoalsString;
@property (nonatomic, readonly) NSString *awayGoalsString;
@property (nonatomic, readonly) NSString *homePlayersString;
@property (nonatomic, readonly) NSString *awayPlayersString;

@property (nonatomic, readonly) RACCommand *saveCommand;

@property (nonatomic, assign) NSUInteger homeGoals;
@property (nonatomic, assign) NSUInteger awayGoals;
@property (nonatomic, strong) NSSet *homePlayers;
@property (nonatomic, strong) NSSet *awayPlayers;

- (SelectPlayersViewModel *)selectHomePlayersViewModel;
- (SelectPlayersViewModel *)selectAwayPlayersViewModel;

@end
