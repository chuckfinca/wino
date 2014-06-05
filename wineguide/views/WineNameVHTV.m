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
        restaurantRange = NSMakeRange([textViewString length], [restaurant.name length]+3);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n@ %@",[restaurant.name capitalizedString]]];
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
