//
//  RestaurantDetailsTV.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDetailsVHTV.h"
#import "ColorSchemer.h"

@implementation RestaurantDetailsVHTV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupTextViewWithRestaurant:(Restaurant *)restaurant
{
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    
    
    if(restaurant.name){
        nameRange = NSMakeRange([textViewString length], [restaurant.name length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.name capitalizedString]]];
    }
    if(restaurant.address){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.address capitalizedString]]];
    }
    if(restaurant.city){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[restaurant.city capitalizedString]]];
    }
    if(restaurant.city && restaurant.state){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@", "]];
    }
    if(restaurant.state){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.state capitalizedString]]];
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textViewString];
    self.attributedText = attributedText;
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    [self.textStorage addAttribute:NSForegroundColorAttributeName
                             value:[ColorSchemer sharedInstance].textPrimary
                             range:NSMakeRange(0, [self.textStorage length])];
    [self.textStorage addAttribute:NSFontAttributeName
                                                 value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                                 range:nameRange];
}

@end
