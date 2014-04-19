//
//  Wine2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Wine2+Modify.h"
#import "NSDictionary+Helper.h"

#define SERVER_IDENTIFIER @"id"
#define WINE_NAME @"wine_name"
#define WINE_VINTAGE @"wine_vintage"
#define WINE_COUNTRY @"wine_country"
#define WINE_DESCRIPTION @"wine_region_desc"
#define WINE_VINEYARD @"wine_vineyard"
#define WINE_CLASS_CODE @"wine_class"
#define WINE_COLOR_CODE @"wine_color_code"
#define WINE_SPARKLING @"is_sparkling"
#define WINE_DESSERT @"is_dessert"
#define WINE_ALCOHOL_PERCENTAGE @"wine_alcohol_pct"
#define STATUS_CODE @"status"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"

@implementation Wine2 (Modify)

-(Wine2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"dictionary = %@",dictionary);
    if(!self.identifier || [self.identifier isEqualToNumber:@0]){
        self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
    }
    
    self.name = [dictionary sanitizedStringForKey:WINE_NAME];
    self.vintage = [dictionary sanitizedStringForKey:WINE_VINTAGE];
    self.country = [dictionary sanitizedStringForKey:WINE_COUNTRY];
    self.wine_description = [dictionary sanitizedStringForKey:WINE_DESCRIPTION];
    self.vineyard = [dictionary sanitizedStringForKey:WINE_VINEYARD];
    self.class_code = [dictionary sanitizedValueForKey:WINE_CLASS_CODE];
    self.color_code = [dictionary sanitizedValueForKey:WINE_COLOR_CODE];
    self.sparkling = [dictionary sanitizedValueForKey:WINE_SPARKLING];
    self.dessert = [dictionary sanitizedValueForKey:WINE_DESSERT];
    self.alcohol = [dictionary sanitizedValueForKey:WINE_ALCOHOL_PERCENTAGE];
    self.status = [dictionary sanitizedValueForKey:STATUS_CODE];
    self.created_at = [dictionary dateAtKey:CREATED_AT];
    self.updated_at = [dictionary dateAtKey:UPDATED_AT];
    
    [self description];
    
    return self;
}

-(void)logDetails
{
    NSLog(@"=====================================================");
    NSLog(@"%@ - %@\n",[self class],self.identifier);
    NSLog(@"name = %@",self.name);
    NSLog(@"vintage = %@",self.vintage);
    NSLog(@"country = %@",self.country);
    NSLog(@"wine_description = %@",self.wine_description);
    NSLog(@"vineyard = %@",self.vineyard);
    NSLog(@"class_code = %@",self.class_code);
    NSLog(@"color_code = %@",self.color_code);
    NSLog(@"sparkling = %@",self.sparkling);
    NSLog(@"dessert = %@",self.dessert);
    NSLog(@"alcohol = %@",self.alcohol);
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
