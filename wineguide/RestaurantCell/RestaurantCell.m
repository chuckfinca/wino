//
//  RestaurantCell.m
//  Corkie
//
//  Created by Charles Feinn on 5/10/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RestaurantCell.h"
#import "VariableHeightTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@interface RestaurantCell ()

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;

// Vertical constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRestaurantNameLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantNameLabelToRestaurantAddressLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantAddressLabelToBottomConstraint;

@end

@implementation RestaurantCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellForRestaurant:(Restaurant *)restaurant
{
    if(restaurant.name){
        self.restaurantNameLabel.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.name capitalizedString] attributes:[FontThemer sharedInstance].primarySubHeadlineTextAttributes];
    }
    if(restaurant.address){
        self.restaurantAddressLabel.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.address capitalizedString] attributes:[FontThemer sharedInstance].secondaryFootnoteTextAttributes];
    }
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToRestaurantNameLabelConstraint.constant;
    height += self.restaurantNameLabel.bounds.size.height;
    height += self.restaurantNameLabelToRestaurantAddressLabelConstraint.constant;
    height += self.restaurantAddressLabel.bounds.size.height;
    height += self.restaurantAddressLabelToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}















@end
