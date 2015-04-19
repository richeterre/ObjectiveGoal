//
//  ProgressHUD.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 19/04/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

#import "ProgressHUD.h"
#import <JGProgressHUD/JGProgressHUDFadeZoomAnimation.h>

@implementation ProgressHUD

+ (instancetype)progressHUDWithText:(NSString *)text {
    ProgressHUD *progressHUD = [super progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    progressHUD.animation = [JGProgressHUDFadeZoomAnimation animation];
    progressHUD.minimumDisplayTime = 0.2;
    progressHUD.textLabel.text = text;
    return progressHUD;
}

@end
