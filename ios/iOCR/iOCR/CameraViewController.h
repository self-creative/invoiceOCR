//
//  CameraViewController.h
//  iOCR
//
//  Created by liqilei on 11/22/13.
//  Copyright (c) 2013 liqilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageEdit.h"
@interface CameraViewController : UIViewController
- (IBAction)cancelButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *boxShow;
@property (nonatomic, strong) ImageEdit *editView;
@end
