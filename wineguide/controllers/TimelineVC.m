//
//  TimelineVC.m
//  Gimme
//
//  Created by Charles Feinn on 12/10/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TimelineVC.h"
#import "WineCardCell.h"
#import <CoreData/CoreData.h>
#import "DocumentHandler.h"
#import "Wine.h"

#define WINE_CARD_CELL @"WineCardCell"
#define WINE_ENTITY @"Wine"

@interface TimelineVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UICollectionView *wineCardCollectionView;
@property (nonatomic, strong) NSArray *wines;

@end

@implementation TimelineVC

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
    [self.wineCardCollectionView registerNib:[UINib nibWithNibName:WINE_CARD_CELL bundle:nil] forCellWithReuseIdentifier:WINE_CARD_CELL];
    self.wineCardCollectionView.showsHorizontalScrollIndicator = NO;
    self.wineCardCollectionView.backgroundColor = [UIColor whiteColor];
    self.title = @"Timeline";
    
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.wineCardCollectionView.collectionViewLayout invalidateLayout];
    //self.wineCardCollectionView.contentOffset = CGPointMake(0,0);
}


#pragma mark - Getters & Setters


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
    if(collectionView == self.wineCardCollectionView){
        return [self.wines count];
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if(collectionView == self.wineCardCollectionView){
        WineCardCell *wineCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:WINE_CARD_CELL forIndexPath:indexPath];
        
        Wine *wine = [self.wines objectAtIndex:indexPath.row];
        [wineCardCell setupCardWithWine:wine];
        
        cell = wineCardCell;
    }
    
    return cell;
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
