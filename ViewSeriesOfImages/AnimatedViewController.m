//
//  AnimatedViewController.m
//  ViewSeriesOfImages
//
//  Created by Budhathoki,Bipin on 3/1/15.
//  Copyright (c) 2015 Budhathoki,Bipin. All rights reserved.
//

#import "AnimatedViewController.h"

@interface AnimatedViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bugsImageView;
@property (nonatomic, strong) UIImageView *bugsImageView2;

@property (nonatomic, copy) NSArray *bugImages;
@property(nonatomic) int imageIndex;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation AnimatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bugImages = @[[UIImage imageNamed:@"image1.jpeg"],
                       [UIImage imageNamed:@"image2.jpeg"],
                       [UIImage imageNamed:@"image3.jpeg"],
                       [UIImage imageNamed:@"image4.jpeg"]
                       ];

    
    [self.bugsImageView setUserInteractionEnabled:YES];
    
     self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwiped:)];
    [self.bugsImageView addGestureRecognizer:self.panGestureRecognizer];
    
   
    
    [self showImage];
    
}

-(void)imageSwiped:(UIPanGestureRecognizer *)gestureRecognizer {
    static CGFloat currentImageWidth;
    
    static CGPoint originalCenter;
    static CGPoint originalCenter2;
    
    static BOOL isSwipeAble = true;
    
    static CGPoint velocity;
    static BOOL isRightSwipe;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat width = screenSize.width + 10;
    
    //get the velocity for direction
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        currentImageWidth = self.bugsImageView.bounds.size.width;;
        
        originalCenter = [gestureRecognizer view].center;
       
        
        velocity = [gestureRecognizer velocityInView:self.bugsImageView];
        NSLog(@"The velocity %f",velocity.x);
        if(velocity.x >= 0){
            originalCenter2 = CGPointMake(-originalCenter.x - 10, originalCenter.y);
            isRightSwipe = true;
        }
        else{
             originalCenter2 = CGPointMake(originalCenter.x + width, originalCenter.y);
            isRightSwipe = false;
        }
        
       
        if(isRightSwipe && self.imageIndex <= 0) {
            isSwipeAble = false;
        }
        else if(!isRightSwipe && self.imageIndex >= 3) {
            isSwipeAble = false;
        }
        
        else {
            isSwipeAble = true;
        }
        
        if(isSwipeAble) {

            self.bugsImageView2 = [[UIImageView alloc] initWithFrame:self.bugsImageView.frame];
            
            [self.bugsImageView2 setContentMode:UIViewContentModeScaleAspectFit];
            
            if(isRightSwipe) {
                self.imageIndex --;
            }
            else {
                self.imageIndex ++;
            }
        
            [self.bugsImageView2 setImage:self.bugImages[self.imageIndex]];
            [self.bugsImageView2 setCenter:originalCenter2];
            
            [self.view addSubview:self.bugsImageView2];
        }
        
        NSLog(@"The current index is %i",self.imageIndex);
        
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.bugsImageView];
        gestureRecognizer.view.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
        
        if (isSwipeAble) {
            self.bugsImageView2.center = CGPointMake(originalCenter2.x + translation.x, originalCenter2.y);
            
            //check for 60% width;
            int percentage = (translation.x * 100)/currentImageWidth;
            
            if(abs(percentage) > 60) {
                self.panGestureRecognizer.enabled = false;
                
                [UIView animateWithDuration:0.3 animations:^{
                    if(isRightSwipe) {
                        self.bugsImageView.center = CGPointMake(originalCenter.x+ width, originalCenter.y);
                    }
                    else {
                        self.bugsImageView.center = CGPointMake(-originalCenter.x, originalCenter.y);
                    }
                    self.bugsImageView2.center = originalCenter;
                   
                } completion:^(BOOL finished){
                    if(finished == YES) {
                        [self.bugsImageView setImage:self.bugsImageView2.image];
                        [self.bugsImageView setCenter:originalCenter];
                        [self.bugsImageView2 removeFromSuperview];
                        self.bugsImageView2 = nil;
                        [self.view bringSubviewToFront:self.bugsImageView];
                        self.panGestureRecognizer.enabled = YES;
                        
    

                }
                }];
        }
            
            
            
            //self.bugsImageView = self.bugsImageView2;
        }
        
        
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        //ended without suceess
        if(gestureRecognizer.enabled == YES) {
            [UIView animateWithDuration:0.3 animations:^{
                self.bugsImageView.center = originalCenter;
                self.bugsImageView2.center = originalCenter2;
            }];
            
            //rectify the count
            if(isSwipeAble & isRightSwipe) {
                self.imageIndex ++;
            }
            else if(isSwipeAble & !isRightSwipe) {
                self.imageIndex --;
            }
        }
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
    }
}

- (void)showImage {
    [self.bugsImageView setImage:(UIImage *)self.bugImages[self.imageIndex]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
