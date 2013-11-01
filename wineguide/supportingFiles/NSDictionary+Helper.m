//
//  NSDictionary+Helper.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key
{
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

@end
