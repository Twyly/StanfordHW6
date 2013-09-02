//
//  StanfordCategoriesCDTVC.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "StanfordCategoriesCDTVC.h"
#import "PhotoKind.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "DocumentAssistant.h"

@interface StanfordCategoriesCDTVC ()


@end

@implementation StanfordCategoriesCDTVC


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PhotoKind"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        fetchRequest.predicate = nil;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoKind"];
    
    PhotoKind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [kind.name capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [kind.photos count]];
    
    return cell;
}

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo withContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"setPhotoKind"]) {
            PhotoKind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setKind:)]) {
                [segue.destinationViewController performSelector:@selector(setKind:) withObject:kind];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Stanford Photos";
	[self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (void)useDocument
{
    DocumentAssistant *assistant = [DocumentAssistant sharedInstance];
    [assistant openDocumentWithBlock:^(BOOL success) {
        if (success) {
            self.managedObjectContext = assistant.document.managedObjectContext;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.fetchedResultsController.fetchedObjects count] == 0) {
                [self refresh];
            }
        });
        
    }];
}

# pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
    return UIInterfaceOrientationIsPortrait(orientation);
}





@end
