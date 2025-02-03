//
//  CharacterTableViewCell.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbNilImage;
@property (weak, nonatomic) IBOutlet UILabel *titleTxtLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageProgress;

@end
