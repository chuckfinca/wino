//
//  InstructionsCell.h
//  Corkie
//
//  Created by Charles Feinn on 6/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsCell : UITableViewCell

-(void)setupInstructionsCellWithImage:(UIImage *)image text:(NSString *)text andExtraView:(UIView *)extraView;

@end
