//
//  AppDelegate.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "AppDelegate.h"
#import "MatchesViewController.h"
#import "MatchesViewModel.h"
#import "APIClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MatchesViewController *matchesViewController = (MatchesViewController *)navigationController.topViewController;

    APIClient *apiClient = [[APIClient alloc] init];
    MatchesViewModel *matchesViewModel = [[MatchesViewModel alloc] initWithAPIClient:apiClient];
    matchesViewController.viewModel = matchesViewModel;

    return YES;
}

@end
