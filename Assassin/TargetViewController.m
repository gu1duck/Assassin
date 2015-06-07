//
//  TargetViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "TargetViewController.h"
#import "Player.h"
#import "GamestateViewController.h"

@interface TargetViewController ()
@property (weak, nonatomic) IBOutlet UIButton *assassinateButton;
@property (nonatomic) UIImage *assassinationPhoto;

@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.assassinateButton.layer.cornerRadius = self.assassinateButton.frame.size.width/2;
    self.assassinateButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.player.dead){
        
        [self showDeadUI];
        
    } else if (self.player.target == self. player){
        [self showWinUI];
    } else {
        
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [super viewWillAppear:animated];
        
        if (self.assassinationPhoto) {
            self.targetImageView.image = self.assassinationPhoto;
        }
        else {
            
            
            [self.player.target fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
                if (self.player.target.dead){
                    [self.player.target.deadPhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
                        self.targetImageView.image = [UIImage imageWithData:imageData];
                    }];
                } else {
                    [self.player.target.alivePhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
                        self.targetImageView.image = [UIImage imageWithData:imageData];
                        
                    }];
                    
                }
            }];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    self.assassinationPhoto = nil;
}





- (IBAction)assassinateButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Your Weapon" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = true;
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1:{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = true;
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [self applyRedFilter:info[UIImagePickerControllerEditedImage]];
    
    /* We should do a final check here to make sure the player wasn't killed while they were in the photo picker.
     Ideally, we can minimize the chances of things getting messed up in shootouts between the last two players.*/
    dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [self.player fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (self.player.dead){
            [self showDeadUI];
        } else {
            //Mark target as dead before doing anything else
            [self.player.target fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
                dispatch_async(background_queue, ^{
                    self.player.target.dead = true;
                    [self.player.target save];
                });
                
                self.assassinationPhoto = image;
                NSData* deadPhotoJPG = UIImageJPEGRepresentation(image, 1.0);
                PFFile* deadPhoto = [PFFile fileWithName:@"dead.jpeg" data:deadPhotoJPG];
                [deadPhoto saveInBackgroundWithBlock:^(BOOL success, NSError* error){
                    
                    dispatch_async(background_queue, ^{
                        self.player.target.deadPhoto = deadPhoto;
                        [self.player.target save];
                        
                        [self.player.target.target fetchIfNeeded];
                        self.player.target = self.player.target.target;
                        if (self.player.target == self.player){
                            self.player.game.winner = self.player;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showWinUI];
                            });
                        } else {
                            self.player.knowsTarget = NO;
                        }
                        [self.player save];
                        
                    });
                }];
            }];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)applyRedFilter:(UIImage *)originalImage {
    CIColor *Color = [CIColor colorWithRed:1 green:0 blue:0];
    
    CIContext *context =[CIContext contextWithOptions:nil];
    CIImage *image = [[CIImage alloc]initWithImage:originalImage];
    
    CIFilter *redFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [redFilter setValue:image forKey:kCIInputImageKey];
    [redFilter setValue:Color forKey:kCIInputColorKey];
    [redFilter setValue:@1 forKey:kCIInputIntensityKey];
    
    CIImage *output = [redFilter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [output extent];
    CGImageRef cgiImage = [context createCGImage:output fromRect:extent];
    
    UIImageOrientation originalOrientation = originalImage.imageOrientation;
    
    return [UIImage imageWithCGImage:cgiImage scale:1 orientation:originalOrientation];
    
}

-(void)showDeadUI{
    self.assassinateButton.hidden = YES;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    label.text = @"You are dead";
    UIFont* assassinFont = [UIFont fontWithName:@"courier" size:24];
    label.font = assassinFont;
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.targetImageView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1
                                                            constant:16.0]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1
                                                            constant:0.0]];
    
    [self.player.deadPhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
        self.targetImageView.image = [UIImage imageWithData:imageData];
    }];

}

-(void)showWinUI{
    self.assassinateButton.hidden = YES;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    label.text = @"You won the game";
    UIFont* assassinFont = [UIFont fontWithName:@"courier" size:24];
    label.font = assassinFont;
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.targetImageView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1
                                                            constant:16.0]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1
                                                            constant:0.0]];
    
    [self.player.alivePhoto getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error){
        self.targetImageView.image = [UIImage imageWithData:imageData];
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
