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

@property (weak, nonatomic) IBOutlet VariableHeightTV *restaurantVHTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *addressVHTV;

// Vertical constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRestaurantNameVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantNametoVHTVToAddressVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressVHTVToBottomConstraint;

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
        self.restaurantVHTV.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.name capitalizedString] attributes:[FontThemer sharedInstance].subHeadlineTextAttributes];
        self.restaurantVHTV.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    }
    if(restaurant.address){
        self.addressVHTV.attributedText = [[NSAttributedString alloc] initWithString:[restaurant.address capitalizedString] attributes:[FontThemer sharedInstance].secondaryFootnoteTextAttributes];
        self.addressVHTV.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    }
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToRestaurantNameVHTVConstraint.constant;
    height += [self.restaurantVHTV height];
    height += self.restaurantNametoVHTVToAddressVHTVConstraint.constant;
    height += [self.addressVHTV height];
    height += self.addressVHTVToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}















@end
