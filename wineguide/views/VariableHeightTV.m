//
//  VariableHeightTV.m
//  guidedmind
//
//  Created by Charles Feinn on 9/10/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "VariableHeightTV.h"
@interface VariableHeightTV ()

@property (nonatomic) BOOL resetHeight;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation VariableHeightTV

-(void)awakeFromNib
{
    self.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

-(BOOL)resetHeight
{
    if(!_resetHeight) _resetHeight = YES;
    return _resetHeight;
}

-(void)setHeightConstraintForAttributedText:(NSAttributedString *)attributedText andMinimumHeight:(int)minimumHeight
{
    if([self.text length]){
        
        UITextView *tv = [[UITextView alloc] init];
        tv.attributedText = attributedText;
        
        CGSize tvSize = [tv sizeThatFits:CGSizeMake(self.bounds.size.width, 999999)];
        
        float height = tvSize.height > minimumHeight ? tvSize.height : minimumHeight;
        
        //if(height != minimumHeight) height += height/10;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        
        [self updateConstraints];
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, minimumHeight);
    }
}

-(void)updateConstraints
{
    [super updateConstraints];
    
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

}



@end
