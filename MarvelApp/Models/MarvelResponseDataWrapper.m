//
//  MarvelResponseDataWrapper.m
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "MarvelResponseDataWrapper.h"

@implementation MarvelResponseDataWrapper

-(instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    
    self=[super init];
    if (self) {
        NSDictionary *Json=Dictionary;
             _code =[Json objectForKey:@"code"];
             _status =[Json objectForKey:@"status"];
             _copyright =[Json objectForKey:@"copyright"];
             _attributionText =[Json objectForKey:@"attributionText"];
             _attributionHTML =[Json objectForKey:@"attributionHTML"];
             _etag =[Json objectForKey:@"etag"];
        
             NSDictionary * data =[Json objectForKey:@"data"];

             _count =[data objectForKey:@"count"];
             _limit =[data objectForKey:@"limit"];

             _offset =[data objectForKey:@"offset"];

             _results =[data objectForKey:@"results"];
    }
    
    return self;
}
@end
