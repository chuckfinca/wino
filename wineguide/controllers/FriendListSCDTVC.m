//
//  FriendListSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendListSCDTVC.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>

#define USER_ENTITY @"User"

@interface FriendListSCDTVC ()

@property (nonatomic, strong) UIImage *placeHolderImage;

@end

@implementation FriendListSCDTVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(UIImage *)placeHolderImage
{
    if(!_placeHolderImage){
        _placeHolderImage = [[UIImage alloc] init];
    }
    return _placeHolderImage;
}

#pragma mark - SearchableCDTVC Required Methods


-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"nameLastInitial"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"nameLast"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"nameFirst"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"nameLastInitial"
                                                                                   cacheName:nil];
    
    [self logFetchResults];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",user.nameFirst, user.nameLast];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", user.identifier]];
    [cell.imageView setImageWithURL:URL placeholderImage:self.placeHolderImage];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

#pragma mark - FriendsListHeaderViewDelegate

-(void)checkIn
{
    NSLog(@"checkIn...");
}

-(void)backToCheckInDetails
{
    NSLog(@"backToCheckInDetails...");
}












@end
