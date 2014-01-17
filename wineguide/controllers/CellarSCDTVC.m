//
//  FavoritesSCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "CellarSCDTVC.h"
#import "Wine.h"
#import "ColorSchemer.h"
#import "Varietal.h"
#import "TastingNote.h"
#import "WineCDTVC.h"
#import "WineCell.h"

#define WINE_ENTITY @"Wine"
#define WINE_CELL @"WineCell"

#define HEADER_HEIGHT 120
#define SEARCH_BAR_HEIGHT 44

@interface CellarSCDTVC ()

@end

@implementation CellarSCDTVC

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
    self.title = @"Cellar";
    [self.tableView registerNib:[UINib nibWithNibName:@"WineCell" bundle:nil] forCellReuseIdentifier:WINE_CELL];
    self.tableView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    [self setupHeader];

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
    return [NSPredicate predicateWithFormat:@"favorite = %@",@YES];
}


#pragma mark - Setup

-(void)setupHeader
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEADER_HEIGHT)];
    self.searchBar.frame = CGRectMake(0, HEADER_HEIGHT-SEARCH_BAR_HEIGHT, 320, SEARCH_BAR_HEIGHT);
    self.tableView.tableHeaderView = view;
    [view addSubview:self.searchBar];
    [self setupSearchBar];
    
    view.backgroundColor = [UIColor orangeColor];
}

-(void)setupSearchBar
{
    self.searchBar.placeholder = @"Search your cellar...";
}

#pragma mark - SearchableCDTVC Required Methods


-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    // NSLog(@"Favorites setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"color"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"varietalIdentifiers"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    if(text){
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",[text lowercaseString]];
        NSCompoundPredicate *compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[self.fetchPredicate, searchPredicate]];
        request.predicate = compoundPredicate;
    } else {
        request.predicate = self.fetchPredicate;
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"color"
                                                                                   cacheName:nil];
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
    WineCell *wineCell = (WineCell *)[tableView dequeueReusableCellWithIdentifier:WINE_CELL forIndexPath:indexPath];
    
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    wineCell.abridged = YES;
    [wineCell setupCellForWine:wine];
    
    wineCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return wineCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"WineDetailsSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // NSLog(@"prepareForSegue...");
    if([sender isKindOfClass:[UITableViewCell class]]){
        
        UITableViewCell *tvc = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
        
        if(indexPath){
            if([segue.destinationViewController isKindOfClass:[WineCDTVC class]]){
                
                // Get the new view controller using [segue destinationViewController].
                WineCDTVC *wineCDTVC = (WineCDTVC *)segue.destinationViewController;
                
                // Pass the selected object to the new view controller.
                Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [wineCDTVC setupWithWine:wine fromRestaurant:nil];
            }
        }
    }
}

@end
