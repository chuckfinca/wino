//
//  TastingRecordCell.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordCell.h"
#import "WineNameVHTV.h"
#import "FontThemer.h"
#import "ColorSchemer.h"
#import "DateStringFormatter.h"
#import "Review2.h"
#import "User2.h"
#import "RatingPreparer.h"

@interface TastingRecordCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingImageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRatingImageViewArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingImageViewArrayToWineNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameToUserImageButtonsConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageButtonsToBottomConstraint;
@end


@implementation TastingRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    for(UIButton *userImageButton in self.userImageButtonArray){
        userImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

-(void)setupWithTastingRecord:(TastingRecord2 *)tastingRecord andDisplayWineName:(BOOL)displayWineName
{
    self.dateLabel.attributedText = [DateStringFormatter attributedStringFromDate:tastingRecord.tasting_date];
    
    if(displayWineName){
        [self.wineNameVHTV setupTextViewWithWine:tastingRecord.wine fromRestaurant:tastingRecord.restaurant];
    } else {
        self.wineNameVHTV.text = nil;
    }
    
    [self setupRatingForTastingRecord:tastingRecord];
    
    [self setHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupRatingForTastingRecord:(TastingRecord2 *)tastingRecord
{
    __block float averageRatingForTastingRecord = 0;
    __block NSInteger numberOfReviews = 0;
    [tastingRecord.reviews enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        Review2 *review = (Review2 *)obj;
        if(review.rating){
            averageRatingForTastingRecord += [review.rating floatValue];
            numberOfReviews++;
        }
    }];
    
    [RatingPreparer setupRating:(averageRatingForTastingRecord/numberOfReviews) inImageViewArray:self.ratingImageViewArray withWineColor:tastingRecord.wine.color_code];
}

-(void)setHeight
{
    float height = 0;
    
    height += self.topToRatingImageViewArrayConstraint.constant;
    
    UIImageView *ratingIv = [self.ratingImageViewArray firstObject];
    height += ratingIv.bounds.size.height;
    height += self.ratingImageViewArrayToWineNameConstraint.constant;
    height += [self.wineNameVHTV height];
    height += self.wineNameToUserImageButtonsConstraint.constant;
    
    UIButton *button = [self.userImageButtonArray firstObject];
    height += button.bounds.size.height;
    height += self.userImageButtonsToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}





@end
