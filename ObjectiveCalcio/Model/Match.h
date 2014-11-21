//
//  Match.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Match : NSObject

@property (nonatomic, copy) NSString *homePlayers;
@property (nonatomic, copy) NSString *awayPlayers;
@property (nonatomic, assign) NSUInteger homeGoals;
@property (nonatomic, assign) NSUInteger awayGoals;

- (instancetype)initWithHomePlayers:(NSString *)homePlayers
                        awayPlayers:(NSString *)awayPlayers
                          homeGoals:(NSUInteger)homeGoals
                          awayGoals:(NSUInteger)awayGoals;

@end
