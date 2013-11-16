//
//  Wine.h
//  wineguide
//
//  Created by Charles Feinn on 11/16/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand, TastingNote, Varietal, WineUnit;

@interface Wine : NSManagedObject

@property (nonatomic, retain) NSNumber * alcoholPercentage;
@property (nonatomic, retain) NSString * brandIdentifier;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * dessert;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastAccessed;
@property (nonatomic, retain) NSNumber * markForDeletion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSNumber * sparkling;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * tastingNoteIdentifers;
@property (nonatomic, retain) NSString * varietalIdentifiers;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * vineyard;
@property (nonatomic, retain) NSNumber * vintage;
@property (nonatomic, retain) NSString * wineUnitIdentifiers;
@property (nonatomic, retain) NSNumber * isPlaceholderForFutureObject;
@property (nonatomic, retain) Brand *brand;
@property (nonatomic, retain) NSSet *tastingNotes;
@property (nonatomic, retain) NSSet *varietals;
@property (nonatomic, retain) NSSet *wineUnits;
@end

@interface Wine (CoreDataGeneratedAccessors)

- (void)addTastingNotesObject:(TastingNote *)value;
- (void)removeTastingNotesObject:(TastingNote *)value;
- (void)addTastingNotes:(NSSet *)values;
- (void)removeTastingNotes:(NSSet *)values;

- (void)addVarietalsObject:(Varietal *)value;
- (void)removeVarietalsObject:(Varietal *)value;
- (void)addVarietals:(NSSet *)values;
- (void)removeVarietals:(NSSet *)values;

- (void)addWineUnitsObject:(WineUnit *)value;
- (void)removeWineUnitsObject:(WineUnit *)value;
- (void)addWineUnits:(NSSet *)values;
- (void)removeWineUnits:(NSSet *)values;

@end
