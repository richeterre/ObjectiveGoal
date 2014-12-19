//
//  MatchesViewController.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchCell.h"
#import "EditMatchViewController.h"
#import "MatchesViewModel.h"
#import "EditMatchViewModel.h"
#import "UIViewController+Active.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <JGProgressHUD/JGProgressHUD.h>
#import <JGProgressHUDFadeZoomAnimation.h>
#import <libextobjc/EXTScope.h>

static NSString * const MatchCellIdentifier = @"MatchCell";
static NSString * const AddMatchSegueIdentifier = @"AddMatch";
static NSString * const EditMatchSegueIdentifier = @"EditMatch";

@interface MatchesViewController () <DZNEmptyDataSetSource>

@end

@implementation MatchesViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.emptyDataSetSource = self;
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

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No matches yet!";
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:30],
        NSForegroundColorAttributeName: [UIColor darkGrayColor]
    };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Tap the Add button at the top-right corner to get started.";
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:20],
        NSForegroundColorAttributeName: [UIColor lightGrayColor]
    };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditMatchViewModel *viewModel;

    if ([segue.identifier isEqualToString:AddMatchSegueIdentifier]) {
        viewModel = [self.viewModel editViewModelForNewMatch];
    } else if ([segue.identifier isEqualToString:EditMatchSegueIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        viewModel = [self.viewModel editViewModelForMatchAtRow:indexPath.row inSection:indexPath.section];
    }

    EditMatchViewController *editMatchViewController = (EditMatchViewController *)[segue.destinationViewController topViewController];
    editMatchViewController.viewModel = viewModel;
}

- (IBAction)unwindToMatches:(UIStoryboardSegue *)unwindSegue {}

@end
