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

@property (nonatomic, strong) APIClient *apiClient;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIColor *tintColor = [UIColor colorWithRed:0.22 green:0.58 blue:0.29 alpha:1]; // <3
    self.window.tintColor = tintColor;
    [UINavigationBar appearance].barTintColor = tintColor;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:20],
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };

    self.apiClient = [[APIClient alloc] init];

    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MatchesViewController *matchesViewController = (MatchesViewController *)navigationController.topViewController;

    MatchesViewModel *matchesViewModel = [[MatchesViewModel alloc] initWithAPIClient:self.apiClient];
    matchesViewController.viewModel = matchesViewModel;

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.apiClient persist];
}

@end
