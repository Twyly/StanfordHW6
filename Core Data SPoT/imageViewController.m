//
//  imageViewController.m
//  SPoT
//
//  Created by Teddy Wyly on 8/22/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "imageViewController.h"
#import "NSDataCache.h"

@interface imageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation imageViewController



- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = title;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}


// Blocks finish after didlayoutsubviews- need to fix this

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;

        [self.spinner startAnimating];
        
        NSString *identifier = @"Test";
        if ([self.imageURL lastPathComponent]) identifier = [self.imageURL lastPathComponent];
        NSLog(@"identifier = %@\n", identifier);
        
        NSURL *imageURL = self.imageURL;
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            
            if ([[NSDataCache sharedInstance] dataInCacheForIdentifier:identifier]) {
                
                NSData *imageData = [[NSDataCache sharedInstance] dataInCacheForIdentifier:identifier];
                
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                if (self.imageURL == imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image) {
                            self.scrollView.zoomScale = 1.0;
                            self.scrollView.contentSize = image.size;
                            self.imageView.image = image;
                            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                            [self setAppropiateZoomScale];
                        }
                        [self.spinner stopAnimating];
                    });
                }
                
            } else {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // bad
                NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                [[NSDataCache sharedInstance] cacheData:imageData withIdentifier:identifier];                
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                if (self.imageURL == imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image) {
                            self.scrollView.zoomScale = 1.0;
                            self.scrollView.contentSize = image.size;
                            self.imageView.image = image;
                            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                            [self setAppropiateZoomScale];
                        }
                        [self.spinner stopAnimating];
                    });
                }
            }
        });
    }
}


#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setAppropiateZoomScale
{
    CGSize photoSize = self.imageView.bounds.size;
    float ratioX = photoSize.width / self.scrollView.bounds.size.width;
    float ratioY = photoSize.height / self.scrollView.bounds.size.height;
    float scaleFactor = 1.0 / MAX(ratioX, ratioY);
    [self.scrollView setZoomScale:scaleFactor animated:NO];
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
    if ([segue.identifier isEqualToString:@"Show Photo Popover"]) {
        NSLog(@"Segue");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    [self resetImage];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.titleBarButtonItem.title = self.title;
	
}

- (void)viewDidLayoutSubviews
{
    [self setAppropiateZoomScale];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
