//
//  StartScreenVIewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "StartScreenVIewController.h"
#import <Parse/Parse.h>

@interface StartScreenVIewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBottomMargin;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation StartScreenVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonsBottomMargin.constant = -225;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    PFUser *user = [PFUser currentUser];
    if (!user.username) {
        return;
    }
    else
    {
        self.loginButton.hidden = YES;
    }

    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:0
                     animations:^{
        self.buttonsBottomMargin.constant = 0;
    }
                     completion:nil];
    

}


#pragma mark - Navigation



/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
