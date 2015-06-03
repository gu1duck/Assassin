//
//  HopperViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "HopperViewController.h"

@interface HopperViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *gameTitleTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerConstraint;

@end


@implementation HopperViewController



-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    Player *player =[[Player alloc]init];
    player.host = NO;
    player.name = @"Aaron";
    self.player = player;
    
    self.gameTitleTextField.delegate = self;
    self.gameTitleTextField.placeholder = [NSString stringWithFormat:@"%@'s Game",self.player.name];
    
   
    
    if ( self.player.host == NO ) {
        self.headerConstraint.constant = 0;
        self.gameTitleTextField.hidden = YES;
        
        self.footerConstraint.constant = 0;
        
         }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
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
