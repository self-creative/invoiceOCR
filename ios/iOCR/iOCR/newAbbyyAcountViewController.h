//
//  newAbbyyAcountViewController.h
//  iOCR
//
//  Created by xwdmac on 14-3-25.
//  Copyright (c) 2014年 liqilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbbyyClient.h"
#import "AppDelegate.h"
@interface newAbbyyAcountViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *abbyyWebsite;
- (IBAction)backToHome:(id)sender;
- (IBAction)addNewAccount:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *abbyyUserID;
@property (strong, nonatomic) IBOutlet UITextField *abbyyPassword;

-(IBAction)textEnded:(id)sender;
-(IBAction)backGroundTap:(id)sender;
@end
