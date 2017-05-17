//
//  MarvelResponseDataWrapper.h
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarvelResponseDataWrapper : NSObject
@property (nonatomic, strong) NSNumber * code ;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * copyright ;
@property (nonatomic, strong) NSString * attributionText ;
@property (nonatomic, strong) NSString * attributionHTML ;
@property (nonatomic, strong) NSString * etag ;



@property (nonatomic, strong) NSNumber * count ;
@property (nonatomic, strong) NSNumber * limit ;
@property (nonatomic, strong) NSNumber * offset;


@property (nonatomic, strong) NSArray * results ;




-(instancetype)initWithDictionary:(NSDictionary *)Dictionary;

@end
