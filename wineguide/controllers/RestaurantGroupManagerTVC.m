//
//  RestaurantManagerCDTVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantGroupManagerTVC.h"
#import "Restaurant2.h"
#import "GroupHelper.h"
#import "Group2.h"
#import "RestaurantWineListManagerTVC.h"
#import "AddGroupCell.h"
#import "RestaurantGroupCell.h"
#import "ColorSchemer.h"

#define RESTAURANT_ENTITY @"Restaurant2"
#define GROUP_ENTITY @"Group2"

@interface RestaurantGroupManagerTVC () <UIActionSheetDelegate>

@property (nonatomic, strong) Restaurant2 *restaurant;
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
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",@"restaurant.hinojosa.1parklane"];
    
    NSError *error;
    NSArray *match = [self.context executeFetchRequest:request error:&error];
    self.restaurant = [match firstObject];
}

-(void)refreshTableView
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GROUP_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"restaurant.identifier = %@",self.restaurant.identifier];
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
    if(section == 0){
        return @"Groups";
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    if([indexPath isEqual:[NSIndexPath indexPathForItem:0 inSection:1]]){
        cellIdentifier = @"AddGroupCell";
        AddGroupCell *addCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        self.textField = addCell.textField;
        
        cell = addCell;
    } else {
        cellIdentifier = @"GroupCell";
        RestaurantGroupCell *restaurantGroupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Group2 *group = self.managedObjects[indexPath.row];
        [restaurantGroupCell setupCellAtIndexPath:indexPath forGroup:group];
    
        cell = restaurantGroupCell;
    }
    cell.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    return cell;
}



#pragma mark - Editing



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Group2 *group = (Group2 *)self.managedObjects[indexPath.row];
    if([[group.name lowercaseString] isEqualToString:@"all"]){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
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
    for(Group2 *group in self.managedObjects){
        group.sort_order = @([self.managedObjects indexOfObject:group]);
    }
    //[self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
                rwltvc.group = (Group2 *)self.managedObjects[indexPath.row];
            }
        }
    }
}

#pragma mark - Target Action

-(void)showRemoveActionSheetItem:(NSString *)itemName
{
    UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete group"
                                  
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
    NSDictionary *groupInfo = @{@"identifier" : @(arc4random_uniform(1000000)), @"name" : newManagedObjectName, @"restaurantIdentifier" : self.restaurant.identifier, @"lastUpdated" : [NSDate date]};
    
    GroupHelper *gh = [[GroupHelper alloc] init];
    Group2 *group = (Group2 *)[gh createObjectFromDictionary:groupInfo];
    group.sort_order = [NSNumber numberWithInteger:[self.managedObjects count]];
    
    [self refreshTableView];
}

-(void)deleteFromListManagedObject:(id)managedObject
{
    if([managedObject isKindOfClass:[Group2 class]]){
        
        // Delete group relationships and mark as deleted
        Group2 *group = (Group2 *)managedObject;
        
        [self.context deleteObject:group];
    }
    [self refreshTableView];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
