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

@interface RestaurantWineListManagerTVC ()

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
