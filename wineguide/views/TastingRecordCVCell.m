//
//  TastingRecordView.m
//  Corkie
//
//  Created by Charles Feinn on 1/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordCVCell.h"
#import "UserRatingCVController.h"
#import "WineNameVHTV.h"
#import "VariableHeightTV.h"
#import "Review.h"
#import "ColorSchemer.h"

#define MAJOR_SPACING 20
#define MINOR_SPACING 8
#define CORNER_RADIUS 4

@interface TastingRecordCVCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *userNoteVHTV;
@property (weak, nonatomic) IBOutlet UIView *userRatingView;
@property (nonatomic, strong) UserRatingCVController *userRatingsController;
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
    [layer setShadowOpacity:0.5];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customWhite;
}

-(void)setupUserRatingView
{
    self.userRatingsController.wine = self.tastingRecord.review.wine;
    self.userRatingsController.collectionView.frame = self.userRatingView.bounds;
    [self.userRatingView addSubview:self.userRatingsController.collectionView];
}

-(void)setupDateLabel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"EEE, dd/MM/yyyy HH:mm:ss zzz"; // 
    
    NSString *localDateString = [dateFormatter stringFromDate:self.tastingRecord.tastingDate];
    self.dateLabel.text = localDateString;
}

- (float)cellHeight
{
    float cellHeight;
    
    float dateLabelHeight = self.dateLabel.bounds.size.height;
    float wineTVHeight = self.wineNameVHTV.bounds.size.height;
    float userNoteTVHeight = self.userNoteVHTV.bounds.size.height;
    float userReviewViewHeight = self.userRatingView.bounds.size.height;
    
    cellHeight = dateLabelHeight + wineTVHeight + userNoteTVHeight + userReviewViewHeight + 3*MAJOR_SPACING + 2*MINOR_SPACING;

    return cellHeight;
}

@end
