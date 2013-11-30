//
//  RestaurantManagerCDTVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantGroupManagerTVC.h"
#import "DocumentHandler.h"
#import "Restaurant.h"
#import "Group+CreateAndModify.h"

#define RESTAURANT_ENTITY @"Restaurant"
#define GROUP_ENTITY @"Group"

typedef enum {
    DeleteEntity,
    AddEntity,
} ActionSheetType;

@interface RestaurantGroupManagerTVC () <UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSMutableArray *groups; // of Group objects
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, weak) Group *groupToDelete;
@end

@implementation RestaurantGroupManagerTVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getManagedObjectContext];
    [self loadRestaurant];
    [self refreshTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self listenForKeyboardNotifcations];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getManagedObjectContext
{
    if([DocumentHandler sharedDocumentHandler].document){
        self.context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
    } else {
        NSLog(@"RestaurantManagerSCDTVC - [DocumentHandler sharedDocumentHandler].document does not exist");
    }
}

-(void)loadRestaurant
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:RESTAURANT_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",@"restaurant.leszygomates.129southstreet"];
    
    NSError *error;
    NSArray *match = [self.context executeFetchRequest:request error:&error];
    self.restaurant = [match firstObject];
}

-(void)refreshTableView
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GROUP_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"restaurantIdentifier = %@",self.restaurant.identifier];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    self.groups = [matches mutableCopy];
    [self.tableView reloadData];
    [self setGroupSortOrder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups count]+1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Groups";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"cellForRowAtIndexPath...");
    UITableViewCell *cell = nil;
    NSString *cellIdentifier;
    
    if(indexPath.row == [self.groups count]){
        cellIdentifier = @"AddGroupCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    } else {
        cellIdentifier = @"GroupCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Group *group = self.groups[indexPath.row];
        cell.textLabel.text = group.name;
    }
    
    return cell;
}



#pragma mark - Editing

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(toIndexPath.row < [self.groups count]){
        Group *group = [self.groups objectAtIndex:fromIndexPath.row];
        [self.groups removeObject:self.groups[fromIndexPath.row]];
        [self.groups insertObject:group atIndex:toIndexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.row == [self.groups count]){
        return NO;
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.groupToDelete = self.groups[indexPath.row];
        UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Delete group \"%@\"?\nThis action cannot be undone.",self.groupToDelete.name]
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

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(self.editing == NO){
        [self setGroupSortOrder];
    }
}

-(void)setGroupSortOrder
{
    for(Group *group in self.groups){
        group.sortOrder = @([self.groups indexOfObject:group]);
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didEndEditingRowAtIndexPath");
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == [self.groups count]) {
        return sourceIndexPath;
    }
    else {
        return proposedDestinationIndexPath;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // NSLog(@"prepareForSegue...");
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        UITableViewCell *tvc = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
        
        if(indexPath){
            if([segue.destinationViewController isKindOfClass:[UITableViewController class]]){
                
                // Get the new view controller using [segue destinationViewController].
                UITableViewController *tvc = (UITableViewController *)segue.destinationViewController;
                
                // Pass the selected object to the new view controller.
                Group *group = self.groups[indexPath.row];
                tvc.title = group.name;
            }
        }
    }
}

#pragma mark - Target Action

- (IBAction)dismissModalVC:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissed");
    }];
}

- (IBAction)addNewGroup:(UIButton *)sender
{
    NSLog(@"addNewGroup...");
    [self.textField resignFirstResponder];
    [self showAddNewGroupActionSheet];
}

-(void)showAddNewGroupActionSheet
{
    NSLog(@"createNewGroup...");
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


#pragma mark - Notifications

-(void)listenForKeyboardNotifcations
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHideCancelButton:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHideCancelButton:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)showHideCancelButton:(NSNotification *)notification
{
    //NSLog(@"self.newGroupNameTextField.text = %@",self.groupNameTextField.text);
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.textField){
        NSLog(@"textFieldDidBeginEditing");
        self.textField = textField;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self showAddNewGroupActionSheet];
    return YES;
}


#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        if(actionSheet.tag == DeleteEntity){
            [self.context deleteObject:self.groupToDelete];
            [self refreshTableView];
        }
        if(actionSheet.tag == AddEntity){
            [self createNewGroupNamed:self.textField.text];
            self.textField.text = @"";
        }
    }
}

#pragma mark - Core Data

-(void)createNewGroupNamed:(NSString *)newGroupName
{
    NSString *groupName = [newGroupName lowercaseString];
    groupName = [groupName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *groupIdentifier = [NSString stringWithFormat:@"group.%@.%@",self.restaurant.identifier,groupName];
    NSLog(@"groupIdentifier = %@",groupIdentifier);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",groupIdentifier];
    
    Group *group = [Group groupFoundUsingPredicate:predicate inContext:self.context withEntityInfo:@{@"identifier" : groupIdentifier, @"name" : newGroupName, @"restaurantIdentifier" : self.restaurant.identifier}];
    group.sortOrder = @([self.groups count]);
    
    [self refreshTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
