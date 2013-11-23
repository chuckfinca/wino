//
//  TutorialDetailsVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialDetailsVC : UIViewController

@property (assign, nonatomic) int index;
@property (strong, nonatomic) IBOutlet UILabel *screenInstructionText;

@end
