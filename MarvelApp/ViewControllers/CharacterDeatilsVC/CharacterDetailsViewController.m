//
//  CharacterDetailsViewController.m
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "CharacterDetailsViewController.h"
#import "UIImage+Extension.h"
#import "ComicsCollectionViewCell.h"

#import "MBProgressHUD.h"
#import "HttpClient.h"
#import <CommonCrypto/CommonDigest.h>

#import "MarvelCharacter.h"
#import "MarvelResponseDataWrapper.h"
#import "PopUpViewController.h"

@interface CharacterDetailsViewController ()

@end

@implementation CharacterDetailsViewController


NSMutableArray * comicsThumbnilURIArray;
NSArray *comicsItems;



#pragma -mark viewController lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    name.text=_marvelCharacterObj.name;
    descriptionTxt.text= _marvelCharacterObj.descriptionMarvelCharacter;
    
    
    NSString * thumbNilImagURI = [_marvelCharacterObj.thumbnail objectForKey:@"path"];
    NSString * imageVarinetName = @"/portrait_incredible.jpg";
    
    if (_isLoadingCoverImage) {
     
        NSString * imageUrl =[NSString stringWithFormat:@"%@%@",thumbNilImagURI,imageVarinetName];
    
         [UIImage downloadImageURL:imageUrl onSuccess:^(UIImage * _Nullable image) {
        
                 coverImage.image = image;
                 coverImage.contentMode=UIViewContentModeScaleToFill;
                 imageProgress.hidden=YES;
                 [imageProgress stopAnimating];
                  _marvelCharacterObj.imgThumbnil=image;
        
         } andFailure:^(NSString * _Nonnull error) {
        
                 UIImage *img = [UIImage imageNamed:@"Placeholder_couple_superhero"];
                 coverImage.image = img;
                 imageProgress.hidden=YES;
                 [imageProgress stopAnimating];
         }];
    
    }else{
    
       coverImage.image=_marvelCharacterObj.imgThumbnil;
    }
    
    
    comicsThumbnilURIArray=[NSMutableArray new];
    
    comicsItems=[_marvelCharacterObj.comics objectForKey:@"items"];
    
    for (NSDictionary *comicsResource in comicsItems) {
        
        NSString *resourceURI = [comicsResource objectForKey:@"resourceURI"];
        
        
        [self getComicObjectForResource:resourceURI];
       // [resourcesURIArray addObject:resourceURI];
        
    }
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma - mark CollectionView Delgates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  comicsThumbnilURIArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString *cellCollectionIdentifier = @"ComicsCollectionViewCell";
    
    ComicsCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellCollectionIdentifier forIndexPath:indexPath];
    
    
    
    NSString * thumbNilImagURI = [comicsThumbnilURIArray objectAtIndex:indexPath.row];
    NSString * imageVarinetName = @"/portrait_incredible.jpg";
    
    
        
        
        if ([self IsEmpty:thumbNilImagURI]==YES || [thumbNilImagURI class]==[NSNull class]) {
            UIImage *img = [UIImage imageNamed:@"placeholder2_marvel"];
           
            cell.thumbnilImage.image = img;
            cell.animatorLoader.hidden=YES;
            [cell.animatorLoader stopAnimating];
        }else{
            cell.animatorLoader.hidden=NO;
            [cell.animatorLoader startAnimating];
            
    
            
            NSString * imageUrl =[NSString stringWithFormat:@"%@%@",thumbNilImagURI,imageVarinetName];
            
            
            
            [UIImage downloadImageURL:imageUrl onSuccess:^(UIImage * _Nullable image) {
                
                cell.thumbnilImage.image = image;
                cell.thumbnilImage.contentMode=UIViewContentModeScaleAspectFill;
                cell.animatorLoader.hidden=YES;
                [cell.animatorLoader stopAnimating];
                
            } andFailure:^(NSString * _Nonnull error) {
                
                UIImage *img = [UIImage imageNamed:@"Placeholder_couple_superhero"];
                cell.thumbnilImage.image = img;
                cell.animatorLoader.hidden=YES;
                [cell.animatorLoader stopAnimating];
            }];
            
            
            
            
        }
    
    
    
    [cell updateConstraintsIfNeeded];
    return cell;
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // Product *productObj =[arrayOfDataSearch objectAtIndex:indexPath.row];
    
    PopUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpViewController"];
    
    ComicsCollectionViewCell * cell =(ComicsCollectionViewCell *)[comicsCollectionView cellForItemAtIndexPath:indexPath];
    
    vc.img=cell.thumbnilImage.image;
    //[vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [vc setModalInPopover:YES];
    [vc setModalPresentationStyle: UIModalPresentationOverFullScreen];
    [self presentViewController:vc animated:YES completion:nil];
  
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat marginWidth = (screenWidth - collectionView.frame.size.width);
    
    CGFloat collectionHeight=collectionView.frame.size.height;
    CGFloat cellWith = (collectionView.frame.size.width - marginWidth )/4;
    cellWith= floorf(cellWith);
    
    
    CGSize cellSize = CGSizeMake(cellWith,collectionHeight);
    return cellSize;
}



#pragma -mark webservice call

-(void)getComicObjectForResource:(NSString *)resourceURI{
    
    
    HttpClient * httpClient =[HttpClient sharedInstance];
    
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    
    // md5(ts+privateKey+publicKey)
    NSString *md5BuilderString=[NSString stringWithFormat:@"%@%@%@",timeStampObj,private_key,public_key];
    NSString *hashedMD5BuilderString=[self md5:md5BuilderString];
    
    
    
    NSMutableDictionary *params =[NSMutableDictionary new];
    
    [params setObject:public_key forKey:@"apikey"];
    [params setObject:timeStampObj forKey:@"ts"];
    [params setObject:hashedMD5BuilderString forKey:@"hash"];
    
    
    NSString *url =[NSString stringWithFormat:@"%@",resourceURI];
  
    [httpClient invokeAPI:url method:HTTPRequestGET parameters:params paramterFormat:paramterStructureTypeNone contentTypeValue:ContentTypeValue_None customContentTypeValueForHTTPHeaderField:nil onSuccess:^(NSData * _Nullable data) {
        
       
        // success: do something with returned data
        
        NSError *jsonError;
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
        MarvelResponseDataWrapper * marvelResponseDataWrapper =[[MarvelResponseDataWrapper alloc] initWithDictionary:Json];
        
        
        for (NSDictionary *dict in marvelResponseDataWrapper.results) {
            
           
            NSDictionary * thumbnailDict = [dict objectForKey:@"thumbnail"];
            NSString * thumbNilImagURI = [thumbnailDict objectForKey:@"path"];
            
            [comicsThumbnilURIArray addObject:thumbNilImagURI];
            
        }
        
        
        if (comicsThumbnilURIArray.count >= comicsItems.count) {
            [comicsCollectionView reloadData];
        }
        
    } andFailure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

@end
