//
//  Varietal.h
//  Gimme
//
//  Created by Charles Feinn on 12/4/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wine;

@interface Varietal : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSNumber * deletedEntity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * versionNumber;
@property (nonatomic, retain) NSString * wineIdentifiers;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Varietal (CoreDataGeneratedAccessors)

- (void)addWinesObject:(Wine *)value;
- (void)removeWinesObject:(Wine *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
