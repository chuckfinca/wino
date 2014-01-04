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
#define LAST_SERVER_UPDATE @"lastServerUpdate"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define TASTING_STAGE @"tastingStage"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

+(TastingNote *)tastingNoteFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    TastingNote *tastingNote = nil;
    
    tastingNote = (TastingNote *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:TASTING_NOTE_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [tastingNote lastUpdatedDateFromDictionary:dictionary];
    
    if(!tastingNote.lastServerUpdate || [tastingNote.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == NO){
            
            // ATTRIBUTES
            tastingNote.about = [dictionary sanitizedStringForKey:ABOUT];
            tastingNote.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            tastingNote.isPlaceholderForFutureObject = @NO;
            tastingNote.lastServerUpdate = dictionaryLastUpdatedDate;
            tastingNote.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            tastingNote.name = [dictionary sanitizedStringForKey:NAME];
            tastingNote.tastingStage = [dictionary sanitizedStringForKey:TASTING_STAGE]; // appearance, in glass, in mouth, finish
            
            // store any information about relationships provided
            
            NSString *wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
            tastingNote.wineIdentifiers = [tastingNote addIdentifiers:wineIdentifiers toCurrentIdentifiers:tastingNote.wineIdentifiers];
            if(wineIdentifiers) [identifiers setObject:wineIdentifiers forKey:WINE_IDENTIFIERS];
            
            
            [tastingNote updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
            
        } else {
            // Create placeholder object
            tastingNote.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
            tastingNote.isPlaceholderForFutureObject = @YES;
        }
        
    } else if([tastingNote.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [tastingNote updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    //[tastingNote logDetails];
    
    return tastingNote;
}



-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_IDENTIFIERS]];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"about = %@",self.about);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"tastingStage = %@",self.tastingStage);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %lu",(unsigned long)[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}






@end
