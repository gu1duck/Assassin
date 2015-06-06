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
@property (nonatomic) Player* target;
@property (nonatomic) BOOL knowsDead;
@property (nonatomic) BOOL dead;
@property (nonatomic) BOOL host;
@property (nonatomic) BOOL current;
@property (nonatomic) BOOL knowsTarget;

+ (NSString *) parseClassName;
- (void) setupWithGame: (Game*) game;
- (void) uploadAlivePhoto:(UIImage*)image;
- (void) uploadDeadPhoto:(UIImage*)image;
- (UIImage*) downloadAlivePhoto;
- (UIImage*) downloadDeadPhoto;

@end
