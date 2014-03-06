//
//  VariableHeightTV.m
//  Corkie
//
//  Created by Charles Feinn on 3/5/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "VariableHeightTV.h"

@implementation VariableHeightTV

-(float)height
{
    if(!self.text || [self.text length] < 1){
        return 0;
    }
    
    UITextView *tv = [[UITextView alloc] init];
    [tv setAttributedText:self.textStorage];
    NSLog(@"tv = %@",tv.text);
    CGSize size = [tv sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    NSLog(@"size.height = %f",size.height);
    NSLog(@"self.bounds.size.width = %f",self.bounds.size.width);
    return size.height;
}

@end
