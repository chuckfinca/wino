//
//  VariableHeightTV.h
//  guidedmind
//
//  Created by Charles Feinn on 9/10/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariableHeightTV : UITextView

@property (nonatomic) float minimumHeight;

-(void)setHeight;

@end
