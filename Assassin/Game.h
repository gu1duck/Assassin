//
//  Game.h
//  ParseStarterProject
//
//  Created by Jeremy Petter on 2015-05-31.
//
//

#import <Parse/Parse.h>

@interface Game : PFObject <PFSubclassing>

@property (nonatomic) PFRelation* players;
@property (nonatomic) BOOL joinable;
@property (nonatomic) NSString* joinPIN;

+ (NSString *) parseClassName;

@end
