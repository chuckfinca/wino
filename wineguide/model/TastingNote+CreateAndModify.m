//
//  TastingNote+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingNote+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "WineDataHelper.h"

@implementation TastingNote (CreateAndModify)

#define TASTING_NOTE_ENTITY @"TastingNote"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_UPDATED @"lastUpdated"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define TASTING_STAGE @"tastingStage"
#define VERSION_NUMBER @"versionNumber"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

+(TastingNote *)tastingNoteFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    TastingNote *tastingNote = nil;
    
    tastingNote = (TastingNote *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:TASTING_NOTE_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSString *wineIdentifiers;
    
    NSLog(@"self = %@",self);
    NSLog(@"lastUpdated = %@",tastingNote.lastUpdated);
    NSLog(@"dictionary[LAST_UPDATED] = %@",dictionary[LAST_UPDATED]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss Z"];
    NSDate *serverDate = [dateFormatter dateFromString:dictionary[LAST_UPDATED]];
    
    NSLog(@"serverDate = %@",serverDate);
    if(!tastingNote.lastUpdated || [tastingNote.lastUpdated laterDate:serverDate] == serverDate){
        NSLog(@"inside");
        
        // ATTRIBUTES
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            tastingNote.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            tastingNote.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            tastingNote.about = [dictionary sanitizedStringForKey:ABOUT];
            tastingNote.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            tastingNote.isPlaceholderForFutureObject = @NO;
            tastingNote.lastUpdated = [NSDate date];
            tastingNote.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            tastingNote.name = [dictionary sanitizedStringForKey:NAME];
            tastingNote.tastingStage = [dictionary sanitizedStringForKey:TASTING_STAGE]; // appearance, in glass, in mouth, finish
            tastingNote.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
            tastingNote.wineIdentifiers = [tastingNote addIdentifiers:wineIdentifiers toCurrentIdentifiers:tastingNote.wineIdentifiers];
        }
    }
    
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:tastingNote andNeededManagedObjectIdentifiersString:wineIdentifiers];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    
    //[tastingNote logDetails];
    
    return tastingNote;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"about = %@",self.about);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"tastingStage = %@",self.tastingStage);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %lu",(unsigned long)[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}






@end
