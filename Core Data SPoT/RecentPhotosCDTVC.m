//
//  RecentPhotosCDTVC.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 9/1/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "RecentPhotosCDTVC.h"
#import "DocumentAssistant.h"

@interface RecentPhotosCDTVC ()

@end

@implementation RecentPhotosCDTVC

#define NUMBER_OF_RECENT_PHOTOS 15;


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateAccessed" ascending:NO]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"dateAccessed != nil"];
        fetchRequest.fetchLimit = NUMBER_OF_RECENT_PHOTOS;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)useDocument
{
    DocumentAssistant *assistant = [DocumentAssistant sharedInstance];
    [assistant openDocumentWithBlock:^(BOOL success) {
        if (success) self.managedObjectContext = assistant.document.managedObjectContext;
    }];
    
}

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
    self.title = @"Recent Photos";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDocument];
}


@end
