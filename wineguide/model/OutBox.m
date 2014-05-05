//
//  OutBox.m
//  Corkie
//
//  Created by Charles Feinn on 5/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "OutBox.h"
#import "GetMe.h"
#import "Review.h"

@implementation OutBox


-(void)userDidCellarWine:(Wine *)wine
{
    NSLog(@"%@ put %@ in their cellar",[GetMe sharedInstance].me.nameFull,wine.brand);
}

-(void)userCreatedTastingRecord:(TastingRecord *)tastingRecord
{
    Review *review = [[tastingRecord.reviews filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"user.identifier = %@",[GetMe sharedInstance].me.identifier]] anyObject];
    NSLog(@"%@ tried %@ and wrote %@",[GetMe sharedInstance].me.nameFull,review.wine.brand,review.reviewText);
}

@end
