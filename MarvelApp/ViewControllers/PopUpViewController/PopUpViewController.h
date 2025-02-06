//
//  PopUpViewController.h
//  Karmadam
//
//  Created by Amr Elghadban on 3/1/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "ParentUIViewController.h"

@interface PopUpViewController : UIViewController{
    
    __weak IBOutlet UIButton *skipButton;
    
    __weak IBOutlet UIView *viewContainer;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *displayImage;

@property (weak, nonatomic) IBOutlet UIImage *img;

- (IBAction)skipBtnPressed:(id)sender;

@end
