//
//  ComicsCollectionViewCell.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnilImage;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animatorLoader;

@end
