//
//  ListManagerTVC.h
//  Gimme
//
//  Created by Charles Feinn on 11/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListManagerTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *managedObjects;

-(void)refreshTableView; // Abstract
-(void)createNewManagedObjectNamed:(NSString *)newManagedObjectName; // Abstract

@end
