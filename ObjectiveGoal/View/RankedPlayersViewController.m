//
//  RankedPlayersViewController.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 02/12/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RankedPlayersViewController.h"
#import "PlayerCell.h"
#import "RankedPlayersViewModel.h"

static NSString * const PlayerCellIdentifier = @"PlayerCell";

@implementation RankedPlayersViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentifier forIndexPath:indexPath];

    return cell;
}

@end
