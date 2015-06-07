//
//  Game.h
//  ParseStarterProject
//
//  Created by Jeremy Petter on 2015-05-31.
//
//

#import <Parse/Parse.h>
#import "Player.h"

@interface Game : PFObject <PFSubclassing>

@property (nonatomic) PFRelation* players;
@property (nonatomic) BOOL joinable;
@property (nonatomic) NSString* joinPIN;
@property (nonatomic) NSString* name;
@property (nonatomic) Player* winner;

+ (NSString *) parseClassName;
- (void) setup;

@end
