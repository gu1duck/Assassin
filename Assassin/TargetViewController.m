//
//  TargetViewController.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-01.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "TargetViewController.h"

@interface TargetViewController ()

@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
    self.targetImageView.image =[self applyRedFilter:info[UIImagePickerControllerEditedImage]];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
