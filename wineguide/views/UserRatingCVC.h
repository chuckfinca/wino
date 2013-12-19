//
//  UserRatingReusableView.h
//  Corkie
//
//  Created by Charles Feinn on 12/19/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserRatingCVC : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;

-(void)glassIsEmpty:(BOOL)glassIsEmpty;

@end
