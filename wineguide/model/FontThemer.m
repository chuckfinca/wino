//
//  FontThemer.m
//  Corkie
//
//  Created by Charles Feinn on 1/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FontThemer.h"
#import "ColorSchemer.h"

@interface FontThemer ()

@end

@implementation FontThemer

static FontThemer *sharedInstance;

+(FontThemer *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(UIFont *)headline
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

-(UIFont *)subHeadline
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

-(UIFont *)body
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

-(UIFont *)caption1
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

-(UIFont *)caption2
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
}

-(UIFont *)footnote
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}



-(NSDictionary *)primaryBodyTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : self.body};
}

-(NSDictionary *)primaryFootnoteTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : self.footnote};
}

-(NSDictionary *)primarySubHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : self.subHeadline};
}



-(NSDictionary *)secondaryBodyTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : self.body};
}

-(NSDictionary *)secondaryCaption1TextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : self.caption1};
}

-(NSDictionary *)secondaryFootnoteTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : self.footnote};
}

-(NSDictionary *)linkBodyTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].clickable, NSFontAttributeName : self.body};
}

-(NSDictionary *)linkCaption1TextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].clickable, NSFontAttributeName : self.caption1};
}

-(NSDictionary *)whiteSubHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].customWhite, NSFontAttributeName : self.subHeadline};
}

@end
