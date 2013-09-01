//
//  PhotosCDTVC.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 9/1/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PhotosCDTVC.h"
#import "Photo.h"

@interface PhotosCDTVC ()

@end

@implementation PhotosCDTVC


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            photo.dateAccessed = [NSDate date];
            NSURL *url = [NSURL URLWithString:photo.imageURL];
            if ([segue.identifier isEqualToString:@"setImageURL"]) {
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                
            }
        }
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
