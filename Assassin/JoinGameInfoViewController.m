//
//  JoinGameInfoViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-02.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "JoinGameInfoViewController.h"
#import "Player.h"
#import "HopperViewController.h"

@interface JoinGameInfoViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property Player* player;
@property (nonatomic) UIImage* image;

@end

@implementation JoinGameInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneButton.enabled = NO;
    self.doneButton.alpha = 0.5;
    self.nameTextField.delegate = self;
    
    Player* player = [Player object];
    [player saveInBackgroundWithBlock:^(BOOL success, NSError* error){
            [player setupWithGame:self.game];
            self.player = player;
    }];

}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.player deleteInBackground];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frameUp = self.view.frame;
        frameUp.origin.y -=150;
        self.view.frame = frameUp;
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = [[UIScreen mainScreen] bounds];
    }];
    if (self.imageView.image && ![self.nameTextField.text isEqualToString:@""]){
        self.doneButton.enabled = YES;
        self.doneButton.alpha = 1;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameTextField resignFirstResponder];
    return false;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"signupToHopper"]){
        HopperViewController* hopper = segue.destinationViewController;
        hopper.game = self.game;
        hopper.player = self.player;
        
        dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(background_queue, ^{
            self.player.name = self.nameTextField.text;
            [self.player uploadAlivePhoto:self.image];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hopper updateGameData];

            });
        });
    }
}


#pragma mark - ImagePicker & Filter

- (IBAction)pickerButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
    [actionSheet showInView:self.view];
    //
    if (self.imageView.image && ![self.nameTextField.text isEqualToString:@""]){
        self.doneButton.enabled = YES;
        self.doneButton.alpha = 1;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = true;
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
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
    self.image = [self desaturateImage:info [UIImagePickerControllerEditedImage]];
    self.imageView.image = self.image;
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIImage *)desaturateImage:(UIImage *)originalImage {
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *image = [[CIImage alloc]initWithImage:originalImage];
    
    CIFilter *desaturateFilter =[CIFilter filterWithName:@"CIPhotoEffectNoir"];
    [desaturateFilter setValue:image forKey:kCIInputImageKey];
    
    CIImage *result = [desaturateFilter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    CGImageRef cgimage = [context createCGImage:result fromRect:extent];
    
    UIImageOrientation originalOrientation = originalImage.imageOrientation;
    return [UIImage imageWithCGImage:cgimage scale:1 orientation:originalOrientation];
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
