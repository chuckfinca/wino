//
//  DateStringFormatter.m
//  Corkie
//
//  Created by Charles Feinn on 1/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "DateStringFormatter.h"

#define SECONDS_IN_A_WEEK 604800
#define SECONDS_IN_A_DAY 86400
#define SECONDS_IN_30_MINUTES 1800

@implementation DateStringFormatter

+(NSString *)formatStringForTimelineDate:(NSDate *)date
{
    NSTimeInterval timeSinceTasting = [[NSDate date] timeIntervalSinceDate:date];
    
    NSString *localDateString;
    
    if(timeSinceTasting > SECONDS_IN_A_WEEK){
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MM/dd/YY";
        localDateString = [dateFormatter stringFromDate:date];
        
        NSRange dayZero = NSMakeRange(3, 1);
        if([[localDateString substringWithRange:dayZero] isEqualToString:@"0"]){
            localDateString = [localDateString stringByReplacingCharactersInRange:dayZero withString:@""];
        }
        if([[localDateString substringToIndex:1] isEqualToString:@"0"]){
            localDateString = [localDateString substringFromIndex:1];
        }
        
    } else if(timeSinceTasting > SECONDS_IN_A_DAY){
        int daysSinceTasting = timeSinceTasting/86400;
        localDateString = [NSString stringWithFormat:@"%@d",@(daysSinceTasting)];
        
    } else if(timeSinceTasting > SECONDS_IN_30_MINUTES){
        int hoursSinceTasting = timeSinceTasting/3600;
        if(hoursSinceTasting == 0){
            hoursSinceTasting++;
        }
        localDateString = [NSString stringWithFormat:@"%@h",@(hoursSinceTasting)];
        
    } else  if(timeSinceTasting > 60){
        int minutesSinceTasting = timeSinceTasting/60;
        localDateString = [NSString stringWithFormat:@"%@m",@(minutesSinceTasting)];
        
    } else {
        localDateString = @"just now";
    }

    return localDateString;
}

@end
