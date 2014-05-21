//
//  OutBox.m
//  Corkie
//
//  Created by Charles Feinn on 5/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "OutBox.h"
#import "GetMe.h"
#import "Review2.h"

@implementation OutBox


-(void)userDidCellarWine:(Wine2 *)wine
{
    NSLog(@"%@ put %@ in their cellar",[GetMe sharedInstance].me.name_display,wine.brand);
}

-(void)userCreatedTastingRecord:(TastingRecord2 *)tastingRecord
{
    Review2 *review = [[tastingRecord.reviews filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"user.identifier = %@",[GetMe sharedInstance].me.identifier]] anyObject];
    NSLog(@"%@ tried %@ and wrote %@",[GetMe sharedInstance].me.name_display,review.tastingRecord.wine.brand,review.review_text);
}

@end
