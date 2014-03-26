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
#import "VariableHeightTV.h"

#define MAJOR_SPACING 18

@interface TastingRecordTVCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet VariableHeightTV *reviewVHTV;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingContainerView;
@property (nonatomic, strong) TastingRecord *tastingRecord;
@property (nonatomic, strong) Review *review;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTvHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameTvHeightConstraint;

@end

@implementation TastingRecordTVCell

-(void)setupCellWithTastingRecord:(TastingRecord *)tastingRecord
{
    self.userRatingsController = nil;
    
    self.tastingRecord = tastingRecord;
    Review *review = tastingRecord.review;
    [self setupUserNote];
    
    [self setupDateLabel];
    [self.wineVHTV setupTextViewWithWine:review.wine fromRestaurant:review.restaurant];
    
    self.wineVHTV.backgroundColor = [UIColor orangeColor];
    self.dateLabel.backgroundColor = [UIColor greenColor];
    
    [self setupUserRatingView];
    
    self.wineNameTvHeightConstraint.constant = [self.wineVHTV height];
    self.reviewTvHeightConstraint.constant = [self.reviewVHTV height];
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
    
    self.reviewVHTV.backgroundColor = [UIColor orangeColor];
}

-(void)setupUserRatingView
{
    self.userRatingsController.wine = self.tastingRecord.review.wine;
    self.userRatingsController.collectionView.frame = self.ratingContainerView.bounds;
    [self.ratingContainerView addSubview:self.userRatingsController.collectionView];
    self.ratingContainerView.backgroundColor = [UIColor blueColor];
}

-(void)setupDateLabel
{
    NSString *localDateString = [DateStringFormatter formatStringForTimelineDate:self.tastingRecord.tastingDate];
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:localDateString attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption2, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    [self bringSubviewToFront:self.dateLabel];
}

@end
