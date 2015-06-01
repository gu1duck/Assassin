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

+ (void)load {
    [self registerSubclass];
}

+ (NSString*) parseClassName{
    return @"Player";
}
@end
