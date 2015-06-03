//
//  HopperViewController.h
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Player.h"

@interface HopperViewController : UIViewController 
@property (nonatomic) Game* game;
@property (nonatomic) Player* player;



@end
