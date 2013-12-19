//
//  WineNameVHTV.m
//  Gimme
//
//  Created by Charles Feinn on 12/13/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineNameVHTV.h"
#import "Varietal.h"
#import "Brand.h"
#import "TastingNote.h"
#import "WineUnit.h"
#import "ColorSchemer.h"

@implementation WineNameVHTV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#define V_HEIGHT 20

-(void)setupTextViewWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    NSRange vintageRange = NSMakeRange(0, 0);
    NSRange varietalRange = NSMakeRange(0, 0);
    NSRange regionRange = NSMakeRange(0, 0);
    NSRange countryRange = NSMakeRange(0, 0);
    NSRange vineyardRange = NSMakeRange(0, 0);
    NSRange restaurantRange = NSMakeRange(0, 0);
    
    if(wine.name){
        nameRange = NSMakeRange([textViewString length], [wine.name length]);
        textViewString = [textViewString stringByAppendingString:[wine.name capitalizedString]];
    }
    if(wine.vintage){
        NSString *vintageString = [wine.vintage stringValue];
        vintageRange = NSMakeRange([textViewString length], [vintageString length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[vintageString capitalizedString]]];
    }
    if(wine.varietals){
        NSString *varietalsString = @" - ";
        NSArray *varietals = [wine.varietals sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(Varietal *varietal in varietals){
            varietalsString = [varietalsString stringByAppendingString:[NSString stringWithFormat:@"%@, ",varietal.name]];
        }
        varietalsString = [varietalsString substringToIndex:[varietalsString length]-2];
        varietalRange = NSMakeRange([textViewString length]+1, [varietalsString length]);
        textViewString = [textViewString stringByAppendingString:[varietalsString capitalizedString]];
    }
    
    if(wine.region){
        regionRange = NSMakeRange([textViewString length]+1, [wine.region length]);
        textViewString = [textViewString stringByAppendingString:[wine.region capitalizedString]];
    }
    if(wine.country){
        if(wine.region){
            textViewString = [textViewString stringByAppendingString:@", "];
        } else {
            textViewString = [textViewString stringByAppendingString:@"\n"];
        }
        countryRange = NSMakeRange([textViewString length]+1, [wine.country length]);
        textViewString = [textViewString stringByAppendingString:[wine.country capitalizedString]];
    }
    if(wine.vineyard){
        vineyardRange = NSMakeRange([textViewString length]+1, [wine.vineyard length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[wine.vineyard capitalizedString]]];
    }
    if(wine.alcoholPercentage){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@%% alcohol",[wine.alcoholPercentage stringValue]]];
    }
    if(restaurant){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"restaurant.identifier = %@",restaurant.identifier];
        NSSet *wineUnits = [wine.wineUnits filteredSetUsingPredicate:predicate];
        if(wineUnits){
            
            NSString * wineUnitsString = @"\n\n";
            for(WineUnit *wineUnit in wineUnits){
                NSLog(@"wineUnit = %@",wineUnit.description);
                NSLog(@"%@",wineUnit.price);
                NSLog(@"%@",wineUnit.quantity);
                NSLog(@"%@",wineUnit.wine);
                NSLog(@"%@",wineUnit.restaurant);
                wineUnitsString = [wineUnitsString stringByAppendingString:[NSString stringWithFormat:@"$%@ %@, ",[wineUnit.price stringValue],wineUnit.quantity]];
            }
            wineUnitsString = [wineUnitsString substringToIndex:[wineUnitsString length]-2];
            textViewString = [textViewString stringByAppendingString:wineUnitsString];
            restaurantRange = NSMakeRange([textViewString length], [restaurant.name length]+3);
            textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@" @ %@",[restaurant.name capitalizedString]]];
        }
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textViewString];
    self.attributedText = attributedText;
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    [self.textStorage addAttribute:NSForegroundColorAttributeName
                             value:[ColorSchemer sharedInstance].textPrimary
                             range:NSMakeRange(0, [self.textStorage length])];
    [self.textStorage addAttribute:NSForegroundColorAttributeName
                             value:[ColorSchemer sharedInstance].textSecondary
                             range:restaurantRange];
    [self.textStorage addAttribute:NSFontAttributeName
                             value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                             range:nameRange];
    
    [self setHeightConstraintForAttributedText:self.textStorage andMinimumHeight:V_HEIGHT];
}

@end