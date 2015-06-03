//
//  HopperViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "HopperViewController.h"
#import "PlayerCollectionViewCell.h"

@interface HopperViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *gameTitleTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSTimer *updateTimer;
@property (nonatomic) NSArray *players;
@property (nonatomic) NSDate *storedDate;


@end


@implementation HopperViewController



-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    
        
        PFQuery *playersInGame = [[PFQuery alloc] initWithClassName:[Player parseClassName]];
        [playersInGame whereKey:@"game" equalTo:self.game];
        [playersInGame findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error){
            self.players = results;
            [self.collectionView reloadData];
        }];
    self.storedDate = [[NSDate alloc]init];
    self.storedDate = [NSDate date];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                            target:self
                                                          selector:@selector(updateGameData)
                                                          userInfo:nil
                                                           repeats:YES];
   
    
    
    
    self.gameTitleTextField.delegate = self;
    self.gameTitleTextField.placeholder = [NSString stringWithFormat:@"%@'s Game",self.player.name];
    
   
    
    if ( self.player.host == NO ) {
        self.headerConstraint.constant = 0;
        self.gameTitleTextField.hidden = YES;
        
        self.footerConstraint.constant = 0;
        
         }
    
    
}

-(void)updateGameData {

    
    PFQuery *gameData = [[PFQuery alloc] initWithClassName:[Game parseClassName]];
    [gameData whereKey:@"objectId" equalTo:self.game.objectId];
  //  [gameData whereKey:@"updatedAt" notEqualTo:self.game.updatedAt];
    [gameData findObjectsInBackgroundWithBlock:^(NSArray *results, NSError* error){
        Game *fetchedGame = [results firstObject];
        
        if ( [self.storedDate isEqualToDate:fetchedGame.updatedAt] ) {
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.game.name = textField.text;
    return YES;
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    [self.updateTimer invalidate];
    
    if ([self.gameTitleTextField.text isEqualToString:@""]) {
        self.gameTitleTextField.text = self.gameTitleTextField.placeholder;
    }
    self.game.name = self.gameTitleTextField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.playerImageView.image = [aPlayer downloadDeadPhoto];
    }
    else
    {
        [aPlayer.alivePhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
            cell.playerImageView.image = [UIImage imageWithData:imageData];
        }];
        
    }
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
