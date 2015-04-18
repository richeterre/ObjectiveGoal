//
//  AppDelegate.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "AppDelegate.h"
#import "MatchesViewController.h"
#import "RankedPlayersViewController.h"
#import "MatchesViewModel.h"
#import "RankedPlayersViewModel.h"
#import "APIClient.h"

@interface AppDelegate ()

@property (nonatomic, strong) APIClient *apiClient;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Customize appearance

    UIColor *tintColor = [UIColor colorWithRed:0.22 green:0.58 blue:0.29 alpha:1]; // <3
    self.window.tintColor = tintColor;

    [UINavigationBar appearance].barTintColor = tintColor;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:20],
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };

    [[UIBarButtonItem
        appearanceWhenContainedIn:[UINavigationBar class], nil]
        setTitleTextAttributes:@{
            NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:17]
        }
        forState:UIControlStateNormal];

    // Set up view model for initial controller

    self.apiClient = [[APIClient alloc] init];

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;

    UINavigationController *historyNavigationController = (UINavigationController *)tabBarController.viewControllers[0];
    MatchesViewController *matchesViewController = (MatchesViewController *)historyNavigationController.topViewController;
    MatchesViewModel *matchesViewModel = [[MatchesViewModel alloc] initWithAPIClient:self.apiClient];
    matchesViewController.viewModel = matchesViewModel;

    UINavigationController *rankingsNavigationController = (UINavigationController *)tabBarController.viewControllers[1];
    RankedPlayersViewController *rankedPlayersViewController = (RankedPlayersViewController *)rankingsNavigationController.topViewController;
    RankedPlayersViewModel *rankedPlayersViewModel = [[RankedPlayersViewModel alloc] initWithAPIClient:self.apiClient];
    rankedPlayersViewController.viewModel = rankedPlayersViewModel;

    return YES;
}

@end
