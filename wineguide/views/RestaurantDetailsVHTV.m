//
//  RestaurantDetailsTV.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDetailsVHTV.h"

@implementation RestaurantDetailsVHTV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define V_HEIGHT 20

-(void)setupTextViewWithRestaurant:(Restaurant *)restaurant
{
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    NSRange addressRange = NSMakeRange(0, 0);
    
    
    if(restaurant.name){
        nameRange = NSMakeRange([textViewString length], [restaurant.name length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.name capitalizedString]]];
    }
    if(restaurant.address){
        addressRange = NSMakeRange([textViewString length]+1, [restaurant.address length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.address capitalizedString]]];
    }
    if(restaurant.city){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[restaurant.city capitalizedString]]];
    }
    if(restaurant.city && restaurant.state){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@", "]];
    }
    if(restaurant.state){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[restaurant.state capitalizedString]]];
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textViewString];
    self.attributedText = attributedText;
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    [self.textStorage addAttribute:NSFontAttributeName
                                                 value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                                 range:nameRange];
    
    [self setHeightConstraintForAttributedText:attributedText andMinimumHeight:V_HEIGHT];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
