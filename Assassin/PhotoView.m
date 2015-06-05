//
//  AlertView.m
//  Assassin
//
//  Created by Jeremy Petter on 2015-06-04.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView ()

@end

@implementation PhotoView


- (void) showAlertView: (UIView*) parentView{
    UIView * background = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    background.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [parentView addSubview:background];
    
    CGRect alertFrame;
    
    alertFrame.size.width = [[UIScreen mainScreen] bounds].size.width * 0.8;
    alertFrame.size.height = alertFrame.size.width * 7/6;
    alertFrame.origin.x = [[UIScreen mainScreen] bounds].size.width * 0.1;
    alertFrame.origin.y = -[[UIScreen mainScreen] bounds].size.height + ([[UIScreen mainScreen] bounds].size.height * 0.1);
    UIView* alert = [[UIView alloc] initWithFrame:alertFrame];
    alert.translatesAutoresizingMaskIntoConstraints = NO;
    [background addSubview:alert];
    
    alert.backgroundColor = [UIColor whiteColor];
    
    CGRect imageFrame;
    imageFrame.size.width = alert.frame.size.width * 0.9;
    imageFrame.size.height = alert.frame.size.width * 0.9;
    imageFrame.origin.x = alert.frame.size.width * 0.05;
    imageFrame.origin.y = alert.frame.size.width * 0.05;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [alert addSubview: imageView];
    imageView.backgroundColor = [UIColor blueColor];
    
    imageView.image = self.image;
    
    alert.layer.shadowOffset = CGSizeMake(-5, 5);
    alert.layer.shadowRadius = 5;
    alert.layer.shadowOpacity = 0.5;
    
    CGRect textFrame;
    textFrame.size.width = alert.frame.size.width * 0.9;
    textFrame.size.height = alert.frame.size.height - imageView.frame.size.height -alert.frame.size.width * .15;
    textFrame.origin.x = alert.frame.size.width * 0.05;
    textFrame.origin.y = imageView.frame.size.height + alert.frame.size.width * 0.1;
    UILabel* text = [[UILabel alloc] initWithFrame:textFrame];
    [alert addSubview: text];
    
    text.text = self.labelText;
    UIFont* assassinFont = [UIFont fontWithName:@"courier" size:24];
    text.font = assassinFont;
    text.textAlignment = NSTextAlignmentCenter;
    text.adjustsFontSizeToFitWidth = YES;
    
    alert.transform = CGAffineTransformMakeRotation(M_PI);

    
    CGRect keyFrame;
    
    keyFrame.size.width = [[UIScreen mainScreen] bounds].size.width * 0.8;
    keyFrame.size.height = keyFrame.size.width * 7/6;
    keyFrame.origin.x = [[UIScreen mainScreen] bounds].origin.x + [[UIScreen mainScreen] bounds].size.width * 0.1;
    keyFrame.origin.y = [[UIScreen mainScreen] bounds].origin.y + [[UIScreen mainScreen] bounds].size.height * 0.1;
    
    CGRect captionFrame;
    captionFrame.size.width = keyFrame.size.width;
    captionFrame.size.height = textFrame.size.height * 2;
    captionFrame.origin.x = keyFrame.origin.x;
    captionFrame.origin.y = keyFrame.origin.y + keyFrame.size.height + keyFrame.size.width * 0.05;
    UILabel* caption = [[UILabel alloc] initWithFrame:captionFrame];
    [background addSubview: caption];
    
    caption.text = self.captionText;
    caption.font = assassinFont;
    caption.textColor = [UIColor whiteColor];
    caption.alpha = 0.0;
    caption.numberOfLines = 2;
    caption.textAlignment = NSTextAlignmentCenter;
    caption.adjustsFontSizeToFitWidth = YES;
    
    
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         alert.transform = CGAffineTransformMakeRotation(0);
                         alert.frame = keyFrame;
                         background.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
                         caption.alpha = 1.0;
                     }
                     completion:nil];
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate
                                                                          action:@selector(handleTapGesture:)];
    self.background = background;
    [self.background addGestureRecognizer:tap];
}

-(void)handleTap:(UITapGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.background.alpha = 0.0;
                         }
                         completion:nil];

        
        [self.background removeFromSuperview];
    }
}

-(instancetype)initWithImage:(UIImage*)image label:(NSString*)labelText andCaption:(NSString*)captionText{
    self = [super init];
    if (self){
        self.captionText = captionText;
        self.image = image;
        self.labelText = labelText;
    }
    return self;
}

-(instancetype)init{
    self = [self initWithImage:nil label:@"" andCaption:@""];
    return self;
}


@end
