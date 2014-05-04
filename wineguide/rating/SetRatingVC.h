//
//  RatingVC.h
//  Corkie
//
//  Created by Charles Feinn on 4/25/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, COWineColor) {
    COWineColorRed     = 0,
    COWineColorWhite   = 1,
    COWineColorRose    = 2
};

@interface SetRatingVC : UIViewController

@property (nonatomic) NSInteger rating;
-(void)setWineColor:(COWineColor)wineColor;

@end
