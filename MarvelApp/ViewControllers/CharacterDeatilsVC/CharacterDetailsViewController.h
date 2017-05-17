//
//  CharacterDetailsViewController.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "ParentUIViewController.h"
#import "MarvelCharacter.h"

@interface CharacterDetailsViewController : ParentUIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

{


    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *descriptionTxt;
    
    __weak IBOutlet UIImageView *coverImage;
     __weak IBOutlet UIActivityIndicatorView *imageProgress;
    
    
    IBOutlet UICollectionView *comicsCollectionView;
    
}
@property (weak, nonatomic) MarvelCharacter *marvelCharacterObj;
@property (nonatomic) bool isLoadingCoverImage;

- (IBAction)backBtnPressed:(id)sender;

@end
