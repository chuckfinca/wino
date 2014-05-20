//
//  RestaurantDetailsTV.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDetailsVHTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@implementation RestaurantDetailsVHTV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupTextViewWithRestaurant:(Restaurant2 *)restaurant
{
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    
    
    if(restaurant.name){
        nameRange = NSMakeRange([textViewString length], [restaurant.name length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.name capitalizedString]]];
    }
    if(restaurant.street_1){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.street_1 capitalizedString]]];
    }
    if(restaurant.street_2){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.street_2 capitalizedString]]];
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
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textViewString attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    self.attributedText = attributedText;
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowColor = [UIColor whiteColor];
    
    [self.textStorage addAttribute:NSShadowAttributeName
                             value:shadow
                             range:NSMakeRange(0, [self.textStorage length])];
    
    [self.textStorage addAttribute:NSFontAttributeName
                             value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                             range:nameRange];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
