//
//  DisplayedRatingVC.h
//  Corkie
//
//  Created by Charles Feinn on 5/1/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingsVC : UIViewController

-(void)setupForRating:(float)rating andWineColor:(NSString *)wineColorString displayText:(BOOL)displayText;

@end