//
//  FontThemer.h
//  Corkie
//
//  Created by Charles Feinn on 1/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontThemer : NSObject

+(FontThemer *)sharedInstance;

@property (nonatomic, readonly) UIFont *headline;
@property (nonatomic, readonly) UIFont *subHeadline;
@property (nonatomic, readonly) UIFont *body;
@property (nonatomic, readonly) UIFont *caption1;
@property (nonatomic, readonly) UIFont *caption2;
@property (nonatomic, readonly) UIFont *footnote;

@property (nonatomic, readonly) NSDictionary *primaryBodyTextAttributes;
@property (nonatomic, readonly) NSDictionary *primaryFootnoteTextAttributes;
@property (nonatomic, readonly) NSDictionary *primarySubHeadlineTextAttributes;

@property (nonatomic, readonly) NSDictionary *secondaryHeadlineTextAttributes;
@property (nonatomic, readonly) NSDictionary *secondaryBodyTextAttributes;
@property (nonatomic, readonly) NSDictionary *secondaryFootnoteTextAttributes;
@property (nonatomic, readonly) NSDictionary *secondaryCaption1TextAttributes;

@property (nonatomic, readonly) NSDictionary *baseHeadlineTextAttributes;

@property (nonatomic, readonly) NSDictionary *linkCaption1TextAttributes;
@property (nonatomic, readonly) NSDictionary *linkBodyTextAttributes;

@property (nonatomic, readonly) NSDictionary *whiteSubHeadlineTextAttributes;
@property (nonatomic, readonly) NSDictionary *whiteHeadlineTextAttributes;

@end
