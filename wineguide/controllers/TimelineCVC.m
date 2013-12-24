//
//  TimelineCVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/19/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TimelineCVC.h"
#import "WineCardCell.h"
#import <CoreData/CoreData.h>
#import "DocumentHandler.h"
#import "Wine.h"
#import "UserRatingCVC.h"
#import "ColorSchemer.h"

#define WINE_CARD_CELL @"WineCardCell"
#define WINE_ENTITY @"Wine"
#define USER_RATING_CELL @"UserRatingCell"

@interface TimelineCVC ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *wines;
@property (nonatomic, strong) UIImageView *userRatingImageView;

@end

@implementation TimelineCVC

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
    [self.collectionView registerNib:[UINib nibWithNibName:WINE_CARD_CELL bundle:nil] forCellWithReuseIdentifier:WINE_CARD_CELL];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.title = @"Timeline";
    self.collectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView.collectionViewLayout invalidateLayout];
    //self.collectionView.contentOffset = CGPointMake(0,0);
}


#pragma mark - Getters & Setters

-(UIImageView *)userRatingImageView
{
    if(!_userRatingImageView) {
        _userRatingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rating_unrated.png"] highlightedImage:[UIImage imageNamed:@"rating_rated.png"]];
    }
    return _userRatingImageView;
}

#pragma mark - Setup

-(void)refresh
{
    [self getManagedObjectContext];
    if (self.context){
        [self setupFetchedResultsController];
    }
}

-(void)getManagedObjectContext
{
    if(!self.context && [DocumentHandler sharedDocumentHandler]){
        self.context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
    } else {
        [self listenForDocumentReadyNotification];
        NSLog(@"cannot get managed object context because either self.context exists (%@) or [DocumentHandler sharedDocumentHandler] does not exist (%@). Did start listening to DocumentReady notifications",self.context,[DocumentHandler sharedDocumentHandler]);
    }
}

-(void)setupFetchedResultsController
{
    //NSLog(@"Timeline setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WINE_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    request.predicate = nil;
    
    NSError *error;
    self.wines = [self.context executeFetchRequest:request error:&error];
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.collectionView){
        return [self.wines count];
    } else if([collectionView isKindOfClass:[CollectionViewWithIndex class]]){
        return 5;
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if(collectionView == self.collectionView){
        
        WineCardCell *wineCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:WINE_CARD_CELL forIndexPath:indexPath];
        wineCardCell.userRatingCollectionView.index = indexPath.row;
        wineCardCell.userRatingCollectionView.dataSource = self;
        wineCardCell.userRatingCollectionView.delegate = self;
        [wineCardCell.userRatingCollectionView registerNib:[UINib nibWithNibName:@"UserRatingCVC" bundle:nil] forCellWithReuseIdentifier:USER_RATING_CELL];
        wineCardCell.userRatingCollectionView.backgroundColor = [ColorSchemer sharedInstance].customWhite;
        
        
        Wine *wine = [self.wines objectAtIndex:indexPath.row];
        [wineCardCell setupCardWithWine:wine];
        
        cell = wineCardCell;
    } else if([collectionView isKindOfClass:[CollectionViewWithIndex class]]){
        
        CollectionViewWithIndex *cvwi = (CollectionViewWithIndex *)collectionView;
        
        Wine *wine = self.wines[cvwi.index];
        
        // display rating if the wine has been rated by the user.
        // user can edit their rating if they like
        // display empty rating and are encouraged to rate
        
        UserRatingCVC *urCell = [collectionView dequeueReusableCellWithReuseIdentifier:USER_RATING_CELL forIndexPath:indexPath];
        [urCell glassIsEmpty:YES];
        cell = urCell;
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.collectionView){
        WineCardCell *wineCardCell = (WineCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
        for(UICollectionViewCell *userRatingCell in wineCardCell.userRatingCollectionView.visibleCells){
            
            CGPoint touchLocationInWineCardCell = [collectionView.panGestureRecognizer locationInView:wineCardCell.userRatingCollectionView];
            
            if(CGRectContainsPoint(userRatingCell.frame, touchLocationInWineCardCell)){
                [self collectionView:wineCardCell.userRatingCollectionView didSelectItemAtIndexPath:[wineCardCell.userRatingCollectionView indexPathForCell:userRatingCell]];
                
            }
        }
    } else if([collectionView isKindOfClass:[CollectionViewWithIndex class]]){
        
        int rating = indexPath.row;
        
        for(UserRatingCVC *glass in collectionView.visibleCells){
            if([collectionView indexPathForCell:glass].row <= rating){
                [glass glassIsEmpty:NO];
            } else {
                [glass glassIsEmpty:YES];
            }
        }
    }
}


#pragma mark - Listen for Notifications

-(void)listenForDocumentReadyNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"Document Ready"
                                               object:nil];
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

