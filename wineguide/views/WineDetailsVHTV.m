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


#define V_WIDTH 20

-(void)setupTextViewWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    NSString *textViewString = @"";
    
    if(wine.region){
        textViewString = [textViewString stringByAppendingString:[wine.region capitalizedString]];
        if(wine.country){
            textViewString = [textViewString stringByAppendingString:@", "];
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
    if(wine.alcoholPercentage){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@%% alcohol\n",[wine.alcoholPercentage stringValue]]];
    }
    
    NSRange tastingNoteTitleText;
    if(wine.tastingNotes){
        NSLog(@"%@",wine.tastingNotes);
        NSString *tastingNotesString = @"Tasting notes: ";
        tastingNoteTitleText = NSMakeRange([textViewString length], [tastingNotesString length]);
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
    
    if(tastingNoteTitleText.length > 15){
        [self.textStorage addAttribute:NSForegroundColorAttributeName
                                 value:[ColorSchemer sharedInstance].textSecondary
                                 range:tastingNoteTitleText];
    }
    
    
    [self setHeightConstraintForAttributedText:self.textStorage andWidth:self.bounds.size.width];
    
}


@end
