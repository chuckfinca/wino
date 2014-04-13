//
//  DocumentHandler2.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "DocumentHandler2.h"
#import <CoreData/CoreData.h>

@implementation DocumentHandler2

static DocumentHandler2 *sharedInstance;

+(DocumentHandler2 *)sharedDocumentHandler
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if(self){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Corkie.document"];
        _document = [[UIManagedDocument alloc] initWithFileURL:url];
        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption : @YES,
                                  NSInferMappingModelAutomaticallyOption : @YES
                                  };
        
        _document.persistentStoreOptions = options;
    }
    return self;
}

-(void)performWithDocument:(onDocumentReady)onDocumentReady
{
    // This function takes a generic UIManagedDocument and replaces it with the singleton
    
    // define our completion handler
    void (^onDocumentDidLoad)(BOOL) = ^(BOOL success){
        if(success){
            onDocumentReady(self.document);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Document Ready" object:nil];
        } else {
            NSLog(@"document failed to load");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem loading data." message:@"Please delete the app and reinstall. Sorry for the inconvenience." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    };
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]){
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:onDocumentDidLoad];
    } else {
        switch (self.document.documentState) {
            case UIDocumentStateClosed:
                [self.document openWithCompletionHandler:onDocumentDidLoad];
                break;
            case UIDocumentStateNormal:
                onDocumentDidLoad(YES);
                break;
            case UIDocumentStateEditingDisabled:
                NSLog(@"UIDocumentStateEditingDisabled"); // temporary situation, try again
                break;
            case UIDocumentStateInConflict:
                NSLog(@"UIDocumentStateInConflict"); // some other device changed it via iCloud
                break;
            case UIDocumentStateSavingError:
                NSLog(@"UIDocumentStateSavingError"); // success will be NO in onDocumentReady
                break;
            default:
                break;
        }
    }
}











@end
