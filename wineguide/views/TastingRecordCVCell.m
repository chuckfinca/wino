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

@interface TastingRecordCVCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *userNoteVHTV;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLabel;
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
        _userRatingsController.wine = self.tastingRecord.review.wine;
    }
    return _userRatingsController;
}

-(void)setupCellWithTastingRecord:(TastingRecord *)tastingRecord
{
    self.tastingRecord = tastingRecord;
    Review *review = tastingRecord.review;
    NSLog(@"tastingRecord = %@",tastingRecord);
    NSLog(@"review = %@",review);
    
    [self setupDateLabel];
    [self.wineNameVHTV setupTextViewWithWine:review.wine fromRestaurant:review.restaurant];
    
    self.restaurantLabel.text = review.restaurant.name;
    
    [self setupUserRatingView];
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
    dateFormatter.dateFormat = @"HH:mm:ss zzz"; //EEE, dd MM yyyy 
    
    NSString *localDateString = [dateFormatter stringFromDate:self.tastingRecord.tastingDate];
    self.dateLabel.text = localDateString;
}

@end
