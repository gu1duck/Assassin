//
//  PlayerCollectionViewCell.h
//  Assassin
//
//  Created by Aaron Williams on 2015-06-02.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;

@end
