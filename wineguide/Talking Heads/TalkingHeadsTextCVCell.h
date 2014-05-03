//
//  TalkingHeadsTextCVCell.h
//  Corkie
//
//  Created by Charles Feinn on 5/2/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkingHeadsTextCVCell : UICollectionViewCell

-(void)setupForNumberOfPeople:(NSInteger)numberOfPeople includingYou:(BOOL)youLikeThis;

@end
