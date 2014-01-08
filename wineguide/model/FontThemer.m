//
//  FontThemer.m
//  Corkie
//
//  Created by Charles Feinn on 1/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FontThemer.h"

@interface FontThemer ()

@property (nonatomic, readwrite) UIFont *headline;
@property (nonatomic, readwrite) UIFont *subHeadline;
@property (nonatomic, readwrite) UIFont *body;
@property (nonatomic, readwrite) UIFont *caption1;
@property (nonatomic, readwrite) UIFont *caption2;
@property (nonatomic, readwrite) UIFont *footnote;

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





@end
