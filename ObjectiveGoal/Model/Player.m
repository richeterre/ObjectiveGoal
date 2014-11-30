//
//  Player.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 24/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "Player.h"
#import <BlocksKit/NSSet+BlocksKit.h>

@implementation Player

#pragma mark - Lifecycle

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name {
    self = [super init];
    if (!self) return nil;

    _identifier = [identifier copy];
    _name = [name copy];

    return self;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@)", self.name, self.identifier];
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) return NO;

    Player *other = (Player *)object;
    return [self.identifier isEqualToString:other.identifier]; // nil identifiers make non-equal players
}

#pragma mark - Sorting

+ (NSArray *)sortedPlayerNamesFromPlayers:(NSSet *)players {
    NSSet *playerNames = [players bk_map:^(Player *player) {
        return player.name;
    }];
    return [[playerNames allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end
