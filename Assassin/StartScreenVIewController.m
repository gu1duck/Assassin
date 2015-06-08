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
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation StartScreenVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        return;
    }
    else
    {
        self.loginButton.hidden = YES;
    }

    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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
