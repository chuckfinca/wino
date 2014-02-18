//
//  RestaurantHelper.m
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RestaurantHelper.h"
#import "Restaurant+CreateAndModify.h"

@implementation RestaurantHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@", [dictionary allKeys]);
    NSPredicate *p = [self predicateForDicitonary:dictionary];
    NSLog(@"p = %@",p.description);
    Restaurant *r = [Restaurant restaurantFoundUsingPredicate:p inContext:self.context withAttributes:dictionary];
    
    NSLog(@"--%@", r);
    
    return r;
}

@end
