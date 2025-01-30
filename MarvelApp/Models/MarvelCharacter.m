//
//  MarvelCharacter.m
//  MarvelApp
//
//  Created by Amr Elghadban on 5/16/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "MarvelCharacter.h"

@implementation MarvelCharacter

-(instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    
    self=[super init];
    if (self) {
        NSDictionary *JSONDictionary=Dictionary;
        
        if (JSONDictionary) {
            for (NSString *key in JSONDictionary) {
                if ([key isEqualToString:@"id"]) {
                    NSString *value=[JSONDictionary objectForKey:@"id"];
                    [self setValue:value forKey:@"idMarvelCharacter"];
                } else if ([key isEqualToString:@"description"]) {
                    NSString *value=[JSONDictionary objectForKey:@"description"];
                    [self setValue:value forKey:@"descriptionMarvelCharacter"];
                }else{
                    [self setValue:[JSONDictionary valueForKey:key] forKey:key];
                }
            }
            
        }
    }
    
    return self;
}

@end
