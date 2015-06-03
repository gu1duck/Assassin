//
//  GameStateDetailViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-02.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "GameStateDetailViewController.h"
#import "Player.h"

@interface GameStateDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) UIImage *alive;
@property (nonatomic) UIImage *dead;

@end

@implementation GameStateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.player.deadPhoto){
        if (self.dead){
            self.imageView.image = self.dead;
        } else {
            [self.player.deadPhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
                self.dead = [UIImage imageWithData:imageData];
                self.imageView.image = self.dead;
            }];
        }
    } else {
        self.segmentedControl.hidden = YES;
        if (self.alive){
            self.imageView.image = self.alive;
        } else {
            [self.player.alivePhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
                self.alive = [UIImage imageWithData:imageData];
                self.imageView.image = self.alive;
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentedControlChanged:(id)sender {
    if (self.segmentedControl.state == 0){
        if (self.dead){
            self.imageView.image = self.dead;
        } else {
            [self.player.deadPhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
                self.dead = [UIImage imageWithData:imageData];
                self.imageView.image = self.dead;
            }];
        }
    } else {
        if (self.alive){
            self.imageView.image = self.alive;
        } else {
            [self.player.alivePhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
                self.alive = [UIImage imageWithData:imageData];
                self.imageView.image = self.alive;
            }];
        }
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
