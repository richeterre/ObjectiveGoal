//
//  EditMatchViewModel.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "EditMatchViewModel.h"

@implementation EditMatchViewModel

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _name = @"New Match";

    return self;
}

@end
