//
//  InstructionsCell_FacebookConnect.h
//  Corkie
//
//  Created by Charles Feinn on 5/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBLoginView.h>

@interface InstructionsCell_FacebookConnect : UITableViewCell

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end
