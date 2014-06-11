//
//  FollowingFollowedBy_FLSICDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 6/10/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FollowingFollowedBy_FLSICDTVC.h"
#import "UserProfile_ICDTVC.h"

@interface FollowingFollowedBy_FLSICDTVC ()

@end

@implementation FollowingFollowedBy_FLSICDTVC

-(id)initWithUser:(User2 *)user predicate:(NSPredicate *)predicate andPageTitle:(NSString *)title
{
    self = [super init];
    
    if(self){
        self.user = user;
        self.predicate = predicate;
        self.navigationItem.title = title;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.displayInstructionsCell = NO;
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User2 *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UserProfile_ICDTVC *userProfile = [[UserProfile_ICDTVC alloc] initWithUser:user];
    [self.navigationController pushViewController:userProfile animated:YES];
}









@end
