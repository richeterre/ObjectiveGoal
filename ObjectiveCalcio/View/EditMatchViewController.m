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

@end

@implementation EditMatchViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self, title) = RACObserve(self.viewModel, name);
}

@end
