//
//  Game.m
//  ParseStarterProject
//
//  Created by Jeremy Petter on 2015-05-31.
//
//

#import "Game.h"
#import <Parse/PFObject+Subclass.h>



@implementation Game

@synthesize players = _players;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *) parseClassName{
    return @"Game";
}

- (void)setPlayers:(PFRelation *)players{
    _players = players;
}

- (PFRelation*) players{
    if(_players == nil) {
        _players = [self relationForKey:@"players"];
    }
    return _players;
}




@end
