//
//  HomeViewController.m
//  iOCR
//
//  Created by liqilei on 11/18/13.
//  Copyright (c) 2013 liqilei. All rights reserved.
//

#import "HomeViewController.h"
#import "CameraViewController.h"
#import "ImageEditViewController.h"
#import "ImageAdapter.h"
#import "share/Common.h"

@interface HomeViewController ()
@property (strong, nonatomic) CameraViewController* cameraView;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
@property (strong, nonatomic) ImageEditViewController* imageEditViewController;

//@property (nonatomic) ResultViewController* resultViewController;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self  && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
        self.ImageEditViewController = [[ImageEditViewController alloc] init];
        
        self.cameraView = [[CameraViewController alloc] init];
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.delegate = self;
        self.imagePicker.cameraOverlayView = self.cameraView.view;
        self.imagePicker.cameraOverlayView.layer.position = CGPointMake(160,240);
        self.imagePicker.showsCameraControls = NO;
        
        CGAffineTransform transform = self.imagePicker.cameraOverlayView.transform;
        transform = CGAffineTransformRotate(transform, (M_PI/2.0));
        self.imagePicker.cameraOverlayView.transform = transform;
        
        self.imagePicker.cameraViewTransform=CGAffineTransformTranslate(CGAffineTransformMakeScale(0.8958,0.8958), 0,-25);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhotoDone) name:@"MyTakePhoto" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CancelTakePhoto) name:@"Cancel" object:nil];
        //self.resultViewController = [[ResultViewController alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
   // NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
  // NSLog(@"%@",tessdataPath);
    
    setenv("TESSDATA_PREFIX", [[bundlePath stringByAppendingString:@"/"] UTF8String], 1);
    
    AppDelegate *userInfo=[[UIApplication sharedApplication]delegate];
    
    userInfo.kApplicationId=@"xwdOCR1991";
    userInfo.kPassowrd=@"fTRymVyPzHulG20wkU5tE64a";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)CancelTakePhoto
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)takePhoto:(id)sender {
    [self presentViewController:self.imagePicker animated:NO completion:nil];
    
    //[self presentViewController:self.resultViewController animated:NO completion:nil];
    //self.resultViewController.fpdm.text = @"ASFAFASFASF";

}

- (void) takePhotoDone
{
    [self.imagePicker takePicture];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        ImageAdapter *adapter = [[ImageAdapter alloc] init];
        self.imageEditViewController.cvImage = [adapter normalToIplImage: image];
        [self presentViewController:self.imageEditViewController animated:NO completion:nil];
    }];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)ManualEnter:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
     self.resultViewController = [[ResultViewController alloc] init];
    [self presentViewController:self.resultViewController animated:NO completion:nil];

    
}
- (IBAction)changeAccount:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    newAbbyyAcountViewController *abbyyAcount;
    abbyyAcount = [[newAbbyyAcountViewController alloc] init];
    [self presentViewController:abbyyAcount animated:NO completion:nil];
}
@end
