//
//  SearchableCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface SearchableCDTVC : CoreDataTableViewController

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

-(void)setupFetchedResultsController; // Abstract
-(void)searchFetchedResultsForText:(NSString *)text; // Abstract

@end
