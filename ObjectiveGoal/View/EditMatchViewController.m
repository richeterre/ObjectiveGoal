//
//  EditMatchViewController.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "EditMatchViewController.h"
#import "ManagePlayersViewController.h"
#import "EditMatchViewModel.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <JGProgressHUD/JGProgressHUDFadeZoomAnimation.h>
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const UnwindToMatchesSegueIdentifier = @"UnwindToMatches";
static NSString * const ManageHomePlayersSegueIdentifier = @"ManageHomePlayers";
static NSString * const ManageAwayPlayersSegueIdentifier = @"ManageAwayPlayers";

@interface EditMatchViewController ()

@property (nonatomic, weak) IBOutlet UILabel *homeGoalsLabel;
@property (nonatomic, weak) IBOutlet UILabel *awayGoalsLabel;
@property (nonatomic, weak) IBOutlet UIStepper *homeGoalsStepper;
@property (nonatomic, weak) IBOutlet UIStepper *awayGoalsStepper;
@property (nonatomic, weak) IBOutlet UIButton *homePlayersButton;
@property (nonatomic, weak) IBOutlet UIButton *awayPlayersButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation EditMatchViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self, title) = RACObserve(self.viewModel, name);
    RAC(self.homeGoalsLabel, text) = RACObserve(self.viewModel, homeGoalsString);
    RAC(self.awayGoalsLabel, text) = RACObserve(self.viewModel, awayGoalsString);

    [self.homePlayersButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[
        RACObserve(self.viewModel, homePlayersString),
        [RACSignal return:UIControlStateNormal]
    ]];

    [self.awayPlayersButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[
        RACObserve(self.viewModel, awayPlayersString),
        [RACSignal return:UIControlStateNormal]
    ]];

    RACCommand *saveCommand = self.viewModel.saveCommand;
    self.saveButton.rac_command = saveCommand;

    @weakify(self);

    [[self.viewModel.saveCommand.executionSignals flatten] subscribeNext:^(id _) {
        @strongify(self);
        [self performSegueWithIdentifier:UnwindToMatchesSegueIdentifier sender:self];
    }];

    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    progressHUD.animation = [JGProgressHUDFadeZoomAnimation animation];
    progressHUD.textLabel.text = @"Saving Match…";

    [self.viewModel.progressIndicatorVisibleSignal subscribeNext:^(NSNumber *visible) {
        @strongify(self);
        if (visible.boolValue && progressHUD.targetView == nil) {
            [progressHUD showInView:self.navigationController.view];
        } else if (!visible.boolValue && progressHUD.targetView != nil) {
            [progressHUD dismiss];
        }
    }];

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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ManageHomePlayersSegueIdentifier]) {
        ManagePlayersViewController *managePlayersViewController = segue.destinationViewController;
        managePlayersViewController.viewModel = [self.viewModel manageHomePlayersViewModel];
    }
    else if ([segue.identifier isEqualToString:ManageAwayPlayersSegueIdentifier]) {
        ManagePlayersViewController *managePlayersViewController = segue.destinationViewController;
        managePlayersViewController.viewModel = [self.viewModel manageAwayPlayersViewModel];
    }
}

@end
