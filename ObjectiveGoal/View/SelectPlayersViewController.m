//
//  SelectPlayersViewController.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "SelectPlayersViewController.h"
#import "PlayerCell.h"
#import "NewPlayerViewController.h"
#import "SelectPlayersViewModel.h"
#import "UIViewController+Active.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <JGProgressHUD/JGProgressHUDFadeZoomAnimation.h>
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const PlayerCellIdentifier = @"PlayerCell";

@interface SelectPlayersViewController ()

- (IBAction)addPlayerButtonTapped:(id)sender;

@end

@implementation SelectPlayersViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];

    @weakify(self);

    [self.viewModel.updatedContentSignal subscribeNext:^(id _) {
        @strongify(self);
        [self.tableView reloadData];
    }];

    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    progressHUD.animation = [JGProgressHUDFadeZoomAnimation animation];

    [self.viewModel.progressIndicatorVisibleSignal subscribeNext:^(NSNumber *visible) {
        @strongify(self);
        if (visible.boolValue && progressHUD.targetView == nil) {
            [progressHUD showInView:self.navigationController.view];
        } else if (!visible.boolValue && progressHUD.targetView != nil) {
            [progressHUD dismiss];
        }
    }];

    RAC(self.viewModel, active) = self.activeSignal;
}

#pragma mark - User Interaction

- (IBAction)addPlayerButtonTapped:(id)sender {
    NewPlayerViewController *newPlayerViewController = [NewPlayerViewController instance];
    [self presentViewController:newPlayerViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentifier forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    cell.nameLabel.enabled = [self.viewModel canSelectPlayerAtRow:row inSection:section];
    cell.nameLabel.text = [self.viewModel playerNameAtRow:row inSection:section];
    cell.accessoryType = ([self.viewModel isPlayerSelectedAtRow:row inSection:section]
                          ? UITableViewCellAccessoryCheckmark
                          : UITableViewCellAccessoryNone);

    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([self.viewModel canSelectPlayerAtRow:indexPath.row inSection:indexPath.section]
            ? indexPath
            : nil);
}

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
