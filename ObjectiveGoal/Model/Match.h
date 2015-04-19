//
//  Match.h
//  ObjectiveGoal
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Match : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSSet *homePlayers;
@property (nonatomic, copy, readonly) NSSet *awayPlayers;
@property (nonatomic, assign, readonly) NSUInteger homeGoals;
@property (nonatomic, assign, readonly) NSUInteger awayGoals;

- (instancetype)initWithIdentifier:(NSString *)identifier
                       HomePlayers:(NSSet *)homePlayers
                       awayPlayers:(NSSet *)awayPlayers
                         homeGoals:(NSUInteger)homeGoals
                         awayGoals:(NSUInteger)awayGoals;

@end
