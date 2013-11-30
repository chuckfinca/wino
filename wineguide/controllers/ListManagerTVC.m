//
//  ListManagerTVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ListManagerTVC.h"
#import <CoreData/CoreData.h>
#import "DocumentHandler.h"

typedef enum {
    DeleteEntity,
    AddEntity,
} ActionSheetType;

@interface ListManagerTVC () <UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, weak) NSManagedObject *managedObjectToDelete;

@end

@implementation ListManagerTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getManagedObjectContext];
}

-(void)refreshTableView
{
    // Abstract
}

-(void)getManagedObjectContext
{
    if([DocumentHandler sharedDocumentHandler].document){
        self.context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
    } else {
        NSLog(@"RestaurantManagerSCDTVC - [DocumentHandler sharedDocumentHandler].document does not exist");
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.managedObjects count]+1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Abstract
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == [self.managedObjects count]) {
        return sourceIndexPath;
    }
    else {
        return proposedDestinationIndexPath;
    }
}

#pragma mark - Editing

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(toIndexPath.row < [self.managedObjects count]){
        NSManagedObject *mo = [self.managedObjects objectAtIndex:fromIndexPath.row];
        [self.managedObjects removeObject:self.managedObjects[fromIndexPath.row]];
        [self.managedObjects insertObject:mo atIndex:toIndexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.row == [self.managedObjects count]){
        return NO;
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.managedObjectToDelete = self.managedObjects[indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Delete group \"%@\"?\nThis action cannot be undone.",cell.textLabel.text]
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Delete group", nil];
        deleteSheet.tag = DeleteEntity;
        
        
        [deleteSheet showInView:self.view.window];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.textField){
        self.textField = textField;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self showAddNewManagedObjectActionSheet];
    return YES;
}


#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        if(actionSheet.tag == DeleteEntity){
            [self.context deleteObject:self.managedObjectToDelete];
            [self refreshTableView];
        }
        if(actionSheet.tag == AddEntity){
            [self createNewManagedObjectNamed:self.textField.text];
            self.textField.text = @"";
        }
    } else {
        if(actionSheet.tag == AddEntity){
            self.textField.text = @"";
        }
    }
}

-(void)createNewManagedObjectNamed:(NSString *)newManagedObjectName
{
    // Abstract
}

#pragma mark - Target Action

- (IBAction)addNewManagedObject:(UIButton *)sender
{
    // NSLog(@"addNewGroup...");
    [self.textField resignFirstResponder];
    [self showAddNewManagedObjectActionSheet];
}

-(void)showAddNewManagedObjectActionSheet
{
    // NSLog(@"showAddNewManagedObjectActionSheet...");
    if([self.textField.text length] > 0){
        UIActionSheet *addSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Create group \"%@\"",self.textField.text]
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Create group", nil];
        addSheet.tag = AddEntity;
        [addSheet showInView:self.view.window];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
