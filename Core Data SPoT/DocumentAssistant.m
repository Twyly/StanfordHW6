//
//  DocumentAssistant.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 9/1/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "DocumentAssistant.h"

@implementation DocumentAssistant


- (UIManagedDocument *)document
{
    if (!_document) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"PhotoDocument"];
        _document = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    return _document;
}

+ (DocumentAssistant *)sharedInstance
{
    __strong static id _sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)openDocumentWithBlock:(void (^)(BOOL))block
{
    DocumentAssistant *assitant = [DocumentAssistant sharedInstance];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[assitant.document.fileURL path]]) {
        [self.document saveToURL:assitant.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:block];
    } else if (assitant.document.documentState == UIDocumentStateClosed) {
        [assitant.document openWithCompletionHandler:block];
    } else {
        block(YES);
    }
    
}

- (void)saveDocument
{
    DocumentAssistant *assistant = [DocumentAssistant sharedInstance];
    [assistant.document saveToURL:assistant.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

@end
