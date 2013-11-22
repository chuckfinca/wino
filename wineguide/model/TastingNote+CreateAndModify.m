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
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define TASTING_STAGE @"tastingStage"
#define VERSION @"version"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

+(TastingNote *)tastingNoteFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    TastingNote *tastingNote = nil;
    
    tastingNote = (TastingNote *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:TASTING_NOTE_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(tastingNote){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            tastingNote.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            tastingNote.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            if([tastingNote.version intValue] == 0 || tastingNote.version < dictionary[VERSION]){
                
                // ATTRIBUTES
                
                tastingNote.about = [dictionary sanitizedStringForKey:ABOUT];
                tastingNote.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
                tastingNote.isPlaceholderForFutureObject = @NO;
                // tastingNote.lastAccessed
                tastingNote.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
                tastingNote.name = [dictionary sanitizedStringForKey:NAME];
                tastingNote.tastingStage = [dictionary sanitizedStringForKey:TASTING_STAGE]; // appearance, in glass, in mouth, finish
                tastingNote.version = [dictionary sanitizedValueForKey:VERSION];
                
                // store any information about relationships provided
                
                NSString *wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
                tastingNote.wineIdentifiers = [tastingNote addIdentifiers:wineIdentifiers toCurrentIdentifiers:tastingNote.wineIdentifiers];
                
                
                // RELATIONSHIPS
                // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
                
                // Wines
                WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:tastingNote andNeededManagedObjectIdentifiersString:wineIdentifiers];
                [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
            }
        }
    }
    
    //[tastingNote logDetails];
    
    return tastingNote;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"about = %@",self.about);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"name = %@",self.name);
    NSLog(@"tastingStage = %@",self.tastingStage);
    NSLog(@"version = %@",self.version);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %i",[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}






@end
