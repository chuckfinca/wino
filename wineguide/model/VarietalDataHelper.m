//
//  VarietalDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "VarietalDataHelper.h"
#import "Varietal+CreateAndModify.h"
#import "Wine.h"

@implementation VarietalDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    [Varietal varietalForWine:(Wine *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


@end
