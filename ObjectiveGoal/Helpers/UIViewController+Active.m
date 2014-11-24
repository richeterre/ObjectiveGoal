//
//  UIViewController+Active.m
//  
//
//  Created by Martin Richter on 23/11/14.
//
//

#import "UIViewController+Active.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation UIViewController (Active)

- (RACSignal *)activeSignal {
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

    return [[RACSignal combineLatest:@[presented, appActive]] and];
}

@end
