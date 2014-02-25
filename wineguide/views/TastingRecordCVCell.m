//
//  TastingRecordView.m
//  Corkie
//
//  Created by Charles Feinn on 1/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordCVCell.h"
#import "WineNameVHTV.h"
#import "Review.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "DateStringFormatter.h"

#define MAJOR_SPACING 18
#define MINOR_SPACING 8
#define CORNER_RADIUS 4

@interface TastingRecordCVCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet UITextView *userNoteVHTV;
@property (weak, nonatomic) IBOutlet UIView *userRatingView;
@property (nonatomic, strong) TastingRecord *tastingRecord;
@property (nonatomic, strong) Review *review;
@end

@implementation TastingRecordCVCell

#pragma mark - Getters & Setters

-(UserRatingCVController *)userRatingsController
{
    if(!_userRatingsController) {
        _userRatingsController = [[UserRatingCVController alloc] initWithCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
        _userRatingsController.rating = [self.tastingRecord.review.rating intValue];
        _userRatingsController.wine = self.tastingRecord.review.wine;
    }
    return _userRatingsController;
}

-(void)setupCellWithTastingRecord:(TastingRecord *)tastingRecord
{
    self.userRatingsController = nil;
    
    self.tastingRecord = tastingRecord;
    Review *review = tastingRecord.review;
    [self setupUserNote];
    
    [self setupDateLabel];
    [self.wineNameVHTV setupTextViewWithWine:review.wine fromRestaurant:review.restaurant];
    
    [self setupUserRatingView];
    [self setupCellBackground];
}

-(void)setupCellBackground
{
    CALayer *layer = self.layer;
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setShadowColor:[ColorSchemer sharedInstance].shadowColor.CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.2];
    
    [layer setBorderColor:[ColorSchemer sharedInstance].baseColor.CGColor];
    [layer setBorderWidth:0.25];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupUserNote
{
    if(self.tastingRecord.review.reviewText){
        self.userNoteVHTV.attributedText = [[NSAttributedString alloc] initWithString:self.tastingRecord.review.reviewText attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    } else {
        self.userNoteVHTV.text = @"";
        
        // update height of userNoteTV
        [self setNeedsUpdateConstraints];
    }
}

-(void)setupUserRatingView
{
    self.userRatingsController.wine = self.tastingRecord.review.wine;
    self.userRatingsController.collectionView.frame = self.userRatingView.bounds;
    [self.userRatingView addSubview:self.userRatingsController.collectionView];
    self.userRatingView.backgroundColor = [UIColor clearColor];
}

-(void)setupDateLabel
{
    NSString *localDateString = [DateStringFormatter formatStringForDate:self.tastingRecord.tastingDate];
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:localDateString attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption2, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    [self bringSubviewToFront:self.dateLabel];
}

- (float)cellHeight
{
    float cellHeight;
    
    float dateLabelHeight = self.dateLabel.bounds.size.height;
    float wineTVHeight = self.wineNameVHTV.bounds.size.height;
    float userNoteTVHeight = self.userNoteVHTV.bounds.size.height;
    float userReviewViewHeight = self.userRatingView.bounds.size.height;
    
    cellHeight = dateLabelHeight + wineTVHeight + userReviewViewHeight + 2*MAJOR_SPACING;
    
    if(self.tastingRecord.review.reviewText){
        cellHeight += userNoteTVHeight;
    }
    
    return cellHeight;
}

@end
