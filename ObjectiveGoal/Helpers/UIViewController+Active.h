//
//  UIViewController+Active.h
//  
//
//  Created by Martin Richter on 23/11/14.
//
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface UIViewController (Active)

- (RACSignal *)activeSignal;

@end
