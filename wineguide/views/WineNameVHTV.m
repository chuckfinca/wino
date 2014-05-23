//
//  WineNameVHTV.m
//  Gimme
//
//  Created by Charles Feinn on 12/13/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineNameVHTV.h"
#import "Varietal2.h"
#import "Brand2.h"
#import "TastingNote2.h"
#import "WineUnit2.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@implementation WineNameVHTV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupTextViewWithWine:(Wine2 *)wine fromRestaurant:(Restaurant2 *)restaurant
{
    
    self.scrollEnabled = NO;
    
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    NSRange restaurantRange = NSMakeRange(0, 0);
    
    if(wine.name){
        nameRange = NSMakeRange([textViewString length], [wine.name length]);
        textViewString = [textViewString stringByAppendingString:[wine.name capitalizedString]];
    }
    if(wine.vintage){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[wine.vintage capitalizedString]]];
    }
    if(wine.varietals){
        NSString *varietalsString;
        if(wine.vintage){
            varietalsString = @" - ";
        } else {
            varietalsString = @"\n";
        }
        
        NSArray *varietals = [wine.varietals sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(Varietal2 *varietal in varietals){
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
            for(WineUnit2 *wineUnit in wineUnits){
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
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textViewString];
    self.attributedText = attributedText;
    self.font = [FontThemer sharedInstance].footnote;
    
    [self.textStorage addAttribute:NSForegroundColorAttributeName
                             value:[ColorSchemer sharedInstance].textPrimary
                             range:NSMakeRange(0, [self.textStorage length])];
    [self.textStorage addAttribute:NSFontAttributeName
                             value:[FontThemer sharedInstance].headline
                             range:nameRange];
    [self.textStorage addAttribute:NSForegroundColorAttributeName
                             value:[ColorSchemer sharedInstance].textSecondary
                             range:restaurantRange];
}

@end
