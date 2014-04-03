//
//  ReviewView.h
//  Corkie
//
//  Created by Charles Feinn on 3/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReviewCellDelegate <NSObject>

-(void)pushUserProfileVcForReviewerNumber:(NSInteger)reviewCellTag;
-(void)pushUserReviewVcForReviewerNumber:(NSInteger)reviewCellTag;

@end

@interface ReviewCell : UITableViewCell

@property (nonatomic, weak) id <ReviewCellDelegate> delegate;

-(void)setupClaimed:(BOOL)claimed
 reviewWithUserName:(NSString *)userName
          userImage:(UIImage *)userImage
         reviewText:(NSString *)reviewText
          wineColor:(NSString *)wineColor
          andRating:(NSNumber *)rating;

@end
