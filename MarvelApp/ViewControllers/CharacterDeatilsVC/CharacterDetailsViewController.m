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

NSMutableArray * seriesThumbnilURIArray;
NSArray *seriesItems;

NSMutableArray * storiesThumbnilURIArray;
NSArray *storiesItems;

NSMutableArray * eventsThumbnilURIArray;
NSArray *eventsItems;

#pragma -mark viewController lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 2);
    
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
        imageProgress.hidden=YES;
        [imageProgress stopAnimating];
    }
    
    comicsThumbnilURIArray=[NSMutableArray new];
    
    MarvelCharacter *test=_marvelCharacterObj;
    
    comicsItems=[_marvelCharacterObj.comics objectForKey:@"items"];
    
    seriesItems=[_marvelCharacterObj.series objectForKey:@"items"];
    
    eventsItems=[_marvelCharacterObj.events objectForKey:@"items"];
    
    storiesItems=[_marvelCharacterObj.stories objectForKey:@"items"];
    
    for (NSDictionary *resource in comicsItems) {
        
        NSString *resourceURI = [resource objectForKey:@"resourceURI"];
        
        [self getComicObjectForResource:resourceURI];
        // [resourcesURIArray addObject:resourceURI];
        
    }
    
    for (NSDictionary *resource in seriesItems) {
        
        NSString *resourceURI = [resource objectForKey:@"resourceURI"];
        
        [self getSeriesObjectForResource:resourceURI];
        // [resourcesURIArray addObject:resourceURI];
        
    }
    
    for (NSDictionary *resource in eventsItems) {
        
        NSString *resourceURI = [resource objectForKey:@"resourceURI"];
        
        [self getEventsObjectForResource:resourceURI];
        // [resourcesURIArray addObject:resourceURI];
        
    }
    
    for (NSDictionary *resource in storiesItems) {
        
        NSString *resourceURI = [resource objectForKey:@"resourceURI"];
        
        [self getStoriesObjectForResource:resourceURI];
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
    
    NSInteger count = 0;
    if (collectionView == comicsCollectionView) {
        count =  comicsThumbnilURIArray.count;
    }else if (collectionView == eventsCollectionView){
        count=eventsThumbnilURIArray.count;
       // count=eventsItems.count;
    }else if (collectionView == seriesCollectionView){
    
        count = seriesThumbnilURIArray.count;
        //count= seriesItems.count;
        
    }else if (collectionView == stroiesCollectionView){
    
        count=storiesThumbnilURIArray.count;
        //count=storiesItems;
    }
    
    count =  comicsThumbnilURIArray.count;
    return  count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    static NSString *cellCollectionIdentifier = @"ComicsCollectionViewCell";
    
    ComicsCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellCollectionIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        //cell= [[ComicsCollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
       // cell = [[ComicsCollectionViewCell alloc]initw]
        NSLog(@"");
    }
    
    NSString * thumbNilImagURI;
    if (collectionView == comicsCollectionView) {
       thumbNilImagURI = [comicsThumbnilURIArray objectAtIndex:indexPath.row];
    }else if (collectionView == eventsCollectionView){
       thumbNilImagURI = [eventsThumbnilURIArray objectAtIndex:indexPath.row];
    }else if (collectionView == seriesCollectionView){
       thumbNilImagURI = [seriesThumbnilURIArray objectAtIndex:indexPath.row];
    }else if (collectionView == stroiesCollectionView){
        thumbNilImagURI = [storiesThumbnilURIArray objectAtIndex:indexPath.row];
    }
    
     thumbNilImagURI = [comicsThumbnilURIArray objectAtIndex:indexPath.row];
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
            [eventsCollectionView reloadData];
            [seriesCollectionView reloadData];
            [stroiesCollectionView reloadData];
        }
        
    } andFailure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

-(void)getStoriesObjectForResource:(NSString *)resourceURI{
    
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
            if (!([thumbnailDict isKindOfClass:[NSNull class]])) {
                
                NSString * thumbNilImagURI = [thumbnailDict objectForKey:@"path"];
                 [storiesThumbnilURIArray addObject:thumbNilImagURI];
            }
            
        }
        if (storiesThumbnilURIArray.count >= storiesItems.count) {
          
            [stroiesCollectionView reloadData];
        }
        
    } andFailure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


-(void)getEventsObjectForResource:(NSString *)resourceURI{
    
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
            if (thumbnailDict) {
                  
            NSString * thumbNilImagURI = [thumbnailDict objectForKey:@"path"];
            
            [eventsThumbnilURIArray addObject:thumbNilImagURI];
            }
        }
        if (eventsThumbnilURIArray.count >= eventsItems.count) {
           
            [eventsCollectionView reloadData];
            
        }
        
    } andFailure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}
-(void)getSeriesObjectForResource:(NSString *)resourceURI{
    
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
            
            [seriesThumbnilURIArray addObject:thumbNilImagURI];
        
        }

        if (seriesThumbnilURIArray.count >= seriesItems.count) {
            [seriesCollectionView reloadData];
           
        }
        
    } andFailure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma -mark DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *msg= @"   Loading ... . ";;
  
    // Display a message when the table is empty

    NSString *text = msg;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17],
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

@end
