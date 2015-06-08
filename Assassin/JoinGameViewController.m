//
//  JoinGameViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-02.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "JoinGameViewController.h"
#import <Parse/Parse.h>
#import "JoinGameInfoViewController.h"


@interface JoinGameViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *joinGameTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinGameButton;

@end

@implementation JoinGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.joinGameButton.alpha = 0.5;
    self.joinGameButton.enabled = NO;
    self.joinGameTextField.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.joinGameTextField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.joinGameTextField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([[UIScreen mainScreen] bounds].size.height < 568){
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frameUp = self.view.frame;
            frameUp.origin.y -=50;
            self.view.frame = frameUp;
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.game = nil;
    if ([self.joinGameTextField.text length] == 4){
        PFQuery* query = [[PFQuery alloc] initWithClassName:[Game parseClassName]];
        [query whereKey:@"joinPIN" equalTo:self.joinGameTextField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error){
            if([results count] > 0){
                self.game = [results firstObject];
            }
            self.joinGameButton.alpha = 1;
            self.joinGameButton.enabled = YES;
        }];
    } else {
        self.joinGameButton.alpha = 0.5;
        self.joinGameButton.enabled = NO;
    }
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = [[UIScreen mainScreen] bounds];
        }];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (self.game){
        if (self.game.joinable){
        return true;
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game In Progress" message:@"That game has already started, dog." delegate:self cancelButtonTitle:@"Damn, dog" otherButtonTitles:nil];
        [alert show];
        return false;
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Code" message:@"There is no game with that code." delegate:self cancelButtonTitle:@"Damn" otherButtonTitles:nil];
    [alert show];
    return false;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"JoinGameToInfo"]){
        JoinGameInfoViewController* info = segue.destinationViewController;
        info.game = self.game;
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
