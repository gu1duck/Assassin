//
//  UserViewController.m
//  Assassin
//
//  Created by Aaron Williams on 2015-06-04.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "UserViewController.h"
#import "SwitchGameTableViewController.h"

@interface UserViewController () <UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchGameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpHeight;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *emailLine;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (nonatomic) PFUser *user;

@end

@implementation UserViewController

-(void)viewDidAppear:(BOOL)animated {
    
    if (!self.CurrentPlayer.user.username) {
        self.logoutHeight.constant = 0;
        self.logoutButton.hidden = YES;
        self.switchGameHeight.constant = 0;
        self.switchButton.hidden = YES;
    }
    else
    {
        self.signUpHeight.constant = 0;
        self.signUpButton.hidden = YES;
        self.passwordField.hidden = YES;
        self.emailField.hidden = YES;
        self.emailLine.hidden = YES;
        self.passwordLine.hidden = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpButtonPressed:(UIButton *)sender {
    [self signUp];
}

-(void)signUp {
    self.CurrentPlayer.user = [PFUser currentUser];
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        self.CurrentPlayer.user.email = self.emailField.text;
        self.CurrentPlayer.user.username = self.emailField.text;
        self.CurrentPlayer.user.password = self.passwordField.text;
        
        [self.CurrentPlayer.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error) {
                [self.CurrentPlayer.user save];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not sign up, sorry!" delegate:self cancelButtonTitle:@"Dang" otherButtonTitles: nil];
                [alert show];
                NSLog(@"%@", error);;
            }
        }];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)logoutButtonPressed:(UIButton *)sender {
    [PFUser logOut];
    
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
     SwitchGameTableViewController *switchController = [navController.viewControllers firstObject];
     switchController.player = self.CurrentPlayer;
 
 }


@end
