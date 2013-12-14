//
//  WineDetailsVHTV.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDetailsVHTV.h"
#import "Varietal.h"
#import "Brand.h"
#import "TastingNote.h"
#import "WineUnit.h"
#import "ColorSchemer.h"

@implementation WineDetailsVHTV

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
    
    NSRange regionRange = NSMakeRange(0, 0);
    NSRange countryRange = NSMakeRange(0, 0);
    NSRange vineyardRange = NSMakeRange(0, 0);
    NSRange restaurantRange = NSMakeRange(0, 0);
    
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY restaurantIdentifier == %@",restaurant.identifier];
        NSSet *wineUnits = [wine.wineUnits filteredSetUsingPredicate:predicate];
        if(wineUnits){
            
            NSString * wineUnitsString = @"\n\n";
            for(WineUnit *wineUnit in wineUnits){
                wineUnitsString = [wineUnitsString stringByAppendingString:[NSString stringWithFormat:@"$%@ %@, ",[wineUnit.price stringValue],wineUnit.quantity]];
            }
            wineUnitsString = [wineUnitsString substringToIndex:[wineUnitsString length]-2];
            textViewString = [textViewString stringByAppendingString:wineUnitsString];
            restaurantRange = NSMakeRange([textViewString length], [restaurant.name length]+3);
            textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@" @ %@",[restaurant.name capitalizedString]]];
        }
    }
    if(wine.tastingNotes){
        NSString *tastingNotesString = @"\n\nTasting notes: ";
        NSArray *tastingNotes = [wine.tastingNotes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(TastingNote *tastingNote in tastingNotes){
            tastingNotesString = [tastingNotesString stringByAppendingString:[NSString stringWithFormat:@"%@, ",tastingNote.name]];
        }
        tastingNotesString = [tastingNotesString substringToIndex:[tastingNotesString length]-2];
        textViewString = [textViewString stringByAppendingString:tastingNotesString];
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
    
    [self setHeightConstraintForAttributedText:self.textStorage andMinimumHeight:V_HEIGHT];
    
}


@end
