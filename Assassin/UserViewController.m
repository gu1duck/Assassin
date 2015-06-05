//
//  UserViewController.m
//  Assassin
//
//  Created by Aaron Williams on 2015-06-04.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "UserViewController.h"
#import "StartScreenVIewController.h"
#import "GameStateViewController.h"
#import "HopperViewController.h"
#import "TargetViewController.h"

@interface UserViewController () <UIAlertViewDelegate, UITextFieldDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpHeight;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (nonatomic) PFUser *user;
@property (nonatomic) NSMutableArray *playerArray;
@property (nonatomic) PFObject *currentGame;

@end

@implementation UserViewController

-(void)viewDidAppear:(BOOL)animated {
    
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        self.logoutHeight.constant = 0;
        self.logoutButton.hidden = YES;
        self.tableView.hidden = YES;
    }
    else
    {
        self.signUpHeight.constant = 0;
        self.signUpButton.hidden = YES;
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerArray = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.user = [PFUser currentUser];
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:[Player parseClassName]];
    [query whereKey:@"user" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error){
        self.playerArray = [results mutableCopy];
        [self.tableView reloadData];
    }];

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
    
    StartScreenVIewController *start = [[ UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    [self.tabBarController showViewController:start sender:self];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     
     
 
 }

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.playerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Player *aPlayer = [self.playerArray objectAtIndex:indexPath.row];
    
    PFQuery *gameQuery = [[PFQuery alloc]initWithClassName:[Player parseClassName]];
    [gameQuery whereKey:@"game" equalTo:aPlayer.game];
    [gameQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        Game *aGame = (Game *)object;
        cell.textLabel.text = aGame.name;
    }];
    
    if (aPlayer.dead) {
        [aPlayer.deadPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
            cell.imageView.image = [UIImage imageWithData:imageData];
        }];
    }
    else{
        [aPlayer.alivePhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
            cell.imageView.image = [UIImage imageWithData:imageData];
        }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Player *selectedPlayer = [self.playerArray objectAtIndex:indexPath.row];
    [selectedPlayer.game fetchIfNeeded];
    
    
    if (selectedPlayer.game.joinable) {
        HopperViewController *hopperView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"hopper"];
        hopperView.player = selectedPlayer;
        hopperView.game = selectedPlayer.game;
        [self.tabBarController showViewController:hopperView sender:self];
    }
    else
    {
        UITabBarController* tabController = [[UIStoryboard storyboardWithName:@"GameInProgress" bundle:nil] instantiateInitialViewController];
        UINavigationController* navController = [tabController.viewControllers firstObject];
        GamestateViewController* gameState = [navController.viewControllers firstObject];
        gameState.player = selectedPlayer;
        gameState.game = selectedPlayer.game;
        
        UINavigationController *targetnav = tabController.viewControllers[1];
        TargetViewController *targetView = [targetnav.viewControllers firstObject];
        targetView.player = selectedPlayer;
        
        
    [self.tabBarController showViewController:tabController sender:self];
    }
}


@end
