//
//  PhotosOfKindCDTVC.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PhotosOfKindCDTVC.h"
#import "Photo+Flickr.h"

@interface PhotosOfKindCDTVC ()

@end

@implementation PhotosOfKindCDTVC

- (void)setKind:(PhotoKind *)kind
{
    _kind = kind;
    self.title = [kind.name capitalizedString];
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    if (self.kind.managedObjectContext) {
        
        if ([self.kind.name isEqualToString:ALL_PHOTO_KIND_NAME]) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"kindsAsString" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
            fetchRequest.predicate = nil;
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.kind.managedObjectContext sectionNameKeyPath:@"kindsAsString" cacheName:nil];
                                             
        } else {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(kinds contains %@)", self.kind];
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.kind.managedObjectContext sectionNameKeyPath:@"alphabeticalSection" cacheName:nil];
        }

    } else {
        self.fetchedResultsController = nil;
    }
    
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
