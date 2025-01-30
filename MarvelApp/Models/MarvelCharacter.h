//
//  MarvelCharacter.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface MarvelCharacter : NSObject

@property (nonatomic, strong) NSString *idMarvelCharacter;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionMarvelCharacter;
@property (nonatomic, strong) NSString * modified;
@property (nonatomic, strong) NSDictionary *thumbnail;
@property (nonatomic, strong) NSString *resourceURI;
@property (nonatomic, strong) NSDictionary *comics;
@property (nonatomic, strong) NSDictionary *series;
@property (nonatomic, strong) NSDictionary *stories;
@property (nonatomic, strong) NSDictionary *events;
@property (nonatomic, strong) NSArray *urls;

@property (nonatomic, strong) UIImage *imgThumbnil;

-(instancetype)initWithDictionary:(NSDictionary *)Dictionary;
@end
