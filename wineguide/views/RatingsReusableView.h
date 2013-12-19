//
//  RatingsReusableView.h
//  Gimme
//
//  Created by Charles Feinn on 12/18/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingsReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *glassImageView;

-(void)setupImageViewForGlassNumber:(int)glassNumber andRating:(float)rating;

@end