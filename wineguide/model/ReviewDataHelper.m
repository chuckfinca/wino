//
//  ReviewDataHelper.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewDataHelper.h"
#import "Review+CreateAndModify.h"

@implementation ReviewDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    Review *r = [Review foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
    
    return r;
}


@end
