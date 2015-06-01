//
//  Player.m
//  ParseStarterProject
//
//  Created by Jeremy Petter on 2015-05-31.
//
//

#import "Player.h"
#import <Parse/PFObject+Subclass.h>


@implementation Player

@dynamic game;
@dynamic name;
@dynamic user;
@dynamic deadPhoto;
@dynamic dead;
@dynamic alivePhoto;
@dynamic host;

+ (void)load {
    [self registerSubclass];
}

+ (NSString*) parseClassName{
    return @"Player";
}

- (void) setupWithGame: (Game*) game{
    self.game = game;
    self.user = [PFUser currentUser];
    self.dead = NO;
}

@end
