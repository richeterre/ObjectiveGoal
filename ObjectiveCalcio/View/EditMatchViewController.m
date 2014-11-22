//
//  EditMatchViewController.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "EditMatchViewController.h"
#import "EditMatchViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EditMatchViewController ()

@property (nonatomic, weak) IBOutlet UILabel *homeGoalsLabel;
@property (nonatomic, weak) IBOutlet UILabel *awayGoalsLabel;
@property (nonatomic, weak) IBOutlet UIStepper *homeGoalsStepper;
@property (nonatomic, weak) IBOutlet UIStepper *awayGoalsStepper;

@end

@implementation EditMatchViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self, title) = RACObserve(self.viewModel, name);

    RAC(self.homeGoalsLabel, text) = RACObserve(self.viewModel, homeGoalsString);
    RAC(self.awayGoalsLabel, text) = RACObserve(self.viewModel, awayGoalsString);

    NSNumber *(^stepperValueBlock)(UIStepper *) = ^(UIStepper *stepper){
        return @(stepper.value);
    };

    RAC(self.viewModel, homeGoals) = [[self.homeGoalsStepper
        rac_signalForControlEvents:UIControlEventValueChanged]
        map:stepperValueBlock];
    RAC(self.viewModel, awayGoals) = [[self.awayGoalsStepper
        rac_signalForControlEvents:UIControlEventValueChanged]
        map:stepperValueBlock];
}

@end
