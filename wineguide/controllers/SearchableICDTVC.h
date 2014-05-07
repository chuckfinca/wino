//
//  SearchableCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "InstructionsCDTVC.h"

@interface SearchableICDTVC : InstructionsCDTVC

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSPredicate *fetchPredicate; // Abstract

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text; // Abstract
-(void)getMoreResultsFromTheServer; // Abstract


@end
