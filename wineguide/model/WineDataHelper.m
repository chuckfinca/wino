//
//  WineDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDataHelper.h"
#import "Wine+CreateAndModify.h"

@implementation WineDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    [Wine wineFromRestaurant:self.restaurant withInfo:dictionary inContext:context];
}

@end
