//
//  RankedPlayersViewController.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RankedPlayersViewModel;

@interface RankedPlayersViewController : UITableViewController

@property (nonatomic, strong) RankedPlayersViewModel *viewModel;

@end
