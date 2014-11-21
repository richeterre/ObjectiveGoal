//
//  APIClient.h
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface APIClient : NSObject

- (RACSignal *)fetchMatches;

@end
