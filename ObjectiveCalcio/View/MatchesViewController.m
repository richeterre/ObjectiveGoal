//
//  MatchesViewController.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchCell.h"
#import <libextobjc/EXTScope.h>

static NSString * const MatchCellIdentifier = @"MatchCell";

@interface MatchesViewController ()

@end

@implementation MatchesViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id _) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.viewModel.active = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:MatchCellIdentifier forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    cell.homePlayersLabel.text = [self.viewModel homePlayersAtRow:row inSection:section];
    cell.awayPlayersLabel.text = [self.viewModel awayPlayersAtRow:row inSection:section];
    cell.resultLabel.text = [self.viewModel resultAtRow:row inSection:section];

    return cell;
}

#pragma mark - Segues

- (IBAction)unwindToMatches:(UIStoryboardSegue *)unwindSegue {

}

@end
