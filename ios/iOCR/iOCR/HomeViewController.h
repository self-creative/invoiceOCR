//
//  HomeViewController.h
//  iOCR
//
//  Created by liqilei on 11/18/13.
//  Copyright (c) 2013 liqilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewController.h"
#import "newAbbyyAcountViewController.h"
#import "AppDelegate.h"

@class AppDelegate;
@interface HomeViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)ManualEnter:(id)sender;
@property (nonatomic) ResultViewController* resultViewController;
- (IBAction)changeAccount:(id)sender;

@end
