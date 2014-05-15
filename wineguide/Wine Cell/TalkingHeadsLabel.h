//
//  WineCellTalkingHeadsLabel.h
//  Corkie
//
//  Created by Charles Feinn on 5/15/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkingHeadsLabel : UILabel

-(void)setupLabelWithNumberOfAdditionalPeople:(NSInteger)additionalPeople andYou:(BOOL)youLikeThis;

@end
