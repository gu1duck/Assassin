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
#import "PhotoView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GamestateViewController () <PhotoViewDelegate>

@property (nonatomic) NSArray* players;
@property (nonatomic) NSTimer* updateTimer;
@property (nonatomic) PhotoView* photoView;
@property BOOL photoAlertVisible;


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
    
    [self performAlerts];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:10
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


-(void)performAlerts {
    if (self.player.deadPhoto) {
        dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(background_queue, ^{
            [self.player fetchIfNeeded];
            UIImage *deadPhoto = [self.player downloadDeadPhoto];
            self.photoView = [[PhotoView alloc]initWithImage:deadPhoto label:self.player.name andCaption:@"You've been Assassinated!"];
            self.photoView.delegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photoView showAlertView:self.view];
                self.photoAlertVisible = YES;
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                //self.player.knowsTarget = NO;
            });
        });
    }
    
    else if (!self.player.knowsTarget && !self.photoAlertVisible){
        dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(background_queue, ^{
            [self.player fetchIfNeeded];
            [self.player.target fetchIfNeeded];
            UIImage* targetPhoto = [self.player.target downloadAlivePhoto];
            self.photoView = [[PhotoView alloc] initWithImage:targetPhoto label:self.player.target.name andCaption:@"Your new target"];
            self.photoView.delegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photoView showAlertView:self.view];
                self.photoAlertVisible = YES;
            });
            
        });
    }

}


#pragma mark - CollectionView

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

-(void)handleTapGesture: (UITapGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.photoView.background.alpha = 0.0;
                         }
                         completion:^(BOOL success){
                             [self.photoView.background removeFromSuperview];
                             self.player.knowsTarget = YES;
                             [self.player saveInBackground];
                             self.photoAlertVisible = NO;
                         }];
    }
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
