//
//  JoinGameInfoViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-02.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "JoinGameInfoViewController.h"
#import "Player.h"
#import "HopperViewController.h"

@interface JoinGameInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property Player* player;
@property (nonatomic) UIImage* image;

@end

@implementation JoinGameInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneButton.enabled = NO;
    self.doneButton.alpha = 0.5;
    self.nameTextField.delegate = self;
    
    Player* player = [Player object];
    [player saveInBackgroundWithBlock:^(BOOL success, NSError* error){
            [player setupWithGame:self.game];
            self.player = player;
    }];

}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.player deleteInBackground];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frameUp = self.view.frame;
        frameUp.origin.y -=150;
        self.view.frame = frameUp;
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = [[UIScreen mainScreen] bounds];
    }];
    if (self.imageView.image && ![self.nameTextField.text isEqualToString:@""]){
        self.doneButton.enabled = YES;
        self.doneButton.alpha = 1;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameTextField resignFirstResponder];
    return false;
}

- (IBAction)pickerButton:(id)sender {
    //photo code goes here
    self.image = [UIImage imageNamed:@"Jer"];
    self.imageView.image = self.image;
    //
    if (self.imageView.image && ![self.nameTextField.text isEqualToString:@""]){
        self.doneButton.enabled = YES;
        self.doneButton.alpha = 1;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"signupToHopper"]){
        HopperViewController* hopper = segue.destinationViewController;
        hopper.game = self.game;
        
        dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(background_queue, ^{
            self.player.name = self.nameTextField.text;
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
