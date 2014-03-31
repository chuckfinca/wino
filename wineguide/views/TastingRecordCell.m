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
        _placeHolderImage = [[UIImage alloc] init];
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
            image = [UIImage imageWithData:review.user.profileImage];
            
            if(review.rating){
                rating += [review.rating floatValue];
                numberOfRatings++;
            }
        } else {
            image = self.placeHolderImage;
        }
        
        UIImageView *iv = self.usersImageViewArray[indexNum];
        [iv setImage:image];
        
        if(!wine && review.wine){
            wine = review.wine;
        }
    }
    
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:tastingRecord.restaurant];
    
    [self setupRating:(rating/numberOfRatings)];
    [self setWineColorFromString:wine.color];
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
