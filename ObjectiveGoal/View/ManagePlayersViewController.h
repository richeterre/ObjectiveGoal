//
//  ManagePlayersViewController.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ManagePlayersViewModel;

@interface ManagePlayersViewController : UITableViewController

@property (nonatomic, strong) ManagePlayersViewModel *viewModel;

@end
