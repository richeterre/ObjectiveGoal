//
//  SelectPlayersViewController.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectPlayersViewModel;

@interface SelectPlayersViewController : UITableViewController

@property (nonatomic, strong) SelectPlayersViewModel *viewModel;

@end
