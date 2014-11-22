//
//  MatchesViewController.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchCell.h"
#import "EditMatchViewController.h"
#import "MatchesViewModel.h"
#import "EditMatchViewModel.h"
#import <libextobjc/EXTScope.h>

static NSString * const MatchCellIdentifier = @"MatchCell";
static NSString * const EditMatchSegueIdentifier = @"EditMatch";

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

    RACSignal *presented = [RACSignal
        merge:@[
            [[self rac_signalForSelector:@selector(viewWillAppear:)] mapReplace:@(YES)],
            [[self rac_signalForSelector:@selector(viewWillDisappear:)] mapReplace:@(NO)]
        ]];

    RACSignal *appActive = [[RACSignal
        merge:@[
            [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] mapReplace:@(YES)],
            [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] mapReplace:@(NO)]
        ]] startWith:@(YES)];

    RAC(self.viewModel, active) = [[RACSignal combineLatest:@[presented, appActive]] and];
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
    if ([segue.identifier isEqualToString:EditMatchSegueIdentifier]) {
        EditMatchViewController *editMatchViewController = (EditMatchViewController *)[segue.destinationViewController topViewController];
        editMatchViewController.viewModel = [self.viewModel editViewModelForNewMatch];
    }
}

- (IBAction)unwindToMatches:(UIStoryboardSegue *)unwindSegue {}

@end
