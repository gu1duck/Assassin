//
//  JoinGameViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-02.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "JoinGameViewController.h"

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
    if ([self.joinGameTextField.text length] == 4){
        self.joinGameButton.alpha = 1;
        self.joinGameButton.enabled = YES;
    } else {
        self.joinGameButton.alpha = 0.5;
        self.joinGameButton.enabled = NO;
    }
    
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = [[UIScreen mainScreen] bounds];
        }];
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
