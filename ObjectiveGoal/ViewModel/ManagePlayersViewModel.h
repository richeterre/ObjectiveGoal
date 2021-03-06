//
//  ManagePlayersViewModel.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@class APIClient, RACCommand;

@interface ManagePlayersViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *selectedPlayersSignal;
@property (nonatomic, strong, readonly) RACSignal *progressIndicatorVisibleSignal;
@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;

@property (nonatomic, strong, readonly) RACSignal *validPlayerInputSignal;
@property (nonatomic, strong, readonly) RACCommand *savePlayerCommand;

@property (nonatomic, copy) NSString *playerInputName;

- (instancetype)initWithAPIClient:(APIClient *)apiClient initialPlayers:(NSSet *)initialPlayers disabledPlayers:(NSSet *)disabledPlayers;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)playerNameAtRow:(NSInteger)row inSection:(NSInteger)section;
- (BOOL)isPlayerSelectedAtRow:(NSInteger)row inSection:(NSInteger)section;
- (BOOL)canSelectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section;

- (void)selectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section;
- (void)deselectPlayerAtRow:(NSInteger)row inSection:(NSInteger)section;

@end
