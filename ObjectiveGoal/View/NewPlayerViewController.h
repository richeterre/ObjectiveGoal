//
//  NewPlayerViewController.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 30/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewPlayerViewModel;

@interface NewPlayerViewController : UIAlertController

@property (nonatomic, strong) NewPlayerViewModel *viewModel;

+ (instancetype)instance;

@end
