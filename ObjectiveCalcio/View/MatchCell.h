//
//  MatchCell.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *homePlayersLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayPlayersLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end
