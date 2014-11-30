//
//  NewPlayerViewModel.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 30/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@class APIClient;

@interface NewPlayerViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *validInputSignal;

@property (nonatomic, copy) NSString *inputText;

- (instancetype)initWithAPIClient:(APIClient *)apiClient;

@end
