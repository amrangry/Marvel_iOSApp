//
//  CharactersListVC.m
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "CharactersListVC.h"
#import "CharacterTableViewCell.h"
#import "MBProgressHUD.h"
#import "HttpClient.h"

#import "MarvelCharacter.h"
#import "MarvelResponseDataWrapper.h"
#import "CharacterDetailsViewController.h"

#import "UIImage+Extension.h"
#import "UIImage+animatedGIF.h"

#import "SVPullToRefresh.h"

@implementation CharactersListVC

NSMutableArray *charsItemsArray;
NSMutableArray *charsItemsArraySearchResults;
bool isSearchViewEnable;




#pragma -mark viewController lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //loading gif image while loading
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"marvel-gif" withExtension:@"gif"];
    doneLoadingGifImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
    //init the values
    limitWebServiceResults = 10;
    offsetWebServiceResults = 0;
    isSearchViewEnable = NO;
    charsItemsArray=[NSMutableArray new];
    
   
    //set delgates
    [self.charactersTableView setDelegate:self];
    [self.charactersTableView setDataSource:self];
    searchBarView.delegate = self;
    
    
    
    // Setup pull and inifinte scrolling
    
    CharactersListVC *weakSelf = self;
    // setup infinite scrolling
    [self.charactersTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getCharactersWithLimit:weakSelf->limitWebServiceResults andOffset:weakSelf->offsetWebServiceResults];
    }];
    
     // setup pull to refresh scrolling
    [self.charactersTableView addPullToRefreshWithActionHandler:^{
         [weakSelf getCharactersWithLimit:weakSelf->limitWebServiceResults andOffset:weakSelf->offsetWebServiceResults];
    }];

    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_charactersTableView triggerInfiniteScrolling];
}

#pragma -mark IBAction methods and helpers

- (IBAction)serachBtnPressed:(id)sender {
    
    isSearchViewEnable =! isSearchViewEnable;
    
    topBarView.hidden = isSearchViewEnable;
    
    [self.charactersTableView reloadData];
}

-(void) setOffsetWith:(NSInteger) value{
    
    offsetWebServiceResults=offsetWebServiceResults + value;
}

#pragma -mark - SearchBar
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBarView resignFirstResponder];
    
    [self serachBtnPressed:nil];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBarView resignFirstResponder];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchBar.text];
   charsItemsArraySearchResults = [[charsItemsArray filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.charactersTableView reloadData];
   // [self loadDataForSearchKey:searchBarView.text];
}






