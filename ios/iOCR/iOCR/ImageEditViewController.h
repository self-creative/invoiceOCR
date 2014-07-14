//
//  ImageEditViewController.h
//  iOCR
//
//  Created by xwdmac on 13-12-29.
//  Copyright (c) 2013年 liqilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import "ImageAdapter.h"
#import "ImageProcess.h"
#import "ImageEdit.h"
#import"TesseractOCR.h"
#import"ImageView.h"
#import "OCRMask.h"
#import "ResultViewController.h"
#import "ActIndactor.h"
#import "ImgProcess.h"
#import "AbbyyClient.h"
#import"XMLDictionary.h"
@interface ImageEditViewController : UIViewController<NSXMLParserDelegate>

@property IplImage* cvImage;
@property IplImage* recImage;
@property IplImage temptImage;
@property bool tesseractIsOpened;
@property (nonatomic) ResultViewController* resultViewController;
@property bool findValueElement;


@property NSMutableArray *resultStrArray;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *recButton;
@property (strong, nonatomic) IBOutlet UISwitch *selectModeButton;
@property (strong, nonatomic) IBOutlet UISwitch *selectOcrButton;
@property (strong, nonatomic) UIAlertView *alertView;


@property (strong, nonatomic) IBOutlet UIButton *cropButton;
@property (strong, nonatomic) IBOutlet UIButton *auxButton;

@property ImageView *modeView;
@property UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, strong) ImageEdit *editView;
@property (strong, nonatomic) IBOutlet UIImageView *modeImgShow;
@property (strong, nonatomic) IBOutlet UIImageView *imageShow;

- (IBAction)cropImg:(id)sender;
- (IBAction)backToMain:(id)sender;
- (IBAction)recognizeInvoice:(id)sender;
- (IBAction)auxiliary:(id)sender;
- (IBAction)setModeSwitch:(id)sender;
- (IBAction)setOcrSwitch:(id)sender;

@end
