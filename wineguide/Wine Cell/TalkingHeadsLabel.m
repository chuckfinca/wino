//
//  WineCellTalkingHeadsLabel.m
//  Corkie
//
//  Created by Charles Feinn on 5/15/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TalkingHeadsLabel.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@implementation TalkingHeadsLabel


-(void)setupLabelWithNumberOfAdditionalPeople:(NSInteger)additionalPeople andYou:(BOOL)youLikeThis
{
    if(additionalPeople > 0 || youLikeThis){
        NSString *text = @"";
        
        if(youLikeThis){
            switch (additionalPeople) {
                case 0:
                    text = @"+ you like this";
                    break;
                case 1:
                    text = @"+ you & 1 friend likes this";
                    break;
                default:
                    text = [NSString stringWithFormat:@"+ you & %ld friends like this",(long)additionalPeople];
                    break;
            }
        } else {
            switch (additionalPeople) {
                case 0:
                    text = @"";
                    break;
                case 1:
                    text = @"+ 1 friend likes this";
                    break;
                default:
                    text = [NSString stringWithFormat:@"+ %ld friends like this",(long)additionalPeople];
                    break;
            }
        }
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].footnote, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
        
        if(youLikeThis){
            [mutableAttributedString addAttributes:@{NSStrokeWidthAttributeName : @-3, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].baseColor} range:NSMakeRange(2, 3)];
        }
        
        self.attributedText = mutableAttributedString;
    }
    
}













@end
