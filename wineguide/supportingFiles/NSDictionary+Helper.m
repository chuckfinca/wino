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
-(id)sanitizedValueForKey:(id)key
{
    id object = [self objectForKey:key];
    if (object == [NSNull null] || [object  isEqual: @""]){
        return nil;
    } if ([object isEqual:@"0"]){
        return @0;
    }
    
    return object;
}

-(id)sanatizedStringForKey:(id)key
{
    id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSString class]]) return nil;
    return object;
}

// used to separate multiple entries resulting from a given JSON dictionary key
-(NSArray *)separateNonNullStringLocatedAtKey:(NSString *)key
{
    NSString *string = [self sanitizedValueForKey:key];
    return [string componentsSeparatedByString:DIVIDER];
}

@end
