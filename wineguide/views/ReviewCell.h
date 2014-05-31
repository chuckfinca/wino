//
//  ReviewView.h
//  Corkie
//
//  Created by Charles Feinn on 3/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review2.h"

@protocol ReviewCellDelegate <NSObject>

-(void)pushUserProfileVcForReviewerNumber:(NSInteger)reviewCellTag;
-(void)pushUserReviewVcForReviewerNumber:(NSInteger)reviewCellTag;

@end

@interface ReviewCell : UITableViewCell

@property (nonatomic, weak) id <ReviewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;

-(void)setupWithReview:(Review2 *)review forWineColorCode:(NSNumber *)wineColorCode;

@end
