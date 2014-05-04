//
//  OutBox.m
//  Corkie
//
//  Created by Charles Feinn on 5/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "OutBox.h"
#import "GetMe.h"

@implementation OutBox


-(void)userDidCellarWine:(Wine *)wine
{
    NSLog(@"%@ put %@ in their cellar",[GetMe sharedInstance].me.nameFull,wine.brand);
}

@end
