//
//  Player.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 24/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "MTLModel.h"
#import <CoreGraphics/CGBase.h>

extern CGFloat const PlayerDefaultRating;

@interface Player : MTLModel

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) CGFloat rating;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name;
- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name rating:(CGFloat)rating;

+ (NSArray *)sortedPlayerNamesFromPlayers:(NSSet *)players;

@end
