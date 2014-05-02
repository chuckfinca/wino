//
//  WineCell.m
//  Gimme
//
//  Created by Charles Feinn on 12/3/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineCell.h"
#import "ColorSchemer.h"
#import "Wine.h"
#import "Varietal.h"
#import "TastingNote.h"
#import "WineNameVHTV.h"
#import "Rating.h"
#import "RatingsVC.h"


@interface WineCell ()

@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingsContainerView;

@property (nonatomic, strong) RatingsVC *ratingsCVController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameVhtvConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVhtvToRatingsContainerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingsContainerViewToBottomConstraint;

@end
@implementation WineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Getters & setters

-(RatingsVC *)ratingsCVController
{
    if(!_ratingsCVController){
        _ratingsCVController = [[RatingsVC alloc] initWithNibName:@"RatingsVC" bundle:nil];
        [self.ratingsContainerView addSubview:_ratingsCVController.view];
    }
    return _ratingsCVController;
}



#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:nil];
    
    if(!self.abridged){
        [self.ratingsCVController setupForRating:[wine.rating.averageRating floatValue] andWineColor:wine.color displayText:YES];
    } else {
        [self.ratingsContainerView removeFromSuperview];
    }
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToWineNameVhtvConstraint.constant;
    height += [self.wineNameVHTV height];
    height += self.wineNameVhtvToRatingsContainerViewConstraint.constant;
    height += self.ratingsContainerView.bounds.size.height;
    height += self.ratingsContainerViewToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}







@end
