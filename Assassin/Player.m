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
@dynamic current;
@dynamic target;
@dynamic knowsTarget;
@dynamic knowsDead;

+ (void)load {
    [self registerSubclass];
}

+ (NSString*) parseClassName{
    return @"Player";
}

- (void) setupWithGame: (Game*) game{
    self.game = game;
    [game.players addObject:self];
    self.user = [PFUser currentUser];
    self.dead = NO;
    self.current = YES;
    [self saveInBackground];
    [game saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:[Player parseClassName]];
    [query whereKey:@"user" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error){
        for(Player* thisPlayer in results){
            if (thisPlayer != self){
                thisPlayer.current = NO;
            }
        }
    }];
}

- (UIImage*) downloadAlivePhoto{
    NSData *imageData = [self.alivePhoto getData];
    UIImage* aliveImage = [UIImage imageWithData:imageData];
    return aliveImage;
}

- (void) uploadAlivePhoto: (UIImage*) image{
    NSData* alivePhotoJPG = UIImageJPEGRepresentation(image, 1.0);
    PFFile* alivePhoto = [PFFile fileWithName:@"alive.jpeg" data:alivePhotoJPG];
    [alivePhoto save];
    self.alivePhoto = alivePhoto;
    [self save];
}

- (UIImage*) downloadDeadPhoto{
    NSData *imageData = [self.deadPhoto getData];
    UIImage* deadImage = [UIImage imageWithData:imageData];
    return deadImage;
}

- (void) uploadDeadPhoto: (UIImage*) image{
    NSData* deadPhotoJPG = UIImageJPEGRepresentation(image, 1.0);
    PFFile* deadPhoto = [PFFile fileWithName:@"dead.jpeg" data:deadPhotoJPG];
    [deadPhoto save];
    self.deadPhoto = deadPhoto;
    [self save];
}

@end
