//
//  TalkingHeadsVC.h
//  Corkie
//
//  Created by Charles Feinn on 5/2/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingHeads.h"

@interface TalkingHeadsVC : UIViewController

-(void)setupWithNumberOfTalkingHeads:(NSInteger)numberOfTalkingHeads andYou:(BOOL)userLikesThis withBackgroundColor:(UIColor *)backgroundColor;
-(void)setupWithTalkingHeads:(TalkingHeads *)talkingHeads andYou:(BOOL)userLikesThis withBackgroundColor:(UIColor *)backgroundColor;

@end
