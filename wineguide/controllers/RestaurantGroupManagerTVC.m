//
//  RestaurantManagerCDTVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantGroupManagerTVC.h"
#import "Restaurant.h"
#import "Group+CreateAndModify.h"
#import "RestaurantWineListManagerTVC.h"

#define RESTAURANT_ENTITY @"Restaurant"
#define GROUP_ENTITY @"Group"

@interface RestaurantGroupManagerTVC () <UIActionSheetDelegate>

@property (nonatomic, strong) Restaurant *restaurant;
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
    [self loadRestaurant];
    [self refreshTableView];
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
    self.managedObjects = [matches mutableCopy];
    [self.tableView reloadData];
    [self setGroupSortOrder];
}


#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Groups";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"cellForRowAtIndexPath...");
    UITableViewCell *cell = nil;
    NSString *cellIdentifier;
    
    if(indexPath.row == [self.managedObjects count]){
        cellIdentifier = @"AddGroupCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    } else {
        cellIdentifier = @"GroupCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Group *group = self.managedObjects[indexPath.row];
        cell.textLabel.text = group.name;
    }
    
    return cell;
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
    for(Group *group in self.managedObjects){
        group.sortOrder = @([self.managedObjects indexOfObject:group]);
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    // NSLog(@"prepareForSegue...");
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        UITableViewCell *tvc = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
        
        if(indexPath){
            if([segue.destinationViewController isKindOfClass:[UITableViewController class]]){
                
                // Get the new view controller using [segue destinationViewController].
                RestaurantWineListManagerTVC *rwltvc = (RestaurantWineListManagerTVC *)segue.destinationViewController;
                
                // Pass the selected object to the new view controller.
                rwltvc.group = (Group *)self.managedObjects[indexPath.row];
            }
        }
    }
}

#pragma mark - Target Action

-(void)showRemoveActionSheetItem:(NSString *)itemName
{
    UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Delete Group \"%@\"?",itemName]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                  
                                                    otherButtonTitles:nil];
    deleteSheet.tag = DeleteEntity;
    
    
    [deleteSheet showInView:self.view.window];
}

-(void)showAddActionSheet
{
    // NSLog(@"showAddNewManagedObjectActionSheet...");
    if([self.textField.text length] > 0){
        UIActionSheet *addSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Create Group \"%@\"",self.textField.text]
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Create Group", nil];
        addSheet.tag = AddEntity;
        [addSheet showInView:self.view.window];
    }
}

#pragma mark - Core Data

-(void)createNewManagedObjectNamed:(NSString *)newManagedObjectName
{
    NSString *groupName = [newManagedObjectName lowercaseString];
    groupName = [groupName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *groupIdentifier = [NSString stringWithFormat:@"group.%@.%@",self.restaurant.identifier,groupName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",groupIdentifier];
    Group *group = [Group groupFoundUsingPredicate:predicate inContext:self.context withEntityInfo:@{@"identifier" : groupIdentifier, @"name" : newManagedObjectName, @"restaurantIdentifier" : self.restaurant.identifier}];
    group.restaurant = self.restaurant;
    group.sortOrder = [NSNumber numberWithInteger:[self.managedObjects count]];
    
    [self refreshTableView];
}

-(void)deleteFromListManagedObject:(id)managedObject
{
    [self.context deleteObject:managedObject];
    [self refreshTableView];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
