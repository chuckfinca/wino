//
//  NSDictionary+Helper.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "NSDictionary+Helper.h"

#define DIVIDER @"/"

@implementation NSDictionary (Helper)

// in case of [NSNull null] values a nil is returned ...
-(id)objectForKeyNotNull:(id)key
{
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

// used to separate multiple entries resulting from a given JSON dictionary key
-(NSArray *)separateNonNullStringLocatedAtKey:(NSString *)key
{
    NSString *string = [self objectForKeyNotNull:key];
    return [string componentsSeparatedByString:DIVIDER];
}

@end
