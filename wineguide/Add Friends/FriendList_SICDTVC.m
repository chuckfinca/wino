//
//  FriendListSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendList_SICDTVC.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "FacebookProfileImageGetter.h"
#import "FacebookSessionManager.h"
#import <FBLoginView.h>

#define USER_ENTITY @"User2"

@interface FriendList_SICDTVC ()

@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *loginWithFacebookLabel;

@end

@implementation FriendList_SICDTVC

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
    
    //[FacebookSessionManager sharedInstance].
    
    [self setupInstructionsView];
}

#pragma mark - Getters & setters

-(FacebookProfileImageGetter *)facebookProfileImageGetter
{
    if(!_facebookProfileImageGetter){
        _facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    }
    return _facebookProfileImageGetter;
}

#pragma mark - Setup

-(void)registerInstructionCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell_FacebookConnect" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
}

#pragma mark - SearchableCDTVC Required Methods


-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name_last_initial"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name_last"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name_first"
                                                              ascending:YES]];
    if([text length] > 0){
        request.predicate = [NSPredicate predicateWithFormat:@"name_full CONTAINS[cd] %@ && is_me == nil",[text lowercaseString]];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"is_me == nil"];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"name_last_initial"
                                                                                   cacheName:nil];
}

-(void)setupInstructionsView
{
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    self.loginWithFacebookLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Connect to Facebook to add friends to this Tasting Record." attributes:@{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : [FontThemer sharedInstance].body}];
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    User2 *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(user.name_display){
        NSString *name = [NSString stringWithFormat:@"%@ ",user.name_first];
        NSInteger firstNameLength = [name length];
        name = [name stringByAppendingString:user.name_last];
        
        NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body}];
        [attributedName addAttribute:NSFontAttributeName value:[FontThemer sharedInstance].headline range: NSMakeRange(firstNameLength, [user.name_last length])];
        
        cell.textLabel.attributedText = attributedName;
    }
    
    if(user.imageData){
        [cell.imageView setImage:[UIImage imageWithData:user.imageData]];
        
    } else {
        __weak UITableView *weakTableView = self.tableView;
        
        [self.facebookProfileImageGetter setProfilePicForUser:user inImageView:cell.imageView completion:^(BOOL success) {
            if(success){
                [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
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
    User2 *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate addOrRemoveUser:user];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User2 *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate addOrRemoveUser:user];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
