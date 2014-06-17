//
//  FacebookOpenGraphObjectCreator.h
//  Corkie
//
//  Created by Charles Feinn on 6/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TastingRecord2.h"

@interface FacebookOpenGraphObjectCreator : NSObject

-(void)createObjectForTastingRecord:(TastingRecord2 *)tastingRecord;

@end
