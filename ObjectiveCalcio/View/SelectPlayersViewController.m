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
#import <JGProgressHUD/JGProgressHUD.h>
#import <JGProgressHUD/JGProgressHUDFadeZoomAnimation.h>
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

    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    progressHUD.animation = [JGProgressHUDFadeZoomAnimation animation];

    [self.viewModel.progressIndicatorVisibleSignal subscribeNext:^(NSNumber *visible) {
        @strongify(self);
        if (visible.boolValue) {
            [progressHUD showInView:self.navigationController.view];
        } else {
            [progressHUD dismiss];
        }
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

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    cell.textLabel.text = [self.viewModel playerNameAtRow:row inSection:section];
    cell.accessoryType = ([self.viewModel playerSelectedAtRow:row inSection:section]
                          ? UITableViewCellAccessoryCheckmark
                          : UITableViewCellAccessoryNone);

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.viewModel deselectPlayerAtRow:indexPath.row inSection:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.viewModel selectPlayerAtRow:indexPath.row inSection:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
