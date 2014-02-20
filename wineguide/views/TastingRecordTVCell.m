//
//  TastingRecordTVCell.m
//  Corkie
//
//  Created by Charles Feinn on 2/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordTVCell.h"
#import "WineNameVHTV.h"
#import "Review.h"
#import "FontThemer.h"
#import "ColorSchemer.h"
#import "DateStringFormatter.h"

#define MAJOR_SPACING 18

@interface TastingRecordTVCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet VariableHeightTV *reviewVHTV;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingContainerView;
@property (nonatomic, strong) TastingRecord *tastingRecord;
@property (nonatomic, strong) Review *review;


// vertical spacing constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToDateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToReviewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewToWineConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineToRatingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingToBottomConstraint;

@end

@implementation TastingRecordTVCell


-(void)updateConstraints
{
    if(!self.tastingRecord.review.reviewText){
        NSLayoutConstraint *c = [self.reviewVHTV.constraints firstObject];
        
        // set view height to zero
        c.constant = 0;
    }
    [super updateConstraints];
}

-(void)setupCellWithTastingRecord:(TastingRecord *)tastingRecord
{
    self.userRatingsController = nil;
    
    self.tastingRecord = tastingRecord;
    Review *review = tastingRecord.review;
    [self setupUserNote];
    
    [self setupDateLabel];
    [self.wineVHTV setupTextViewWithWine:review.wine fromRestaurant:review.restaurant];
    
    [self setupUserRatingView];
    
    [self setViewHeight];
}

-(void)setViewHeight
{
    // scrolling appears to need to be disabled inorder for constraints to be setup correctly. Seems to be a bug.
    self.reviewVHTV.scrollEnabled = NO;
    [self.reviewVHTV setHeight];
    
    CGFloat height = 0;
    
    height += self.dateLabel.bounds.size.height;
    height += self.reviewVHTV.bounds.size.height;
    height += self.wineVHTV.bounds.size.height;
    height += self.ratingContainerView.bounds.size.height;
    height += self.topToDateConstraint.constant;
    height += self.dateToReviewConstraint.constant;
    height += self.reviewToWineConstraint.constant;
    height += self.wineToRatingConstraint.constant;
    height += self.ratingToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

-(void)setupUserNote
{
    if(self.tastingRecord.review.reviewText){
        self.reviewVHTV.attributedText = [[NSAttributedString alloc] initWithString:self.tastingRecord.review.reviewText attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    } else {
        self.reviewVHTV.text = @"";
        
        // update height of userNoteTV
        [self setNeedsUpdateConstraints];
    }
}

-(void)setupUserRatingView
{
    self.userRatingsController.wine = self.tastingRecord.review.wine;
    self.userRatingsController.collectionView.frame = self.ratingContainerView.bounds;
    [self.ratingContainerView addSubview:self.userRatingsController.collectionView];
    self.ratingContainerView.backgroundColor = [UIColor clearColor];
}

-(void)setupDateLabel
{
    NSString *localDateString = [DateStringFormatter formatStringForDate:self.tastingRecord.tastingDate];
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:localDateString attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption2, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    [self bringSubviewToFront:self.dateLabel];
}

-(float)cellHeight
{
    float cellHeight;
    
    float dateLabelHeight = self.dateLabel.bounds.size.height;
    float wineTVHeight = self.wineVHTV.bounds.size.height;
    float userNoteTVHeight = self.reviewVHTV.bounds.size.height;
    float userReviewViewHeight = self.ratingContainerView.bounds.size.height;
    
    cellHeight = dateLabelHeight + wineTVHeight + userReviewViewHeight + 2*MAJOR_SPACING;
    
    if(self.tastingRecord.review.reviewText){
        cellHeight += userNoteTVHeight;
    }
    
    return cellHeight;
}

@end
