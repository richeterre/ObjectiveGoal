//
//  SelectPlayersViewController.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "SelectPlayersViewController.h"
#import "SelectPlayersViewModel.h"
#import "UIViewController+Active.h"
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const PlayerCellIdentifier = @"PlayerCell";

@interface SelectPlayersViewController ()

@end

@implementation SelectPlayersViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    [self.viewModel.updatedContentSignal subscribeNext:^(id _) {
        @strongify(self);
        [self.tableView reloadData];
    }];

    RAC(self.viewModel, active) = self.activeSignal;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [self.viewModel playerNameAtRow:indexPath.row inSection:indexPath.section];

    return cell;
}

@end
