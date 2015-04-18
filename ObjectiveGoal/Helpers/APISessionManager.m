//
//  APISessionManager.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 18/04/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

#import "APISessionManager.h"

static NSString * const APIBaseString = @"http://localhost:3000/api/v";
static NSUInteger const APIVersion = 1;

@implementation APISessionManager

- (instancetype)init
{
    NSString *baseURLString = [NSString stringWithFormat:@"%@%lu", APIBaseString, (unsigned long)APIVersion];
    NSURL *baseURL = [NSURL URLWithString:baseURLString];

    self = [super initWithBaseURL:baseURL];
    if (!self) return nil;

    return self;
}

@end
