//
//  ParentUIViewController.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <UIKit/UIKit.h>


#define public_key @"8613149e6800715422f80a7ffd758208"
#define private_key @"1dc2a0df1c02ebce3e183a8a5e17c3bf56b4241b"

@interface ParentUIViewController : UIViewController
-(BOOL) IsEmpty:(id) object;
-(NSString *) md5:(NSString *) input;
@end
