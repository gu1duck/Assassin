//
//  AppDelegate.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-05-31.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Player.h"
#import "HopperViewController.h"
#import "GamestateViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    [PFUser enableAutomaticUser];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    
    
    // Initialize Parse.
    [Parse setApplicationId:@"SmBbPuPMf0DQNHMCk5nePFyeRiXHonEML6Vtm0uT"
                  clientKey:@"fZ6v6LZaYV5hl91Q7oTxCZbSIf0chAOxY5AsUaz6"];
    
    PFUser* user = [PFUser currentUser];
    if (user.objectId == nil){
        [user save];
    }
    
    PFQuery* query = [PFQuery queryWithClassName:[Player parseClassName]];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"current" equalTo:@YES];
    NSArray* players = [query findObjects];
    
    if ([players count]==0){
        UINavigationController* navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = navController;
    } else {
        Player* player = [players firstObject];
        Game* game = player.game;
        [game fetchIfNeeded];
        if (game.joinable){
            HopperViewController *hopper = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"hopper"];
            hopper.game = game;
            hopper.player = player;
            self.window.rootViewController = hopper;
        } else {
            UITabBarController* tabController = [[UIStoryboard storyboardWithName:@"GameInProgress" bundle:nil] instantiateInitialViewController];
            GamestateViewController* gameState = [tabController.viewControllers firstObject];
            gameState.player = player;
            gameState.game = game;
            self.window.rootViewController = tabController;
        }
    }
    
    
        return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
