//
//  GamestateViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "GamestateViewController.h"
#import "Player.h"
#import "Game.h"
#import "PlayerCollectionViewCell.h"

@interface GamestateViewController ()

@end

@implementation GamestateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playersInGame = [[NSMutableArray alloc]init];
    
//    Game *game1 = [Game object];
//    [game1 save];
//    
//    Player *player1 = [Player object];
//    player1.name = @"Player1";
//    player1.user = [PFUser currentUser];
//    [player1 uploadAlivePhoto:[UIImage imageNamed:@"Jer"]];
//    [player1 save];
//    
//    [game1.players addObject:player1];
//    [game1 save];
//    
//    
//    
//    PFQuery *query1 =[PFQuery queryWithClassName:[Player parseClassName]];
//    [query1 whereKey:@"game" equalTo:game1];
//    [query1 findObjectsInBackgroundWithBlock:^(NSArray *players, NSError *error){
//        for (Player *player in players) {
//            [self.playersInGame addObject:player];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
//        });
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
    return size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
    //return self.playersInGame.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     PlayerCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.playerImageView.image = [UIImage imageNamed:@"Jer"];
    cell.playerNameLabel.text = @"Jeremy";
    
//    Player *aPlayer = [self.playersInGame objectAtIndex:indexPath.row];
//    
//    cell.playerNameLabel.text = aPlayer.name;
//    
//    if (aPlayer.deadPhoto) {
//        cell.playerImageView.image = [aPlayer downloadDeadPhoto];
//    }
//    else
//    {
//        cell.playerImageView.image = [aPlayer downloadAlivePhoto];
//    }
    return cell;
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
