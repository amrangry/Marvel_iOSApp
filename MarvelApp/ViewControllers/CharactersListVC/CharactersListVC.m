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


#import "BFRadialWaveHUD.h"


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
    _searchBarController.delegate = self;
    
    
    
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
    topBarSearchView.hidden = !isSearchViewEnable;
    
    
}

-(void) setOffsetWith:(NSInteger) value{
    
    offsetWebServiceResults=offsetWebServiceResults + value;
}


#pragma mark - Search Bar Delegates -
#pragma mark  Autocomplete SearchBar methods -

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   
  
    [self searchAutocompleteWithSubstring:self.substring];
    [self.searchBarController resignFirstResponder];
    //[self.charactersTableView reloadData];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBarController resignFirstResponder];
    
    [self serachBtnPressed:nil];
    
    [self.charactersTableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *searchWordProtection = [self.searchBarController.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (searchWordProtection.length > 0) {
        
        [self searchAutocompleteWithSubstring:searchWordProtection];
        
    } else {
        
    }
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    self.substring = [NSString stringWithString:self.searchBarController.text];
   // self.substring= [self.substring stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    self.substring = [self.substring stringByReplacingCharactersInRange:range withString:text];
    
//    if ([self.substring hasPrefix:@"+"] && self.substring.length >1) {
//        self.substring  = [self.substring substringFromIndex:1];
//    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}



- (void)searchAutocompleteWithSubstring:(NSString *)substring
{
   
    // @"name contains[cd] %@"
    // @"ANY keywords.name CONTAINS[c] %@"
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", substring];
    
    
    NSArray *arrayToBeSearched = [charsItemsArray copy];
    charsItemsArraySearchResults = [[arrayToBeSearched filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.charactersTableView reloadData];
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
            topBarSearchView.hidden=NO;
            topBarViewHUD.hidden=YES;
            numberOfSection=0;
            
            
            // Display a message when the table is empty
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel.text = @"Sorry!\n No characters matchs that name\n Please type another name";
            messageLabel.textColor = [UIColor whiteColor];
            messageLabel.numberOfLines = 3;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            // messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            [messageLabel setFont:[UIFont fontWithName:@"Helvatic-Bold" size:20]];
            
            [messageLabel sizeToFit];
            
            tableView.backgroundView = messageLabel;
           
            
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
                imageVarinetName= @"/portrait_incredible.jpg";
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
    
    BFRadialWaveHUD *hud = [[BFRadialWaveHUD alloc] initWithFullScreen:YES
                                                               circles:6
                                                           circleColor:nil
                                                                  mode:BFRadialWaveHUDMode_Default
                                                           strokeWidth:5.0f];
    [hud setBlurBackground:YES];
    hud.tapToDismiss = NO;
    [hud disco:NO];
    [hud showInView:self.view];


    
    
    [httpClient invokeAPI:url method:HTTPRequestGET parameters:params paramterFormat:paramterStructureTypeNone contentTypeValue:ContentTypeValue_None customContentTypeValueForHTTPHeaderField:nil onSuccess:^(NSData * _Nullable data) {
        [self.charactersTableView.pullToRefreshView stopAnimating];
        [self.charactersTableView.infiniteScrollingView stopAnimating];
        doneLoadingGifImage.hidden=YES;
        centerLogo.hidden=YES;
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [hud dismiss];
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
        doneLoadingGifImage.hidden=YES;
          centerLogo.hidden=YES;
        [hud dismiss];
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
