//
//  ReviewersReusableView.m
//  Gimme
//
//  Created by Charles Feinn on 12/18/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ReviewersReusableView.h"

@implementation ReviewersReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)loadUserProfile:(UIButton *)sender
{
    NSLog(@"loadUserProfile");
}

@end
