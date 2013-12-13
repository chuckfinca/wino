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
#import "RestaurantWineManagerSCDTVC.h"
#import "WineCell.h"

#define WINE_CELL @"WineCell"

#define WINE_ENTITY @"Wine"

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
    self.title = [self.group.name capitalizedString];
    [self.tableView registerNib:[UINib nibWithNibName:@"WineCell" bundle:nil] forCellReuseIdentifier:WINE_CELL];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTableView];
}

-(void)refreshTableView
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"ANY groups.identifier = %@",self.group.identifier];
    
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    self.managedObjects = [matches mutableCopy];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0 && [self.managedObjects count] > 0){
        return nil;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"section = %i",section);
    if(section == 0){
        return [self.managedObjects count];
    } else {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"cellForRowAtIndexPath...");
    UITableViewCell *cell = nil;
    NSString *cellIdentifier;
    NSLog(@"indexPath = %@",indexPath);
    
    if([indexPath isEqual: [NSIndexPath indexPathForItem:0 inSection:1]]){
        cellIdentifier = @"AddWineCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Add wine..." attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textLink}];
    } else {
        cellIdentifier = @"WineCell";
        WineCell *wineCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Wine *wine = self.managedObjects[indexPath.row];
        
        [wineCell setupCellForWine:wine];
        
        cell = wineCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 62;
    }
    return 44;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RestaurantWineManagerSCDTVC class]]){
        NSLog(@"prepareForSegue");
        RestaurantWineManagerSCDTVC *rwm = (RestaurantWineManagerSCDTVC *)segue.destinationViewController;
        rwm.group = self.group;
    }
}


#pragma mark - Pre Core Data Changes

-(void)showRemoveActionSheetItem:(NSString *)itemName
{
    UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Remove wine"
                                  
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
    if([managedObject isKindOfClass:[Wine class]]){
        
        // remove the Group from the WineUnit
        Wine *w = (Wine *)managedObject;
        NSLog(@"w.groups = %@",w.groups);
        NSMutableSet *groups = [w.groups mutableCopy];
        [groups removeObject:self.group];
        w.groups = groups;
        NSLog(@"w.groups = %@",w.groups);
        
        NSString *groupIdentifiers = [w.groupIdentifiers stringByReplacingOccurrencesOfString:self.group.identifier withString:@""];
        groupIdentifiers = [groupIdentifiers stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        w.groupIdentifiers = groupIdentifiers;
        
        w.lastServerUpdate = [NSDate date];
        
        
        // remove the WineUnit from the Group
        NSLog(@"wineIdentifiers = %@",self.group.wineIdentifiers);
        NSMutableSet *wines = [self.group.wines mutableCopy];
        NSLog(@"w = %@",w);
        [wines containsObject:w] ? NSLog(@"y") : NSLog(@"n");
        [wines removeObject:w];
        self.group.wines = wines;
        NSLog(@"wineIdentifiers = %@",self.group.wineIdentifiers);
        
        NSString *wineIdentifiers = [self.group.wineIdentifiers stringByReplacingOccurrencesOfString:w.identifier withString:@""];
        wineIdentifiers = [wineIdentifiers stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        self.group.wineIdentifiers = wineIdentifiers;
        NSLog(@"context parent = %@",self.context.parentContext);
        
        self.group.lastServerUpdate = [NSDate date];
    }
    
    [self refreshTableView];
}


#pragma mark - Target Action



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
