//
//  RestaurantTVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant_SICDTVC.h"
#import "RestaurantDetailsVC.h"
#import "Wine_TRSICDTVC.h"
#import "ColorSchemer.h"
#import "WineCell.h"
#import "FacebookProfileImageGetter.h"
#import "ServerCommunicator.h"
#import "WineList.h"
#import "WineColorStringFromCode.h"

#define WINE_LIST_ENTITY @"WineList"
#define WINE_ENTITY @"Wine2"
#define COLOR_CODE @"color_code"
#define WINE_CELL_WITH_RATING @"WineCell_withRating"
#define WINE_CELL_WITH_RATING_AND_TALKING_HEADS @"WineCell_withRatingAndTalkingHeads"

typedef NS_ENUM(NSInteger, WineColor) {
    WineColorRed     = 1,
    WineColorWhite   = 2,
    WineColorRose    = 3,
};


@interface Restaurant_SICDTVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RestaurantDetailsVC *restaurantDetailsViewController;
@property (nonatomic, strong) Restaurant2 *restaurant;
@property (nonatomic, strong) NSFetchedResultsController *restaurantGroupsFRC;

@property (nonatomic, strong) WineCell *sizingCellWithRating;
@property (nonatomic, strong) WineCell *sizingCellWithRatingAndTalkingHeads;

@property (nonatomic, strong) NSArray *testingArray;
@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;

@end

@implementation Restaurant_SICDTVC

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:WINE_CELL_WITH_RATING bundle:nil] forCellReuseIdentifier:WINE_CELL_WITH_RATING];
    [self.tableView registerNib:[UINib nibWithNibName:WINE_CELL_WITH_RATING_AND_TALKING_HEADS bundle:nil] forCellReuseIdentifier:WINE_CELL_WITH_RATING_AND_TALKING_HEADS];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TableViewSectionHeaderViewIdentifier"];
    
    self.displayInstructionsCell = NO;
}

#pragma mark - Getters & Setters

-(RestaurantDetailsVC *)restaurantDetailsViewController
{
    if(!_restaurantDetailsViewController){
        _restaurantDetailsViewController = [[RestaurantDetailsVC alloc] initWithNibName:@"RestaurantDetails" bundle:nil];
    }
    return _restaurantDetailsViewController;
}

-(WineCell *)sizingCellWithRating
{
    if(!_sizingCellWithRating){
        _sizingCellWithRating = [[[NSBundle mainBundle] loadNibNamed:WINE_CELL_WITH_RATING owner:self options:nil] firstObject];
    }
    return _sizingCellWithRating;
}

-(WineCell *)sizingCellWithRatingAndTalkingHeads
{
    if(!_sizingCellWithRatingAndTalkingHeads){
        _sizingCellWithRatingAndTalkingHeads = [[[NSBundle mainBundle] loadNibNamed:WINE_CELL_WITH_RATING_AND_TALKING_HEADS owner:self options:nil] firstObject];
    }
    return _sizingCellWithRatingAndTalkingHeads;
}

-(FacebookProfileImageGetter *)facebookProfileImageGetter
{
    if(!_facebookProfileImageGetter){
        _facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    }
    return _facebookProfileImageGetter;
}

-(NSArray *)testingArray
{
    if(!_testingArray){
        _testingArray = @[@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2,@2,@0,@1,@2];
    }
    return _testingArray;
}

#pragma mark - Setup

-(void)setupWithRestaurant:(Restaurant2 *)restaurant
{
    // get the winelist for that restaurant
    self.restaurant = restaurant;
    [self.restaurantDetailsViewController setupWithRestaurant:restaurant];
    self.tableView.tableHeaderView = self.restaurantDetailsViewController.view;
    
    [self refreshWineList];
}

-(void)refreshWineList
{
    ServerCommunicator *caller = [[ServerCommunicator alloc] init];
    [caller getAllWinesFromRestaurantIdentifier:2];
}

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:COLOR_CODE
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY wineLists.identifier = %@",self.restaurant.wineList.identifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:COLOR_CODE
                                                                                   cacheName:nil];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    WineCell *cell = [self testCellForIndexPath:indexPath];
    Wine2 *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.numberOfTalkingHeads = [self.testingArray[indexPath.row] integerValue] * 2+1;
    [cell setupCellForWine:wine];
    [self loadTalkingHeadImagesInCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)loadTalkingHeadImagesInCell:(WineCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(cell.talkingHeadsArray){
        for(UIButton *talkingHeadButton in cell.talkingHeadsArray){
            
            __weak UITableView *weakTableView = self.tableView;
            [self.facebookProfileImageGetter setProfilePicForUser:nil inButton:talkingHeadButton completion:^(BOOL success) {
                if([weakTableView cellForRowAtIndexPath:indexPath]){
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
        }
    }
}

-(WineCell *)testCellForIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0){
        return [self.tableView dequeueReusableCellWithIdentifier:WINE_CELL_WITH_RATING forIndexPath:indexPath];
    }
    return [self.tableView dequeueReusableCellWithIdentifier:WINE_CELL_WITH_RATING_AND_TALKING_HEADS forIndexPath:indexPath];
}

-(WineCell *)testSizingCellForIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0){
        return self.sizingCellWithRating;
    }
    return self.sizingCellWithRatingAndTalkingHeads;
}

#pragma mark - UITableViewDelegate

-(NSString *)titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [WineColorStringFromCode wineColorStringFromColorCode:[[theSection name] integerValue]];
}

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    WineCell *cell = [self testSizingCellForIndexPath:indexPath];
    cell.numberOfTalkingHeads = [self.testingArray[indexPath.row] integerValue] * 2+1;
    Wine2 *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupCellForWine:wine];
    
    return cell.bounds.size.height;
}

-(UIView *)viewForHeaderInSection:(NSInteger)section
{
    Wine2 *wine = (Wine2 *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    
    UITableViewHeaderFooterView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableViewSectionHeaderViewIdentifier"];
    
    if(wine.color_code){
        [sectionHeaderView.textLabel setTextColor:[ColorSchemer sharedInstance].textPrimary];
    }
    sectionHeaderView.contentView.backgroundColor = [ColorSchemer sharedInstance].gray;
    return sectionHeaderView;
}

-(CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"userDidSelectRowAtIndexPath");
    Wine_TRSICDTVC *wineCDTVC = [[Wine_TRSICDTVC alloc] initWithStyle:UITableViewStylePlain];
    
    // Pass the selected object to the new view controller.
    Wine2 *wine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [wineCDTVC setupWithWine:wine fromRestaurant:self.restaurant];
    
    [self.navigationController pushViewController:wineCDTVC animated:YES];
}






@end
