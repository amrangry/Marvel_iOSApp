//
//  ParentUIViewController.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define public_key @"<your public key>"
#define private_key @"<your private key>"

@interface ParentUIViewController : UIViewController
-(BOOL) IsEmpty:(id) object;
-(NSString *) md5:(NSString *) input;
@end
