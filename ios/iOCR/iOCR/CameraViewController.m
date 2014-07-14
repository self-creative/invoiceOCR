//
//  CameraViewController.m
//  iOCR
//
//  Created by liqilei on 11/22/13.
//  Copyright (c) 2013 liqilei. All rights reserved.
//

#import "CameraViewController.h"
//#import "CaptureView.h"

@interface CameraViewController ()
//@property (strong,nonatomic) CaptureView* captureView;
@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.editView = [[ImageEdit alloc] initWithImageView:self.boxShow];
    [self.editView initPoints];
    [self.view addSubview:self.editView];
}

#pragma  mark xwd
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"MyTakePhoto" object:nil];
}

- (IBAction)cancelButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"Cancel" object:nil];
}
@end
