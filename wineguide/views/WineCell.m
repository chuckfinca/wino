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
#import "WineRatingAndReviewQuickViewVC.h"
#import "WineNameVHTV.h"


@interface WineCell ()

@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingsAndReviewsContainerView;

@property (nonatomic, strong) WineRatingAndReviewQuickViewVC *wineRatingAndReviewQuickViewVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameVhtvConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVhtvToRatingsAndReviewsContainerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingsAndReviewsContainerViewToBottomConstraint;

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

-(WineRatingAndReviewQuickViewVC *)wineRatingAndReviewQuickViewVC
{
    if(!_wineRatingAndReviewQuickViewVC){
        _wineRatingAndReviewQuickViewVC = [[WineRatingAndReviewQuickViewVC alloc] initWithNibName:@"WineRatingAndReviewQuickViewVC" bundle:nil];
        [self.ratingsAndReviewsContainerView addSubview:_wineRatingAndReviewQuickViewVC.view];
    }
    return _wineRatingAndReviewQuickViewVC;
}



#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:nil];
    
    if(!self.abridged){
        [self.wineRatingAndReviewQuickViewVC setupForWine:wine];
    } else {
        [self.ratingsAndReviewsContainerView removeFromSuperview];
    }
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToWineNameVhtvConstraint.constant;
    height += [self.wineNameVHTV height];
    height += self.wineNameVhtvToRatingsAndReviewsContainerViewConstraint.constant;
    height += self.ratingsAndReviewsContainerView.bounds.size.height;
    height += self.ratingsAndReviewsContainerViewToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}







@end
