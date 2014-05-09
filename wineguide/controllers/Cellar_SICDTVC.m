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
@property (nonatomic, strong) WineCell *wineSizingCell;

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
    [self.tableView registerNib:[UINib nibWithNibName:@"WineCell" bundle:nil] forCellReuseIdentifier:WINE_CELL];
    self.firstTime = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupAndSearchFetchedResultsControllerWithText:nil];
    [self setupHeader];
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


-(WineCell *)wineSizingCell
{
    if(!_wineSizingCell){
        _wineSizingCell = [[[NSBundle mainBundle] loadNibNamed:@"WineCell" owner:self options:nil] firstObject];
        _wineSizingCell.abridged = YES;
    }
    return _wineSizingCell;
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

-(void)setupHeader
{
    UITextView *prompt = [self setupPromptTextView];
    CGSize promptSize = [prompt sizeThatFits:CGSizeMake(self.view.bounds.size.width, FLT_MAX)];
    prompt.frame = CGRectMake(0, OFFSET*2, self.view.bounds.size.width, promptSize.height);
    
    UIImageView *cellarIV = [[UIImageView alloc] initWithFrame:CGRectMake(OFFSET, prompt.frame.size.height+3*OFFSET, MIN_SIDE_LENGTH, MIN_SIDE_LENGTH)];
    cellarIV.image = [[UIImage imageNamed:@"tab_cellar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cellarIV.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    UILabel *label = [[UILabel alloc] init];
    NSNumber *winesInCellar = [NSNumber numberWithInteger:[self.fetchedResultsController.fetchedObjects count]];
    NSNumber *percent = [NSNumber numberWithFloat:[winesInCellar floatValue]/12*100];
    int slotsLeft = 12 - [winesInCellar intValue];
    NSString *labelString = [NSString stringWithFormat:@"%i%% full\n%i slots available", [percent intValue],slotsLeft];
    label.attributedText = [[NSAttributedString alloc] initWithString:labelString attributes:@{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : [FontThemer sharedInstance].footnote}];
    label.numberOfLines = 0;
    [label sizeToFit];
    label.frame = CGRectMake(cellarIV.frame.origin.x+cellarIV.frame.size.width+OFFSET/2, prompt.frame.size.height+OFFSET*3.5, label.bounds.size.width, label.bounds.size.height);
    
    
    
    float viewHeight = promptSize.height+MIN_SIDE_LENGTH*2+4*OFFSET;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, viewHeight)];
    [view addSubview:prompt];
    [view addSubview:cellarIV];
    [view addSubview:label];
    view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.searchBar.frame = CGRectMake(0, viewHeight-MIN_SIDE_LENGTH, 320, MIN_SIDE_LENGTH);
    self.tableView.tableHeaderView = view;
    [view addSubview:self.searchBar];
    [self setupSearchBar];
}

-(UITextView *)setupPromptTextView
{
    NSArray *prompts = @[@"Welcome! Your Cellar is the place for your favorite wines. Look around the app for ways to increase how many you can store.", @"TRY IT - check a wine into your timeline using the 'Tried It' button on a wine details page", @"TRY IT - Add a wine to your cellar using the 'Cellar' button"];
    
    int number;
    if(self.firstTime){
        number = 0;
        self.firstTime = NO;
    } else {
        number = arc4random_uniform(2) + 1;
    }
    NSString *string = prompts[number];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.attributedText = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : [FontThemer sharedInstance].body}];
    tv.textContainerInset = UIEdgeInsetsMake(0, OFFSET, 0, OFFSET);
    tv.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    return tv;
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
    wineCell.abridged = YES;
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
    [self.wineSizingCell setupCellForWine:wine numberOfTalkingHeads:0];
    
    return self.wineSizingCell.bounds.size.height;
}










@end
