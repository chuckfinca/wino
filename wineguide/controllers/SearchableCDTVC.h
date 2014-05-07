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
@property (nonatomic, strong) UITableViewCell *instructionsCell; // Abstract

@property (nonatomic, strong) NSPredicate *fetchPredicate; // Abstract

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text; // Abstract
-(void)getMoreResultsFromTheServer; // Abstract

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath; // Abstract - call instead of cellForRowAtIndexPath
-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath; // Abstract - call instead of heightForRowAtIndexPath
-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath; // Abstract - call instead of didSelectRowAtIndexPath
-(CGFloat)heightForInstructionsCell; // Abstract

@end