#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    
    NSInteger numberOfSection;
    
    if (isSearchViewEnable) {
        
        if (charsItemsArraySearchResults.count>=1) {
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.backgroundView.hidden=YES;
            //tableView.hidden=NO;
            
            
            topBarView.hidden=YES;
            topBarSearchView.hidden=NO;
            topBarViewHUD.hidden=NO;
            numberOfSection = 1;
            
        } else {
            
        
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            topBarView.hidden=YES;
            topBarSearchView.hidden=YES;
            topBarViewHUD.hidden=YES;
            numberOfSection=0;
        }
    
    }else{
    
    if (charsItemsArray.count>=1) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView.hidden=YES;
        //tableView.hidden=NO;
      
         numberOfSection = 1;
        
        topBarView.hidden=NO;
        topBarSearchView.hidden=YES;
         topBarViewHUD.hidden=NO;
    } else {
        
       
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        topBarView.hidden=YES;
        topBarSearchView.hidden=YES;
         topBarViewHUD.hidden=YES;
        numberOfSection=0;
       }
    }
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSInteger numberOfRows = 0;
    
    if (isSearchViewEnable) {
   numberOfRows =  [charsItemsArraySearchResults count];
    }else{
   numberOfRows =  [charsItemsArray count];
    }
    
    return numberOfRows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight=140;
    if (isSearchViewEnable== YES){
        
        rowHeight = 65;
    }
    
    return rowHeight;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier ;
    
    MarvelCharacter *marvelCharacterObj;
    
    if (isSearchViewEnable) {
        cellIdentifier = @"SearchCharTableCell";
        marvelCharacterObj=[charsItemsArraySearchResults objectAtIndex:indexPath.row];
    }else{
        cellIdentifier = @"CharacterTableViewCell";
        marvelCharacterObj=[charsItemsArray objectAtIndex:indexPath.row];
    }
    
    
    CharacterTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    
    if (cell == nil) {
        cell= [[CharacterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.titleTxtLabel.text=marvelCharacterObj.name;
    
    NSString * thumbNilImagURI = [marvelCharacterObj.thumbnail objectForKey:@"path"];
    NSString * imageVarinetName;
   
    
    if (marvelCharacterObj.imgThumbnil) {
        
        cell.thumbNilImage.image = marvelCharacterObj.imgThumbnil;
        cell.imageProgress.hidden=YES;
        [cell.imageProgress stopAnimating];
        
    }else{
    
    
        if ([self IsEmpty:thumbNilImagURI]==YES || [thumbNilImagURI class]==[NSNull class]) {
            UIImage *img = [UIImage imageNamed:@"placeholder2_marvel"];
             cell.thumbNilImage.image = img;
             cell.imageProgress.hidden=YES;
             [cell.imageProgress stopAnimating];
        }else{
            cell.imageProgress.hidden=NO;
            [cell.imageProgress startAnimating];
            
            if (isSearchViewEnable) {
                imageVarinetName= @"/standard_medium.jpg";
              }else{
                imageVarinetName = @"/landscape_amazing.jpg";
             }

            NSString * imageUrl =[NSString stringWithFormat:@"%@%@",thumbNilImagURI,imageVarinetName];
            
            
            
            [UIImage downloadImageURL:imageUrl onSuccess:^(UIImage * _Nullable image) {
                
                            cell.thumbNilImage.image = image;
                            cell.thumbNilImage.contentMode=UIViewContentModeScaleAspectFill;
                            cell.imageProgress.hidden=YES;
                            [ cell.imageProgress stopAnimating];
                            marvelCharacterObj.imgThumbnil=image;
                
            } andFailure:^(NSString * _Nonnull error) {
              
                            UIImage *img = [UIImage imageNamed:@"Placeholder_couple_superhero"];
                            cell.thumbNilImage.image = img;
                            cell.imageProgress.hidden=YES;
                            [cell.imageProgress stopAnimating];
            }];
            
            
            

        }
     }



    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MarvelCharacter *marvelCharacterObj;
    
    if (isSearchViewEnable) {
        marvelCharacterObj=[charsItemsArraySearchResults objectAtIndex:indexPath.row];
    }else{
        marvelCharacterObj=[charsItemsArray objectAtIndex:indexPath.row];
    }
    
     CharacterDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CharacterDetailsViewController"];
    vc.marvelCharacterObj = marvelCharacterObj;
    
    vc.isLoadingCoverImage = isSearchViewEnable;
    
     [self.navigationController pushViewController:vc animated:YES];
}




#pragma -mark webservice call
-(void)getCharactersWithLimit:(NSInteger)limit andOffset:(NSInteger) offset{
    
    
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
    [params setObject:[NSString stringWithFormat:@"%ld",(long)limit] forKey:@"limit"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)offset] forKey:@"offset"];

    
    NSString *url =[NSString stringWithFormat:@"%@%@",@"https://gateway.marvel.com:443/",@"v1/public/characters"];
   
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [httpClient invokeAPI:url method:HTTPRequestGET parameters:params paramterFormat:paramterStructureTypeNone contentTypeValue:ContentTypeValue_None customContentTypeValueForHTTPHeaderField:nil onSuccess:^(NSData * _Nullable data) {
        [self.charactersTableView.pullToRefreshView stopAnimating];
        [self.charactersTableView.infiniteScrollingView stopAnimating];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
       
        // success:
        
        NSError *jsonError;
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
        MarvelResponseDataWrapper * marvelResponseDataWrapper =[[MarvelResponseDataWrapper alloc] initWithDictionary:Json];
        
        
        [self setOffsetWith:[marvelResponseDataWrapper.limit integerValue]];
        
        NSMutableArray * characterMutableArray=[NSMutableArray new];
        for (NSDictionary *dict in marvelResponseDataWrapper.results) {
            
            MarvelCharacter *marvelCharacterObj=[[MarvelCharacter alloc] initWithDictionary:dict];
            
            [characterMutableArray addObject:marvelCharacterObj];
            
        }
        
        
        [charsItemsArray addObjectsFromArray:[characterMutableArray copy]];
        
        [self.charactersTableView reloadData];
        
    } andFailure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
        [self.charactersTableView.pullToRefreshView stopAnimating];
        [self.charactersTableView.infiniteScrollingView stopAnimating];
        
      // [MBProgressHUD hideHUDForView:self.view animated:YES];
       /* 
        // Offline  test
        
        NSString *filePath =   [[NSBundle mainBundle] pathForResource:@"test"ofType:@"json"];
        
        NSString* jsonContentString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        // Parse the string to NSData
        NSData * data=[jsonContentString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!jsonError) {
        
            MarvelResponseDataWrapper * marvelResponseDataWrapper =[[MarvelResponseDataWrapper alloc] initWithDictionary:Json];
            
            
            NSMutableArray * characterMutableArray=[NSMutableArray new];
            for (NSDictionary *dict in marvelResponseDataWrapper.results) {
               
                MarvelCharacter *marvelCharacterObj=[[MarvelCharacter alloc] initWithDictionary:dict];
                
                [characterMutableArray addObject:marvelCharacterObj];
                
            }
            
            
            [charsItemsArray addObjectsFromArray:[characterMutableArray copy]];
            
            [self.charactersTableView reloadData];
        }
        */
    }];
    
}



@end
