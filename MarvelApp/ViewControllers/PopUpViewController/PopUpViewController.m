//
//  PopUpViewController.m
//  Karmadam
//
//  Created by Amr Elghadban on 3/1/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "PopUpViewController.h"


@interface PopUpViewController ()

@end

@implementation PopUpViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{


    [super viewWillAppear:animated];
    
    _displayImage.image=_img;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)skipBtnPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
