//
//  EditMatchViewModel.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@interface EditMatchViewModel : RVMViewModel

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, assign) NSUInteger homeGoals;
@property (nonatomic, assign) NSUInteger awayGoals;

@property (nonatomic, readonly) NSString *homeGoalsString;
@property (nonatomic, readonly) NSString *awayGoalsString;

@end
