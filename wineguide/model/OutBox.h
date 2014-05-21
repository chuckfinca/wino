//
//  OutBox.h
//  Corkie
//
//  Created by Charles Feinn on 5/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wine2.h"
#import "TastingRecord2.h"

@interface OutBox : NSObject

-(void)userDidCellarWine:(Wine2 *)wine;
-(void)userCreatedTastingRecord:(TastingRecord2 *)tastingRecord;

@end
