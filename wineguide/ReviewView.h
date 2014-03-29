//
//  ReviewView.h
//  Corkie
//
//  Created by Charles Feinn on 3/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewView : UIView

-(void)setupReviewWithUserName:(NSString *)userName
                     userImage:(UIImage *)userImage
                    reviewText:(NSString *)reviewText
                     wineColor:(NSString *)wineColor
                     andRating:(NSInteger)rating;

@end
