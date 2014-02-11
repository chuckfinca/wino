//
//  UserActionCVC.h
//  Corkie
//
//  Created by Charles Feinn on 12/20/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"

@interface UserActionCVC : UICollectionViewCell

-(void)setupCellForWine:(Wine *)wine atIndex:(NSInteger)index;

@end
