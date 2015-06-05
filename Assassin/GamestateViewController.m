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
#import "GameStateDetailViewController.h"

@interface GamestateViewController ()

@property (nonatomic) NSArray* players;
@property (nonatomic) NSTimer* updateTimer;
@property (nonatomic) NSDate* storedDate;

@end

@implementation GamestateViewController

- (void)viewDidLoad {
    
    
    PFQuery *playersInGame = [[PFQuery alloc] initWithClassName:[Player parseClassName]];
    [playersInGame whereKey:@"game" equalTo:self.game];
    [playersInGame findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error){
        self.players = results;
        [self.collectionView reloadData];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                        target:self
                                                      selector:@selector(updateGameData)
                                                      userInfo:nil
                                                       repeats:YES];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
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
    return [self.players count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //    cell.playerImageView.image = [UIImage imageNamed:@"Jer"];
    //    cell.playerNameLabel.text = @"Jeremy";
    
    Player *aPlayer = self.players[indexPath.row];
    
    cell.playerNameLabel.text = aPlayer.name;
    
    if (aPlayer.deadPhoto) {
        [aPlayer.deadPhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
            cell.playerImageView.image = [UIImage imageWithData:imageData];
        }];
    }
    else
    {
        [aPlayer.alivePhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
            cell.playerImageView.image = [UIImage imageWithData:imageData];
        }];
        
    }
    return cell;
}

-(void)updateGameData {
    
    PFQuery *gameData = [[PFQuery alloc]initWithClassName:[Game parseClassName]];
    [gameData whereKey:@"objectId" equalTo:self.game.objectId];
    [gameData findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error){
        Game *fetchedGame = [results firstObject];
        
        if ([self.storedDate isEqualToDate:fetchedGame.updatedAt]) {
            return;
        }
        else
        {
            PFQuery *playersInGame = [[PFQuery alloc] initWithClassName:[Player parseClassName]];
            [playersInGame whereKey:@"game" equalTo:self.game];
            [playersInGame findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error){
                self.players = results;
                [self.collectionView reloadData];
            }];
            self.storedDate = fetchedGame.updatedAt;
        }
    }];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]){
        GameStateDetailViewController* detail = segue.destinationViewController;
        NSIndexPath* index = [[self.collectionView indexPathsForSelectedItems] firstObject];
        Player* player = self.players[index.row];
        detail.player = player;
    }
}



@end
