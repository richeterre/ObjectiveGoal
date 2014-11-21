//
//  MatchesViewModel.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 21/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "RVMViewModel.h"

@interface MatchesViewModel : RVMViewModel

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)homePlayersAtRow:(NSInteger)row inSection:(NSInteger)section;
- (NSString *)awayPlayersAtRow:(NSInteger)row inSection:(NSInteger)section;
- (NSString *)resultAtRow:(NSInteger)row inSection:(NSInteger)section;

@end
