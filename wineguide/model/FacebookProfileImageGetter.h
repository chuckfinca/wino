//
//  FacebookProfileImageGetter.h
//  Corkie
//
//  Created by Charles Feinn on 5/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface FacebookProfileImageGetter : NSObject

-(void)setProfilePicForUser:(User *)user inImageView:(UIImageView *)imageView completion:(void (^)(BOOL success))completion;

@end
