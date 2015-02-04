//
//  Changeset.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 20/01/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Changeset : NSObject

@property (nonatomic, copy, readonly) NSArray *deletions;
@property (nonatomic, copy, readonly) NSArray *insertions;

+ (Changeset *)changesetFromMatches:(NSArray *)oldMatches toMatches:(NSArray *)newMatches;

@end
