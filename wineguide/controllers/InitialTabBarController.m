//
//  InitialTabBarController.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "InitialTabBarController.h"
#import "DocumentHandler.h"

@interface InitialTabBarController ()

@property (nonatomic, readwrite) UIManagedDocument *document;

@end

@implementation InitialTabBarController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.document){
        [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            self.document = document;
            
            // Do any additional work now that the document is ready
            [self refresh];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh
{
    NSLog(@"refresh...");
    
    // this is where the app should check the server for any initial updates
    
}

@end
