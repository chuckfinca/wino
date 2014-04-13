//
//  DocumentHandler2.h
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onDocumentReady) (UIManagedDocument *document);

@interface DocumentHandler2 : NSObject

@property (nonatomic, strong) UIManagedDocument *document;

+(DocumentHandler2 *)sharedDocumentHandler;
-(void)performWithDocument:(onDocumentReady)onDocumentReady;

@end
