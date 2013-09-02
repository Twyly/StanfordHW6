//
//  PhotosCDTVC.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 9/1/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PhotosCDTVC.h"
#import "Photo.h"
#import "DocumentAssistant.h"
#import "ImageViewController.h"

@interface PhotosCDTVC ()

@end

@implementation PhotosCDTVC

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [photo.title capitalizedString];
    cell.detailTextLabel.text = photo.subtitle;
    
    
    NSData *imageData = photo.squareImageData;
    NSURL *thumbnailURL = [NSURL URLWithString:photo.squareImageURL];
    
    if (imageData) {
        cell.imageView.image = [UIImage imageWithData:imageData];
    } else {
        dispatch_queue_t thumbnailQ = dispatch_queue_create("thumbnail image", NULL);
        dispatch_async(thumbnailQ, ^{
            NSData *newImageData = [NSData dataWithContentsOfURL:thumbnailURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [photo.managedObjectContext performBlock:^{
                    photo.squareImageData = newImageData;
                }];
                cell.imageView.image = [UIImage imageWithData:newImageData];
                [cell setNeedsLayout];
            });;
        });
    }
    
    return cell;
}

//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        [photo.managedObjectContext performBlock:^{
//            photo.deleted = [NSNumber numberWithBool:YES];
//        }];
//    }
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            photo.dateAccessed = [NSDate date];
            [[DocumentAssistant sharedInstance] saveDocument];
            NSURL *url = [NSURL URLWithString:photo.imageURL];
            if ([segue.identifier isEqualToString:@"setImageURL"]) {
                if ([self splitViewDetailWithBarButtonItem]) {
                    [self transferSplitViewBarButtonItemToViewController:segue.destinationViewController];
                }
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                
            }
        }
    }
}

#pragma mark - life cycle methods

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


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}


# pragma mark - UISplitViewControllerDelegate

// The delegate must be set in awakefromnib as this view is first loaded in a UITabbarcontroller, and viewdidload has not been called

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Photos";
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:nil];
}

- (id)splitViewDetailWithBarButtonItem
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if (![detail respondsToSelector:@selector(setSplitViewBarButtonItem:)] ||
        ![detail respondsToSelector:@selector(splitViewBarButtonItem)]) detail = nil;
    return detail;
}

- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController
{
    UIBarButtonItem *splitViewBarButtonItem = [[self splitViewDetailWithBarButtonItem] splitViewBarButtonItem];
    [[self splitViewDetailWithBarButtonItem] setSplitViewBarButtonItem:nil];
    if (splitViewBarButtonItem) {
        [destinationViewController setSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

@end
