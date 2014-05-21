//
//  GetMe.h
//  Corkie
//
//  Created by Charles Feinn on 4/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User2.h"

@interface GetMe : NSObject

+(GetMe *)sharedInstance;

@property (nonatomic, strong) User2 *me;

@end
