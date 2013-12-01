//
//  RestaurantWineListManagerTVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantWineListManagerTVC.h"
#import "WineUnit.h"
#import "Wine.h"

#define WINE_UNIT_ENTITY @"WineUnit"

@interface RestaurantWineListManagerTVC () <UIActionSheetDelegate>

@end

@implementation RestaurantWineListManagerTVC

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
    self.title = self.group.name;
    [self refreshTableView];
}

-(void)refreshTableView
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_UNIT_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"wine.name"
                                                              ascending:YES]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"ANY groups.identifier = %@",self.group.identifier];
    
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    self.managedObjects = [matches mutableCopy];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"cellForRowAtIndexPath...");
    UITableViewCell *cell = nil;
    NSString *cellIdentifier;
    
    if(indexPath.row == [self.managedObjects count]){
        cellIdentifier = @"AddWineCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    } else {
        cellIdentifier = @"WineCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        WineUnit *wineUnit = self.managedObjects[indexPath.row];
        cell.textLabel.text = wineUnit.wine.name;
    }
    
    return cell;
}

#pragma mark - Pre Core Data Changes

-(void)showRemoveActionSheetForCell:(UITableViewCell *)cell
{
    UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Remove Wine \"%@\"?",cell.textLabel.text]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Remove"
                                  
                                                    otherButtonTitles:nil];
    deleteSheet.tag = DeleteEntity;
    
    
    [deleteSheet showInView:self.view.window];
}

-(void)showAddActionSheet
{
    // NSLog(@"showAddNewManagedObjectActionSheet...");
    if([self.textField.text length] > 0){
        UIActionSheet *addSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Add Wine \"%@\"",self.textField.text]
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Add", nil];
        addSheet.tag = AddEntity;
        [addSheet showInView:self.view.window];
    }
}

#pragma mark - Core Data

-(void)createNewManagedObjectNamed:(NSString *)newManagedObjectName
{
    NSLog(@"createNewManagedObjectNamed...");
    /*
    NSString *groupName = [newManagedObjectName lowercaseString];
    groupName = [groupName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *groupIdentifier = [NSString stringWithFormat:@"group.%@.%@",self.restaurant.identifier,groupName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",groupIdentifier];
    [Group groupFoundUsingPredicate:predicate inContext:self.context withEntityInfo:@{@"identifier" : groupIdentifier, @"name" : newManagedObjectName, @"restaurantIdentifier" : self.restaurant.identifier, @"sortOrder" : @([self.managedObjects count])}];
    */
    [self refreshTableView];
}

-(void)deleteFromListManagedObject:(id)managedObject
{
    NSLog(@"deleteFromListManagedObject...");
    [self refreshTableView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
