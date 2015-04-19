//
//  ProgressHUD.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 19/04/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

#import <JGProgressHUD/JGProgressHUD.h>

@interface ProgressHUD : JGProgressHUD

// Returns a standard progress HUD with the given text (can be nil)
+ (instancetype)progressHUDWithText:(NSString *)text;

@end
