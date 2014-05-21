//
//  FacebookProfileImageGetter.h
//  Corkie
//
//  Created by Charles Feinn on 5/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User2.h"

@interface FacebookProfileImageGetter : NSObject

-(void)setProfilePicForUser:(User2 *)user inImageView:(UIImageView *)imageView completion:(void (^)(BOOL success))completion;
-(void)setProfilePicForUser:(User2 *)user inButton:(UIButton *)button completion:(void (^)(BOOL success))completion;

@end
