//
//  TestViewController.m
//  ParseStarterProject
//
//  Created by Jeremy Petter on 2015-05-31.
//
//

#import "TestViewController.h"
#import "Game.h"
#import "Player.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Game* game1 = [Game object];
    [game1 save];
    
    Player* player1 = [Player object];
    player1.name = @"Player1";
    player1.user = [PFUser currentUser];
    [player1 save];
    
    player1.game = game1;
    [game1.players addObject:player1];
    [player1 save];
    [game1 save];
    
    Game* game2 = [Game object];
    [game2 save];
    
    Player* player2 = [Player object];
    player2.name = @"Player2";
//    player2.user = [PFUser currentUser];
    [player2 save];
    
    Player* player3 = [Player object];
    player3.name = @"Player3";
//    player3.user = [PFUser currentUser];
    [player3 save];
    
    player2.game = game2;
    [game2.players addObject:player2];
    player3.game = game2;
    [game2.players addObject:player3];
    [player2 save];
    [player3 save];
    [game2 save];
    
    [player1 uploadAlivePhoto:[UIImage imageNamed:@"Jer"]];
    
    
    PFQuery *query1 = [PFQuery queryWithClassName:[Player parseClassName]];
    [query1 whereKey:@"game" equalTo:game1];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray* players, NSError* error){
        NSLog(@"Players in game One:");
        for (Player* player in players){
            NSLog(@"%@", player.name);
        }
    }];
    
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
