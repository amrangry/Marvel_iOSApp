//
//  CharactersListVC.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentUIViewController.h"

@interface CharactersListVC : ParentUIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{

    
    __weak IBOutlet UIView *topBarViewHUD;
    __weak IBOutlet UIView *topBarSearchView;
    __weak IBOutlet UIView *topBarView;
    
    __weak IBOutlet UIImageView *doneLoadingGifImage;

    
    
     IBOutlet UISearchBar *searchBarView;
    
    NSInteger limitWebServiceResults ;
    NSInteger offsetWebServiceResults;
}


- (IBAction)serachBtnPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *charactersTableView;


@end
