//
//  WineNameLabel.m
//  Corkie
//
//  Created by Charles Feinn on 5/15/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineNameLabel.h"
#import "Varietal.h"
#import "WineUnit.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@implementation WineNameLabel

-(void)setupForWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    NSRange restaurantRange = NSMakeRange(0, 0);
    
    if(wine.name){
        nameRange = NSMakeRange([textViewString length], [wine.name length]);
        textViewString = [textViewString stringByAppendingString:[wine.name capitalizedString]];
    }
    if(wine.vintage){
        NSString *vintageString = [wine.vintage stringValue];
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[vintageString capitalizedString]]];
    }
    if(wine.varietals){
        NSString *varietalsString = @" - ";
        NSArray *varietals = [wine.varietals sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(Varietal *varietal in varietals){
            varietalsString = [varietalsString stringByAppendingString:[NSString stringWithFormat:@"%@, ",varietal.name]];
        }
        varietalsString = [varietalsString substringToIndex:[varietalsString length]-2];
        textViewString = [textViewString stringByAppendingString:[varietalsString capitalizedString]];
    }
    
    if(restaurant){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"restaurant.identifier = %@",restaurant.identifier];
        NSSet *wineUnits = [wine.wineUnits filteredSetUsingPredicate:predicate];
        if([wineUnits count] > 0){
            
            NSString *wineUnitsString = @"\n";
            for(WineUnit *wineUnit in wineUnits){
                if(wineUnit.price && wineUnit.quantity){
                    wineUnitsString = [wineUnitsString stringByAppendingString:[NSString stringWithFormat:@"$%@ %@, ",[wineUnit.price stringValue],wineUnit.quantity]];
                }
            }
            if([wineUnitsString length] > 1){
                wineUnitsString = [wineUnitsString substringToIndex:[wineUnitsString length]-2];
            }
            textViewString = [textViewString stringByAppendingString:wineUnitsString];
            
            if(restaurant){
                restaurantRange = NSMakeRange([textViewString length], [restaurant.name length]+2);
                textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"@ %@",[restaurant.name capitalizedString]]];
            }
        }
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textViewString attributes:[FontThemer sharedInstance].primaryFootnoteTextAttributes];
    [attributedText addAttribute:NSFontAttributeName value:[FontThemer sharedInstance].headline range:nameRange];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[ColorSchemer sharedInstance].textSecondary range:restaurantRange];
    
    self.attributedText = attributedText;
}








@end
