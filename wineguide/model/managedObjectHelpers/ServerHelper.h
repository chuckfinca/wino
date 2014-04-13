//
//  serverHelper.h
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define IDENTIFIER @"identifier"

@interface ServerHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;

-(void)getDataAtUrl:(NSString *)url;

-(NSManagedObject *)findOrCreateManagedObjectEntityType:(NSString *)entityName
                                          andIdentifier:(NSString *)identifier;
-(void)createAndUpdateObjectsWithJsonInArray:(NSArray *)jsonArray;

@end
