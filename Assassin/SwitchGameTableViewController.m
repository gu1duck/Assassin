//
//  SwitchGameTableViewController.m
//  Assassin
//
//  Created by Aaron Williams on 2015-06-04.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "SwitchGameTableViewController.h"

@interface SwitchGameTableViewController ()

@property (nonatomic) NSMutableArray *playerArray;
@end

@implementation SwitchGameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerArray = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:[Player parseClassName]];
    [query whereKey:@"user" equalTo:self.player.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error){
        self.playerArray = [results mutableCopy];
        [self.tableView reloadData];
    }];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
