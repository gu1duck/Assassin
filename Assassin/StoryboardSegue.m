//
//  StoryboardSegue.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "StoryboardSegue.h"

@interface StoryboardSegue ()

@end

@implementation StoryboardSegue

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarController* tabBar = [[UIStoryboard storyboardWithName:@"GameInProgress" bundle:nil] instantiateInitialViewController];
//    UINavigationController* navController = [tabBar.viewControllers firstObject];
//    UIViewController* controller = [navController.viewControllers firstObject];
    [self.navigationController pushViewController:tabBar animated:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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
