//
//  TestHelper.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 23/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCMockObject;

@interface TestHelper : NSObject

+ (OCMockObject *)mockAPIClientReturningMatches:(NSArray *)matches;
+ (OCMockObject *)mockAPIClientReturningPlayers:(NSArray *)players;

@end