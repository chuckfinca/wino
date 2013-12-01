//
//  ListManagerTVC.h
//  Gimme
//
//  Created by Charles Feinn on 11/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef enum {
    DeleteEntity,
    AddEntity,
} ActionSheetType;

@interface ListManagerTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *managedObjects;

@property (weak, nonatomic) IBOutlet UITextField *textField;

-(void)refreshTableView; // Abstract

-(void)showRemoveActionSheetItem:(NSString *)itemName; // Abstract
-(void)showAddActionSheet; // Abstract

-(void)createNewManagedObjectNamed:(NSString *)newManagedObjectName; // Abstract
-(void)deleteFromListManagedObject:(NSManagedObject *)managedObject; // Abstract

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender; // Abstract but call super to dismiss keyboard if necessary

@end
