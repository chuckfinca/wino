//
//  VariableHeightTV.m
//  Corkie
//
//  Created by Charles Feinn on 3/5/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "VariableHeightTV.h"
#import "ColorSchemer.h"

@implementation VariableHeightTV

-(void)awakeFromNib
{
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(float)height
{
    if(!self.text || [self.text length] < 1){
        return 0;
    }
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    return size.height+5;
}

@end
