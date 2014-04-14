//
//  ServerCaller.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ServerCommunicator.h"
#import "RestaurantDataHelper.h"
#import "RestaurantHelper.h"
#import "DocumentHandler2.h"
#import "WineHelper.h"
#import "GroupHelper.h"

@interface ServerCommunicator ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ServerCommunicator

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

-(void)getAllWinesFromRestaurantIdentifier:(NSInteger)restaurantIdentifier
{
    GroupHelper *gh = [[GroupHelper alloc] init];
    [gh getDataAtUrl:[NSString stringWithFormat:@"http://wappbeta.herokuapp.com/getWineList/%ld",(long)restaurantIdentifier]];
    NSLog(@"%@",[NSString stringWithFormat:@"http://wappbeta.herokuapp.com/getWineList/%ld",(long)restaurantIdentifier]);
}

@end
