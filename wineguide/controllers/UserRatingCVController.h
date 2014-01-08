//
//  UserRatingCVController.h
//  Corkie
//
//  Created by Charles Feinn on 12/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"

@interface UserRatingCVController : UICollectionViewController

@property (nonatomic, strong) Wine *wine;
@property (nonatomic) int rating;
@property (nonatomic) BOOL userCanEdit;

@end
