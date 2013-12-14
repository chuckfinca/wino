//
//  WineSCDTVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantWineManagerSCDTVC.h"
#import "Wine.h"
#import "Varietal.h"
#import "TastingNote.h"
#import "ColorSchemer.h"
#import "WineUnitDataHelper.h"
#import "Restaurant.h"
#import "WineCell.h"

#define WINE_ENTITY @"Wine"
#define GROUP_ENTITY @"Group"
#define WINE_CELL @"WineCell"

@interface RestaurantWineManagerSCDTVC () <UIAlertViewDelegate>

@property (nonatomic, strong) Wine *selectedWine;

@end

@implementation RestaurantWineManagerSCDTVC

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
    [self setupSearchBar];
    self.title = @"Add wine";
    [self.tableView registerNib:[UINib nibWithNibName:@"WineCell" bundle:nil] forCellReuseIdentifier:WINE_CELL];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupAndSearchFetchedResultsControllerWithText:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(NSPredicate *)fetchPredicate
{
    return nil;
}


#pragma mark - Setup

-(void)setupSearchBar
{
    self.searchBar.placeholder = @"Search for a wine...";
}

#pragma mark - SearchableCDTVC Required Methods


-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    if(text){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"color"
                                                                  ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"varietalIdentifiers"
                                                                  ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",[text lowercaseString]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.context
                                                                              sectionNameKeyPath:@"color"
                                                                                       cacheName:nil];
        //[self logFetchResults];
    }
}

-(void)logFetchResults
{
    NSLog(@"fetchedResultCount = %lu",(unsigned long)[self.fetchedResultsController.fetchedObjects count]);
    for(NSObject *fetchedResult in self.fetchedResultsController.fetchedObjects){
        NSLog(@"fetchedResult = %@",fetchedResult.description);
    }
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WineCell";
    WineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupCellForWine:wine];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedWine = wine;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add wine", nil];
    [alert show];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [self addWine:self.selectedWine];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    self.selectedWine = nil;
}

#pragma mark - Core Data

-(void)addWine:(Wine *)wine
{
    if(![self.group.wines containsObject:wine]){
        NSMutableSet *wines = [self.group.wines mutableCopy];
        [wines addObject:wine];
        self.group.wines = wines;
        
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GROUP_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@",[NSString stringWithFormat:@"group.%@.all",self.group.restaurant.identifier]];
    
    NSError *error;
    NSArray *allGroupArray = [self.context executeFetchRequest:request error:&error];
    Group *allGroup = (Group *)[allGroupArray firstObject];
    
    if(![allGroup.wines containsObject:wine]){
        NSMutableSet *aGWines = [allGroup.wines mutableCopy];
        [aGWines addObject:wine];
        allGroup.wines = aGWines;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"need to create wine unit!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alert show];
    
}

@end
