//
//  SearchableCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Instructions_CDTVC.h"

@interface Searchable_ICDTVC : Instructions_CDTVC <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text; // Abstract
-(void)getMoreResultsFromTheServer; // Abstract


@end
