//
//  NewPlayerViewController.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 30/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "NewPlayerViewController.h"
#import "ManagePlayersViewModel.h"
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation NewPlayerViewController

#pragma mark - Lifecycle

+ (instancetype)instance {
    return [super.class alertControllerWithTitle:@"New Player" message:nil preferredStyle:UIAlertControllerStyleAlert];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    @weakify(self);

    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        [self.viewModel.savePlayerCommand execute:action];
    }];
    RAC(saveAction, enabled) = self.viewModel.validPlayerInputSignal;
    [self addAction:saveAction];

    [self addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Player name";
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    RACSignal *viewWillDisappear = [self rac_signalForSelector:@selector(viewWillDisappear:)];

    // Unbind when view disappears, as the text field (for some reason) lives beyond self
    UITextField *playerNameField = self.textFields.firstObject;
    RAC(self.viewModel, playerInputName) = [playerNameField.rac_textSignal takeUntil:viewWillDisappear];
}

@end
