//
//  AlertView.h
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-04.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoView;

@protocol PhotoViewDelegate <NSObject>

-(void)handleTapGesture: (UITapGestureRecognizer*)tap;

@end

@interface PhotoView : NSObject

@property (weak, nonatomic) id<PhotoViewDelegate> delegate;
@property (nonatomic) UIView* background;
@property (nonatomic) NSString* labelText;
@property (nonatomic) NSString* captionText;
@property (nonatomic) UIImage* image;

-(instancetype)initWithImage:(UIImage*)image label:(NSString*)labelText andCaption:(NSString*)captionText;
-(void)showAlertView:(UIView*)parentView;


@end

 /*Default delegate method:

 
-(void)handleTapGesture: (UITapGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.alert.background.alpha = 0.0;
                         }
                         completion:^(BOOL success){
                             [self.alert.background removeFromSuperview];
                         }];
    }
}

*/ 
