//
//  ServerCaller.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ServerCaller.h"
#import "RestaurantDataHelper.h"
#import "RestaurantHelper.h"
#import "DocumentHandler2.h"

@interface ServerCaller ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ServerCaller

#pragma mark - Getters & setters

-(NSManagedObjectContext *)context
{
    if(!_context){
        _context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
    }
    return _context;
}

-(void)getRestaurantsNearLatitude:(double)latitude longitude:(double)longitude
{
    // call Corkie server and get restaurant json
    RestaurantHelper *restaurantHelper = [[RestaurantHelper alloc] init];
    [restaurantHelper getDataAtUrl:@"http://www.corkieapp.com/nearMe/1/1"];
}

@end
