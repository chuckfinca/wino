//
//  DateStringFormatter.m
//  Corkie
//
//  Created by Charles Feinn on 1/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "DateStringFormatter.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@implementation DateStringFormatter

+(NSString *)formatStringForTimelineDate:(NSDate *)date
{
    NSString *localDateString;
    
    if(date){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *tastingDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:date];
        NSDateComponents *currentDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
        
        if(tastingDateComponents.year == currentDateComponents.year && tastingDateComponents.month == currentDateComponents.month){
            if (tastingDateComponents.day == currentDateComponents.day) {
                localDateString = @"today";
            } else if (currentDateComponents.day - tastingDateComponents.day < 7){
                localDateString = [NSString stringWithFormat:@"%ldd",(long)(currentDateComponents.day - tastingDateComponents.day)];
            } else {
                localDateString = [DateStringFormatter defaultFormattedTastingRecordDateStringForRawDate:date WithYear:tastingDateComponents.year andCurrentYear:currentDateComponents.year];
            }
        } else {
            localDateString = [DateStringFormatter defaultFormattedTastingRecordDateStringForRawDate:date WithYear:tastingDateComponents.year andCurrentYear:currentDateComponents.year];
        }
    }
    
    return localDateString;
}

+(NSString *)defaultFormattedTastingRecordDateStringForRawDate:(NSDate *)date WithYear:(NSInteger)tastingDateYear andCurrentYear:(NSInteger)currentYear
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MM/dd/YY";
    
    NSString *localDateString = [dateFormatter stringFromDate:date];
    
    if(tastingDateYear == currentYear){
        localDateString = [localDateString substringToIndex:4];
    }
    localDateString = [localDateString stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    return localDateString;
}

+(NSAttributedString *)attributedStringFromDate:(NSDate *)date
{
    NSString *dateString = [DateStringFormatter formatStringForTimelineDate:date];
    if(dateString){
        return [[NSAttributedString alloc] initWithString:dateString attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption2, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    }
    return nil;
}

@end
