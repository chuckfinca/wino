//
//  TastingRecordDataHelper.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordDataHelper.h"
#import "TastingRecord+CreateAndModify.h"

@implementation TastingRecordDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    TastingRecord *tr = [TastingRecord foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
    
    return tr;
}

@end
