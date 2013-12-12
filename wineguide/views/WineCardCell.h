//
//  WineCardCell.h
//  Gimme
//
//  Created by Charles Feinn on 12/11/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"

@interface WineCardCell : UICollectionViewCell

-(void)setupCardWithWine:(Wine *)wine;

@end
