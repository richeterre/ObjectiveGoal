//
//  MatchCell.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *homePlayersLabel;
@property (nonatomic, weak) IBOutlet UILabel *awayPlayersLabel;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;

@end
