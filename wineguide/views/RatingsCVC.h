//
//  RatingsReusableView.h
//  Gimme
//
//  Created by Charles Feinn on 12/18/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingsCVC : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *glassImageView;
@property (nonatomic) BOOL isRedWine;

-(void)setupImageViewForGlassNumber:(NSInteger)glassNumber andRating:(float)rating;
-(void)resetCell;

@end
