//
//  Varietal2.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wine2;

@interface Varietal2 : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * blend;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Wine2 *wines;

@end
