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

@interface TastingRecordCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingImageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *usersImageViewArray;

@property (nonatomic, strong) UIImage *placeHolderImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRatingImageViewArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingImageViewArrayToWineNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameToUserImagesConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImagesToBottomConstraint;
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

-(void)setupWithTastingRecord:(TastingRecord *)tastingRecord
{
    self.dateLabel.attributedText = [DateStringFormatter attributedStringFromDate:tastingRecord.tastingDate];
    
    
    Wine *wine;
    NSArray *reviewsArray = [tastingRecord.reviews sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"reviewDate" ascending:YES]]];
    
    float rating = 0;
    NSInteger numberOfRatings = 0;
    
    for(NSInteger indexNum = 0; indexNum < 5; indexNum++){
        UIImage *image;
        
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
            
            UIImageView *iv = self.usersImageViewArray[indexNum];
            [iv setImage:image];
            
        } else {
            UIImageView *iv = self.usersImageViewArray[indexNum];
            iv.hidden = YES;
        }
        
        if(!wine && review.wine){
            wine = review.wine;
        }
    }
    
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:tastingRecord.restaurant];
    
    [self setupRating:(rating/numberOfRatings)];
    [self setWineColorFromString:wine.color];
    
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
    height += self.wineNameToUserImagesConstraint.constant;
    
    UIImageView *userIv = [self.usersImageViewArray firstObject];
    height += userIv.bounds.size.height;
    height += self.userImagesToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

-(void)setWineColorFromString:(NSString *)wineColorString
{
    NSLog(@"color = %@",wineColorString);
    UIColor *wineColor;
    if([wineColorString isEqualToString:@"red"]){
        wineColor = [ColorSchemer sharedInstance].redWine;
    } else if([wineColorString isEqualToString:@"rose"]){
        wineColor = [ColorSchemer sharedInstance].roseWine;
    } else if([wineColorString isEqualToString:@"white"]){
        wineColor = [ColorSchemer sharedInstance].whiteWine;
    } else {
        NSLog(@"wine.color != red/rose/white");
    }
    for(UIImageView *iv in self.ratingImageViewArray){
        iv.tintColor = wineColor;
    }
}

-(void)setupRating:(NSInteger)rating
{
    for(UIImageView *iv in self.ratingImageViewArray){
        if([self.ratingImageViewArray indexOfObject:iv] > rating){
            [iv setImage:[[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if ([self.ratingImageViewArray indexOfObject:iv]+1 > rating){
            [iv setImage:[[UIImage imageNamed:@"glass_half.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else {
            [iv setImage:[[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
        [self addSubview:iv];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}









@end
