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
    if (object == [NSNull null] || [object isEqual:@""]){
        return nil;
    } if ([object isEqual:@"0"]){
        return @0;
    }
    
    return object;
}

-(id)sanitizedStringForKey:(id)key
{
    id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSString class]] || [object isEqualToString:@""] || [object isEqualToString:@"0"]) return nil;
    return object;
}

-(NSDate *)dateFromString:(NSString *)stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss Z"];
    return [dateFormatter dateFromString:stringDate];
}

@end
