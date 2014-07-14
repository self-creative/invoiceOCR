//
//  newAbbyyAcountViewController.m
//  iOCR
//
//  Created by xwdmac on 14-3-25.
//  Copyright (c) 2014年 liqilei. All rights reserved.
//

#import "newAbbyyAcountViewController.h"

@interface newAbbyyAcountViewController ()

@end

@implementation newAbbyyAcountViewController

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
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *openWebSite=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickURL:)];
    self.abbyyWebsite.userInteractionEnabled=YES;
    [self.abbyyWebsite addGestureRecognizer:openWebSite];
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",appDelegate.kApplicationId);
    NSLog(@"%@",appDelegate.kPassowrd);
}
-(void)clickURL:(id)sender
{
    NSString* path=[NSString stringWithFormat:@"http://cloud.ocrsdk.com/Account/Login"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addNewAccount:(id)sender {
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    
    if((self.abbyyUserID.text.length+self.abbyyPassword.text.length)<20)
    {
        UIAlertView *errorInput=[[UIAlertView alloc]initWithTitle:@"错误" message:@"账号错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [errorInput show];
    }
    else{
        appDelegate.kApplicationId=self.abbyyUserID.text;
        appDelegate.kPassowrd=self.abbyyPassword.text;
        
         UIAlertView *ok=[[UIAlertView alloc]initWithTitle:@"成功" message:@"账号已添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [ok show];
    }
}
-(IBAction)textEnded:(id)sender
{
    
}
-(IBAction)backGroundTap:(id)sender
{
    [self.abbyyUserID resignFirstResponder];
    [self.abbyyPassword resignFirstResponder];
}
@end
