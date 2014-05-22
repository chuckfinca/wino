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
    NSDate *date = [dateFormatter dateFromString:stringDate];
    return date;
}

-(NSDate *)dateAtKey:(id)key
{
    NSDate *date = nil;
    
    id object = [self objectForKey:key];
    
    if([object isKindOfClass:[NSDate class]]){
        return (NSDate *)object;
        
    } else if([object isKindOfClass:[NSString class]]){
        NSString *stringDate = (NSString *)object;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:posix];
        date = [formatter dateFromString:stringDate];
    }
    return date;
}

@end
