//
//  TastingNote2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingNote2+Modify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

#define TASTING_NOTE_ABOUT @"tasting_note_desc"
#define TASTING_NOTE_NAME @"tasting_note_name"
#define TASTING_NOTE_TASTING_STAGE @"tasting_stage"

@implementation TastingNote2 (Modify)

-(TastingNote2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqualToNumber:@0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.about = [dictionary sanitizedValueForKey:TASTING_NOTE_ABOUT];
        self.name = [dictionary sanitizedValueForKey:TASTING_NOTE_NAME];
        self.tasting_stage = [dictionary sanitizedValueForKey:TASTING_NOTE_TASTING_STAGE];
        self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
        self.created_at = [dictionary dateAtKey:CREATED_AT];
        self.updated_at = serverUpdatedDate;
        
        [self logDetails];
    }
    return self;
}


-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"%@ - %@\n",[self class],self.identifier);
    NSLog(@"about = %@",self.about);
    NSLog(@"name = %@",self.name);
    NSLog(@"tasting_stage = %@",self.tasting_stage);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
}

-(NSString *)description
{
    [self logDetails];
    return [NSString stringWithFormat:@"%@ - %@",[self class],self.identifier];
}










@end






