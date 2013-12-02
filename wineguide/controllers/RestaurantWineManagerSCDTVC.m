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

#define WINE_ENTITY @"Wine"

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
    NSLog(@"Wines setupFetchedResultsController...");
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self setupTextForCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Wine *wine = (Wine *)self.fetchedResultsController.fetchedObjects[indexPath.row];
    self.selectedWine = wine;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add wine", nil];
    [alert show];
}

-(void)setupTextForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Wine *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(wine.name){
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[wine.name capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    }
    
    NSString *textViewString = @"";
    if(wine.vintage){
        NSString *vintageString = [wine.vintage stringValue];
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[vintageString capitalizedString]]];
    }
    if(wine.varietals){
        NSString *varietalsString = @"";
        if(wine.vintage) {
            varietalsString = @" - ";
        }
        NSArray *varietals = [wine.varietals sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(Varietal *varietal in varietals){
            varietalsString = [varietalsString stringByAppendingString:[NSString stringWithFormat:@"%@, ",varietal.name]];
        }
        varietalsString = [varietalsString substringToIndex:[varietalsString length]-2];
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[varietalsString capitalizedString]]];
    }
    if(wine.tastingNotes){
        NSString *tastingNotesString = @"\n";
        NSArray *tastingNotes = [wine.tastingNotes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(TastingNote *tastingNote in tastingNotes){
            tastingNotesString = [tastingNotesString stringByAppendingString:[NSString stringWithFormat:@"%@, ",tastingNote.name]];
        }
        tastingNotesString = [tastingNotesString substringToIndex:[tastingNotesString length]-2];
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",tastingNotesString]];
    }
    
    if(wine.vintage || wine.varietals){
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:textViewString attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    }
    
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %i",buttonIndex);
    if(buttonIndex == 1){
        NSLog(@"creating new wineUnit and linking it to the appropriate group");
        [self addWineToGroup];
        [self.navigationController popViewControllerAnimated:YES];
        // for each wine that is selected we need to
        // get or create the appropriate wine unit
        // add the right group to the wine unit
        // if the wine isn't in the all group it need to be added there as well
        
    } else {
            // [self setEditing:NO animated:YES];
    }
}

#pragma mark - Core Data

-(void)addWineToGroup
{
    // at this point we definitely have a wine and a group but do not necessarily have a wineUnit
    // NOTE - the problem with this is that a group needs to have specific wine units, not necessarily wines
    
    NSString *wineUnitIdentifier = [NSString stringWithFormat:@"wineunit.%@.%@.glass",self.group.restaurantIdentifier,self.selectedWine.identifier];
    //wineunit.restaurant.leszygomates.129southstreet.wine.brand.domainechevalier.varietal.aligote.2009.glass
    NSLog(@"wineUnitIdentifier - %@",wineUnitIdentifier);
    
    WineUnitDataHelper *wudh = [[WineUnitDataHelper alloc] initWithContext:self.context andRelatedObject:self.group andNeededManagedObjectIdentifiersString:nil];
    [wudh createWineUnitWithIdentifier:wineUnitIdentifier
                                 price:nil
                              quantity:@"glass"
                     flightIdentifiers:nil
                      groupIdentifiers:self.group.identifier
                     andWineIdentifier:self.selectedWine.identifier];
    
}

/*
 
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
 
 */

@end
