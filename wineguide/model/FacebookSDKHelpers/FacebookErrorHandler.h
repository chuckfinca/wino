//
//  FacebookErrorHandler.h
//  Corkie
//
//  Created by Charles Feinn on 6/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookErrorHandler : NSObject

+(FacebookErrorHandler *)sharedInstance;

-(void)handleError:(NSError *)error;

@end
