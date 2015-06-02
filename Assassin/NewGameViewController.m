//
//  NewGameViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "NewGameViewController.h"
#import "Player.h"
#import "HopperViewController.h"

@interface NewGameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) UIImage* image;
@property Player* player;
@property Game* game;

@end

@implementation NewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneButton.enabled = NO;
    self.doneButton.alpha = 0.5;
    
    //Create Player and Game, saving them in the background. Note that this could
    //cause a crash if the user is somehow able to upload an image before this sequence
    //finishes.
    
    Player* player = [Player object];
    Game* game = [Game object];
    player.name = @"name";
    player.host = YES;
    [game setup];
    [player saveInBackgroundWithBlock:^(BOOL success, NSError* error){
        [game saveInBackgroundWithBlock:^(BOOL success, NSError* error){
            [player setupWithGame:game];
            self.player = player;
            self.game = game;
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imagePickerButton:(id)sender {
    //photo code goes here
    self.image = [UIImage imageNamed:@"Jer"];
    self.photoImageView.image = self.image;
    //
    self.doneButton.enabled = YES;
    self.doneButton.alpha = 1;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.game deleteInBackground];
        [self.player deleteInBackground];    }
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"newGameToHopper"]){
        HopperViewController* hopper = segue.destinationViewController;
        hopper.game = self.game;
        
        dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(background_queue, ^{
            [self.player uploadAlivePhoto:self.image];
            //insert [hopper.query update] or something
        });
    }
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
