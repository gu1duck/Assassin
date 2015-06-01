//
//  Player.h
//  ParseStarterProject
//
//  Created by Jeremy Petter on 2015-05-31.
//
//

#import <Parse/Parse.h>
#import "Game.h"

@interface Player : PFObject <PFSubclassing>

@property (nonatomic) Game* game;
@property (nonatomic) NSString* name;
@property (nonatomic) PFUser* user;
@property (nonatomic) PFFile* alivePhoto;
@property (nonatomic) PFFile* deadPhoto;
@property (nonatomic) BOOL dead;

+ (NSString *) parseClassName;
- (void) setupWithGame: (Game*) game;

@end
