//
//  NewPlayerViewController.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 30/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "NewPlayerViewController.h"
#import "NewPlayerViewModel.h"
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

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:nil];
    RAC(saveAction, enabled) = self.viewModel.validInputSignal;

    [self addAction:cancelAction];
    [self addAction:saveAction];

    @weakify(self);

    [self addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Player name";

        @strongify(self);
        RAC(self.viewModel, inputText) = textField.rac_textSignal;
    }];
}

@end
