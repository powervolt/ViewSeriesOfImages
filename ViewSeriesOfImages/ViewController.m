//
//  ViewController.m
//  ViewSeriesOfImages
//
//  Created by Budhathoki,Bipin on 2/28/15.
//  Copyright (c) 2015 Budhathoki,Bipin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *mainImagView;

@property (nonatomic ,copy) NSArray *bugImages;
@property (nonatomic) int imageIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bugImages = @[[UIImage imageNamed:@"image1.jpeg"],
                       [UIImage imageNamed:@"image2.jpeg"],
                       [UIImage imageNamed:@"image3.jpeg"],
                       [UIImage imageNamed:@"image4.jpeg"]
                       ];
    
    [self swipedRight:nil];
    
    [self.mainImagView setUserInteractionEnabled:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)swipedRight:(id)sender {
    if(self.imageIndex >= self.bugImages.count) {
        self.imageIndex = 0;
    }
    [self.mainImagView setImage:(UIImage *)self.bugImages[self.imageIndex]];
    _imageIndex++;
}

@end
