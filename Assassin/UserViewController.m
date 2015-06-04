//
//  UserViewController.m
//  Assassin
//
//  Created by Aaron Williams on 2015-06-04.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "UserViewController.h"
#import "Player.h"

@interface UserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic) Player *CurrentPlayer;
@property (nonatomic) PFUser *user;

@end

@implementation UserViewController

-(void)viewDidAppear:(BOOL)animated {
    self.user = self.CurrentPlayer.user;
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
}

-(void)signUp {
    self.user.email = self.emailField.text;
    self.user.username = self.emailField.text;
    self.user.password = self.passwordField.text;
    
    [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            return;
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)logoutButtonPressed:(UIButton *)sender {
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
