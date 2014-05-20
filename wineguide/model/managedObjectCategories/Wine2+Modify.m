//
//  Wine2+Modify.m
//  Corkie
//
//  Created by Charles Feinn on 4/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Wine2+Modify.h"
#import "NSDictionary+Helper.h"
#import "Brand2.h"
#import "Flight2.h"
#import "Group2.h"
#import "RatingHistory2.h"
#import "WineUnit2.h"
#import "TastingNote2.h"
#import "Varietal2.h"
#import "Region.h"
#import "User2.h"
#import "TastingRecord2.h"
#import "WineList.h"

#define SERVER_IDENTIFIER @"id"
#define WINE_NAME @"wine_name"
#define WINE_VINTAGE @"wine_vintage"
#define WINE_COUNTRY @"wine_country"
#define WINE_DESCRIPTION @"wine_desc"
#define WINE_VINEYARD @"wine_vineyard"
#define WINE_CATEGORY_CODE @"wine_category_code"
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
    NSDate *serverUpdatedDate = [dictionary dateAtKey:UPDATED_AT];
    if(!self.updated_at || [self.updated_at laterDate:serverUpdatedDate] == serverUpdatedDate){
        
        if(!self.identifier || [self.identifier isEqual: @0]){
            self.identifier = [dictionary sanitizedValueForKey:SERVER_IDENTIFIER];
        }
        
        self.name = [dictionary sanitizedStringForKey:WINE_NAME];
        self.vintage = [dictionary sanitizedStringForKey:WINE_VINTAGE];
        self.country = [dictionary sanitizedStringForKey:WINE_COUNTRY];
        self.wine_description = [dictionary sanitizedStringForKey:WINE_DESCRIPTION];
        self.vineyard = [dictionary sanitizedStringForKey:WINE_VINEYARD];
        self.category_code = [dictionary sanitizedStringForKey:WINE_CATEGORY_CODE];
        self.color_code = [dictionary sanitizedValueForKey:WINE_COLOR_CODE];
        self.sparkling = [dictionary sanitizedValueForKey:WINE_SPARKLING];
        self.dessert = [dictionary sanitizedValueForKey:WINE_DESSERT];
        self.alcohol = [dictionary sanitizedValueForKey:WINE_ALCOHOL_PERCENTAGE];
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
    NSLog(@"name = %@",self.name);
    NSLog(@"vintage = %@",self.vintage);
    NSLog(@"country = %@",self.country);
    NSLog(@"wine_description = %@",self.wine_description);
    NSLog(@"vineyard = %@",self.vineyard);
    NSLog(@"category_code = %@",self.category_code);
    NSLog(@"color_code = %@",self.color_code);
    NSLog(@"sparkling = %@",self.sparkling);
    NSLog(@"dessert = %@",self.dessert);
    NSLog(@"alcohol = %@",self.alcohol);
    NSLog(@"status = %@",self.status);
    NSLog(@"created_at = %@",self.created_at);
    NSLog(@"updated_at = %@",self.updated_at);
    
    
    NSLog(@"Related objects:");
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.brand class], self.brand.identifier]);
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[self.ratingHistory class], self.ratingHistory.identifier]);
    
    for(Flight2 *flight in self.flights){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[flight class], flight.identifier]);
    }
    for(Group2 *group in self.groups){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[group class], group.identifier]);
    }
    for(Group2 *group in self.groups){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[group class], group.identifier]);
    }
    for(WineUnit2 *wineUnit in self.wineUnits){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[wineUnit class], wineUnit.identifier]);
    }
    for(TastingNote2 *tastingNote in self.tastingNotes){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[tastingNote class], tastingNote.identifier]);
    }
    for(Region *region in self.regions){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[region class], region.identifier]);
    }
    for(User2 *user in self.cellars){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[user class], user.identifier]);
    }
    for(Varietal2 *varietal in self.varietals){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[varietal class], varietal.identifier]);
    }
    for(TastingRecord2 *tastingRecord in self.tastingRecords){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[tastingRecord class], tastingRecord.identifier]);
    }
    for(WineList *wineList in self.wineLists){
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[wineList class], wineList.identifier]);
    }
}


-(NSString *)description
{
    [self logDetails];
    return @"-----------------------------------------------------";
}










@end
