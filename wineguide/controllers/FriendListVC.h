//
//  FriendListVC.h
//  Corkie
//
//  Created by Charles Feinn on 3/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendListVcDelegate

-(void)checkIn;
-(void)backFromVC:(UIViewController *)dismissed;

@end

@interface FriendListVC : UIViewController

@property (nonatomic, weak) id <FriendListVcDelegate> delegate;

@end
