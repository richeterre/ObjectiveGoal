//
//  Match.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Match : MTLModel

@property (nonatomic, copy, readonly) NSSet *homePlayers;
@property (nonatomic, copy, readonly) NSSet *awayPlayers;
@property (nonatomic, assign, readonly) NSUInteger homeGoals;
@property (nonatomic, assign, readonly) NSUInteger awayGoals;

- (instancetype)initWithHomePlayers:(NSSet *)homePlayers
                        awayPlayers:(NSSet *)awayPlayers
                          homeGoals:(NSUInteger)homeGoals
                          awayGoals:(NSUInteger)awayGoals;

@end
