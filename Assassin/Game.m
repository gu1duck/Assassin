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
@dynamic joinPIN;
@dynamic joinable;
@dynamic name;
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

- (void) setup{
    self.joinPIN = [self randomPin];
    self.joinable = YES;
}

- (NSString*)randomPin{
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    __block NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i<4; i++) {
        [string appendFormat: @"%C", [alphabet characterAtIndex: arc4random_uniform((int)[alphabet length])]];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:[Game parseClassName]];
    [query whereKey:@"joinPIN" equalTo:string];
    [query findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error){
        if ([results count] > 0){
            string = [[self randomPin] mutableCopy];
        }
    }];
    return string;
}




@end
