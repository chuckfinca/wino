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
#import "ColorSchemer.h"
#import "FontThemer.h"

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
    if([text length] > 0){
        request.predicate = [NSPredicate predicateWithFormat:@"nameFull CONTAINS[cd] %@ && isMe == nil",[text lowercaseString]];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"isMe == nil"];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"nameLastInitial"
                                                                                   cacheName:nil];
    
    //[self logFetchResults];
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
    
    if(user.nameFull){
        NSString *name = [NSString stringWithFormat:@"%@ ",user.nameFirst];
        NSInteger firstNameLength = [name length];
        name = [name stringByAppendingString:user.nameLast];
        
        NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body}];
        [attributedName addAttribute:NSFontAttributeName value:[FontThemer sharedInstance].headline range: NSMakeRange(firstNameLength, [user.nameLast length])];
        
        cell.textLabel.attributedText = attributedName;
    }
    
    if(user.profileImage){
        [cell.imageView setImage:[UIImage imageWithData:user.profileImage]];
        
    } else {
        __weak UITableView *weakTableView = self.tableView;
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", user.identifier]];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:URL];
        [cell.imageView setImageWithURLRequest:urlRequest placeholderImage:self.placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            user.profileImage = UIImagePNGRepresentation(image);
            [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"failed to download profile image");
        }];
    }
    
    cell.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath...");
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate addOrRemoveUser:user];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDeselectRowAtIndexPath...");
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate addOrRemoveUser:user];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
