//
//  WineDetailsVHTV.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDetailsVHTV.h"
#import "Varietal2.h"
#import "Brand2.h"
#import "TastingNote2.h"
#import "WineUnit2.h"
#import "ColorSchemer.h"
#import "Region.h"

@implementation WineDetailsVHTV

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
    NSString *textViewString = @"";
    
    if(wine.regions){
        for(Region *region in wine.regions){
            textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@, ",[region.name capitalizedString]]];
        }
        
        if(!wine.country){
            textViewString = [textViewString substringToIndex:[textViewString length]-3];
        } else {
            textViewString = [textViewString stringByAppendingString:@"\n"];
        }
    }
    if(wine.country){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[wine.country capitalizedString]]];
    }
    if(wine.vineyard){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[wine.vineyard capitalizedString]]];
    }
    if(wine.alcohol){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@%% alcohol\n",[wine.alcohol stringValue]]];
    }
    
    NSRange tastingNoteTitleText;
    if(wine.tastingNotes){
        NSLog(@"%@",wine.tastingNotes);
        NSString *tastingNotesString = @"Tasting notes: ";
        tastingNoteTitleText = NSMakeRange([textViewString length], [tastingNotesString length]);
        NSArray *tastingNotes = [wine.tastingNotes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(TastingNote2 *tastingNote in tastingNotes){
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
    
    if(tastingNoteTitleText.length > 15){
        [self.textStorage addAttribute:NSForegroundColorAttributeName
                                 value:[ColorSchemer sharedInstance].textSecondary
                                 range:tastingNoteTitleText];
    }
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}


@end
