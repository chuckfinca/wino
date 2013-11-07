//
//  BrandDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "BrandDataHelper.h"
#import "Brand+CreateAndModify.h"
#import "Wine.h"

@implementation BrandDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    [Brand brandForWine:(Wine *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)setRelationIdentifiersAttribute:(NSString *)string
{
    Wine *wine = (Wine *)self.parentManagedObject;
    
    // need to finish
}

@end
