//
//  FacebookSessionManager.h
//  Corkie
//
//  Created by Charles Feinn on 3/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookSessionManager : NSObject

+(FacebookSessionManager *)sharedInstance;

@property (nonatomic) BOOL sessionActive;

-(void)checkToken;
-(void)getUserInfo;
-(void)handleError:(NSError *)error;
-(void)getFacebookInfoAtGraphPath:(NSString *)path;

@end
