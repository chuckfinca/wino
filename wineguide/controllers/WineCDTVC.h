//
//  WineCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Wine.h"

@interface WineCDTVC : CoreDataTableViewController

-(void)setupWithWine:(Wine *)wine;

@end
