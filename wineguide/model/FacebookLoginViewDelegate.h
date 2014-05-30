//
//  FacebookLoginViewDelegate.h
//  Corkie
//
//  Created by Charles Feinn on 5/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBLoginView.h>

@protocol FacebookLoginViewDelegateDelegate <NSObject>

-(void)updateBasicInformation;

@end

@interface FacebookLoginViewDelegate : NSObject <FBLoginViewDelegate>

@property (nonatomic, weak) id <FacebookLoginViewDelegateDelegate> delegate;

@end
