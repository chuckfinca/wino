//
//  VariableHeightTV.m
//  guidedmind
//
//  Created by Charles Feinn on 9/10/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//
#import "VariableHeightTV.h"

#define MIN_HEIGHT 70

@interface VariableHeightTV ()

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;


@end

@implementation VariableHeightTV

-(void)setHeight
{
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
}

-(void)updateConstraints
{
    [self removeConstraint:self.heightConstraint];
    self.heightConstraint = nil;
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:self.frame.size.height];
    [self addConstraint:self.heightConstraint];
    
    [super updateConstraints];
}



@end
