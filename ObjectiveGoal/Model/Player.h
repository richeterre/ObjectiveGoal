//
//  Player.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 24/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "MTLModel.h"

@interface Player : MTLModel

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name;

+ (NSArray *)sortedPlayerNamesFromPlayers:(NSSet *)players;

@end
