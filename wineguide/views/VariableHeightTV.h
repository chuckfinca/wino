//
//  VariableHeightTV.h
//  guidedmind
//
//  Created by Charles Feinn on 9/10/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariableHeightTV : UITextView

-(void)setHeightConstraintForAttributedText:(NSAttributedString *)attributedText andMinimumHeight:(int)minimumHeight;

@end
