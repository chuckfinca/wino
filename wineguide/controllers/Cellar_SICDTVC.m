//
//  FavoritesSCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Cellar_SICDTVC.h"
#import "Wine.h"
#import "ColorSchemer.h"
#import "Varietal.h"
#import "TastingNote.h"
#import "Wine_TRSICDTVC.h"
#import "WineCell.h"
#import "FontThemer.h"
#import "GetMe.h"

#define WINE_ENTITY @"Wine"
#define WINE_CELL @"WineCell"

#define HEADER_HEIGHT 120
#define MIN_SIDE_LENGTH 44
#define OFFSET 10

@interface Cellar_SICDTVC ()

@property (nonatomic) BOOL firstTime;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) WineCell *sizingCell;

@end

@implementation Cellar_SICDTVC

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
    [self.tableView registerNib:[UINib nibWithNibName:WINE_CELL bundle:nil] forCellReuseIdentifier:WINE_CELL];
    self.firstTime = YES;
    
    self.displaySearchBar = YES;
    self.searchBar.placeholder = @"Search your cellar...";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & setters

-(User *)user
{
    if(!_user){
        _user = [GetMe sharedInstance].me;
    }
    return _user;
}


-(WineCell *)sizingCell
{
    if(!_sizingCell){
        _sizingCell = [[[NSBundle mainBundle] loadNibNamed:@"WineCell" owner:self options:nil] firstObject];
    }
    return _sizingCell;
}


#pragma mark - Setup

-(void)registerInstructionCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell_Cellar" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
}

-(void)setupForUser:(User *)user
{
    self.user = user;
}

#pragma mark - SearchableCDTVC Required Methods


-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    // NSLog(@"Favorites setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    if(text){
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",[text lowercaseString]];
        NSPredicate *wineInCellarPredicate = [NSPredicate predicateWithFormat:@"ANY favoritedBy.identifier == %@",self.user.identifier];
        
        NSCompoundPredicate *compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[searchPredicate, wineInCellarPredicate]];
        request.predicate = compoundPredicate;
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"ANY favoritedBy.identifier == %@",self.user.identifier];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    WineCell *wineCell = (WineCell *)[self.tableView dequeueReusableCellWithIdentifier:WINE_CELL forIndexPath:indexPath];
    
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [wineCell setupCellForWine:wine];
    
    wineCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return wineCell;
}

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Wine_TRSICDTVC *wineCDTVC = [[Wine_TRSICDTVC alloc] initWithStyle:UITableViewStylePlain];
    
    // Pass the selected object to the new view controller.
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [wineCDTVC setupWithWine:wine fromRestaurant:nil];
    
    [self.navigationController pushViewController:wineCDTVC animated:YES];
}


#pragma mark - UITableViewDelegate

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.sizingCell setupCellForWine:wine];
    
    return self.sizingCell.bounds.size.height;
}










@end
