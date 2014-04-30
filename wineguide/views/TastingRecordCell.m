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
#import "Review.h"
#import "User.h"
#import "RatingPreparer.h"

@interface TastingRecordCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingImageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;

@property (nonatomic, strong) UIImage *placeHolderImage;

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
}

-(UIImage *)placeHolderImage
{
    if(!_placeHolderImage){
        _placeHolderImage = [[UIImage imageNamed:@"user_default.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _placeHolderImage;
}

-(void)setupWithTastingRecord:(TastingRecord *)tastingRecord andDisplayWineName:(BOOL)displayWineName
{
    self.dateLabel.attributedText = [DateStringFormatter attributedStringFromDate:tastingRecord.tastingDate];
    
    
    Wine *wine;
    NSArray *reviewsArray = [tastingRecord.reviews sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"reviewDate" ascending:YES]]];
    
    float rating = 0;
    NSInteger numberOfRatings = 0;
    
    for(NSInteger indexNum = 0; indexNum < 5; indexNum++){
        UIImage *image;
        
        UIButton *button;
        Review *review;
        
        if(indexNum < [reviewsArray count]){
            review = reviewsArray[indexNum];
            
            if(review.user.profileImage){
                image = [UIImage imageWithData:review.user.profileImage];
            } else {
                image = self.placeHolderImage;
            }
            
            if(review.rating){
                rating += [review.rating floatValue];
                numberOfRatings++;
            }
            
            button = self.userImageButtonArray[indexNum];
            button.hidden = NO;
            [button setImage:image forState:UIControlStateNormal];
            
        } else {
            button = self.userImageButtonArray[indexNum];
            button.hidden = YES;
        }
        
        if(!wine && review.wine){
            wine = review.wine;
        }
    }
    
    if(displayWineName){
        [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:tastingRecord.restaurant];
    } else {
        self.wineNameVHTV.text = nil;
    }
    
    [RatingPreparer setupRating:(rating/numberOfRatings) inImageViewArray:self.ratingImageViewArray withWineColorString:wine.color];
    
    [self setHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)pushUserProfileVC:(UIButton *)sender
{
    NSLog(@"tag = %i",sender.tag);
}








@end
