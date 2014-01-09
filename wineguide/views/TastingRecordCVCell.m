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
#import "FontThemer.h"

#define MAJOR_SPACING 20
#define MINOR_SPACING 8
#define CORNER_RADIUS 4

#define SECONDS_IN_A_WEEK 604800
#define SECONDS_IN_A_DAY 86400
#define SECONDS_IN_20_MINUTES 1200

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
    NSDate *tastingRecordDate = self.tastingRecord.tastingDate;
    
    NSTimeInterval timeSinceTasting = [[NSDate date] timeIntervalSinceDate:tastingRecordDate];
    
    NSString *localDateString;
    
    if(timeSinceTasting > SECONDS_IN_A_WEEK){
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MM/dd/YY";
        localDateString = [dateFormatter stringFromDate:self.tastingRecord.tastingDate];
        
        NSRange dayZero = NSMakeRange(3, 1);
        if([[localDateString substringWithRange:dayZero] isEqualToString:@"0"]){
            localDateString = [localDateString stringByReplacingCharactersInRange:dayZero withString:@""];
        }
        if([[localDateString substringToIndex:1] isEqualToString:@"0"]){
            localDateString = [localDateString substringFromIndex:1];
        }
        
    } else if(timeSinceTasting > SECONDS_IN_A_DAY){
        int daysSinceTasting = timeSinceTasting/86400;
        localDateString = [NSString stringWithFormat:@"%@d",@(daysSinceTasting)];
        
    } else if(timeSinceTasting > SECONDS_IN_20_MINUTES){
        int hoursSinceTasting = timeSinceTasting/3600;
        localDateString = [NSString stringWithFormat:@"%@h",@(hoursSinceTasting)];
        
    } else  if(timeSinceTasting > 60){
        int minutesSinceTasting = timeSinceTasting/60;
        localDateString = [NSString stringWithFormat:@"%@m",@(minutesSinceTasting)];
        
    } else {
        localDateString = @"now";
    }
    
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:localDateString attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption2, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
}

- (float)cellHeight
{
    float cellHeight;
    
    float dateLabelHeight = self.dateLabel.bounds.size.height;
    float wineTVHeight = self.wineNameVHTV.bounds.size.height;
    float userNoteTVHeight = self.userNoteVHTV.bounds.size.height;
    float userReviewViewHeight = self.userRatingView.bounds.size.height;
    
    cellHeight = dateLabelHeight + wineTVHeight + userNoteTVHeight + userReviewViewHeight + 2*MAJOR_SPACING + 2*MINOR_SPACING;
    
    return cellHeight;
}

@end
