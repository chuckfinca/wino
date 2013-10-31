//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+Create.h"

@interface RestaurantDataHelper ()

@property (nonatomic, weak) NSManagedObjectContext *context;

@end


@implementation RestaurantDataHelper

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    _context = context;
    return self;
}

-(void)prepareJSONatURL:(NSURL *)url
{
    NSLog(@"prepareJSON...");
    dispatch_queue_t jsonQueue = dispatch_queue_create("JSON_Queue", NULL);
    dispatch_async(jsonQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateRestaurantsFromJSONDictionary:json];
        });
    });
}



-(void)updateRestaurantsFromJSONDictionary:(NSDictionary *)dictionary
{
    if(self.context){
        for(NSDictionary *restaurantInfo in dictionary){
            NSLog(@"resaurantInfo = %@",restaurantInfo);
            [Restaurant restaurantWithInfo:restaurantInfo inContext:self.context];
        }
    } else {
        NSLog(@"context = nil");
    }
}







@end
