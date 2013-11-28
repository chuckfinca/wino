//
//  RestaurantManagerCDTVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantManagerTVC.h"
#import "DocumentHandler.h"
#import "Restaurant.h"
#import "Group.h"

#define RESTAURANT_ENTITY @"Restaurant"
#define GROUP_ENTITY @"Group"

@interface RestaurantManagerTVC ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSMutableArray *groups; // of Group objects
@end

@implementation RestaurantManagerTVC

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
    [self loadRestaurantGroups];
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

-(void)loadRestaurantGroups
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GROUP_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"restaurantIdentifier = %@",self.restaurant.identifier];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    self.groups = [matches mutableCopy];
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"moveRowAtIndexPath...");
    if(toIndexPath.row < [self.groups count]){
        Group *group = [self.groups objectAtIndex:fromIndexPath.row];
        [self.groups removeObject:self.groups[fromIndexPath.row]];
        [self.groups insertObject:group atIndex:toIndexPath.row];
        NSLog(@"self.groups = %@",self.groups);
    }
}

#pragma mark - Editing

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
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(self.editing == NO){
        NSLog(@"self.editing == NO");
        for(Group *group in self.groups){
            group.sortOrder = @([self.groups indexOfObject:group]);
            NSLog(@"%@ is sortOrder = %@",group.name, group.sortOrder);
        }
    }
}

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
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

#pragma mark - Target Action

- (IBAction)dismissModalVC:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissed");
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
