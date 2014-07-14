//
//  ImageEditViewController.m
//  iOCR
//
//  Created by xwdmac on 13-12-29.
//  Copyright (c) 2013年 liqilei. All rights reserved.
//

#import "ImageEditViewController.h"

@interface ImageEditViewController ()

@end

@implementation ImageEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resultViewController = [[ResultViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _modeView=[[ImageView alloc] initWithImageView:self.modeImgShow];
    self.cropButton.hidden=YES;
    self.recButton.enabled=NO;
    self.selectModeButton.enabled=NO;
    _tesseractIsOpened=false;
    _findValueElement=false;
    _resultStrArray=[[NSMutableArray alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    ImageAdapter *adapter = [[ImageAdapter alloc] init];
    // self.imageShow.image = [adapter convertToUIImage: self.cvImage];
    
    [_imageShow setImage:[adapter convertToUIImage: self.cvImage]];
    //test image
}
//视图方向有关代码：
//要翻转的时候，首先响应的方法：
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    return NO;
}
//这个方法是发生在翻转开始之前。用来禁用某些控件或者停止某些正在进行的活动，
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}
//这个方法发生在翻转的过程中，用来定制翻转后各个控件的位置、大小等。可以用另外两个方法来代替：
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}
//这个方法发生在整个翻转完成之后。用来重新启用某些控件或者继续翻转之前被暂停的活动
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}
- (BOOL) shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cropImg:(id)sender {
    [_editView removeFromSuperview];
    
    ImageAdapter *adapter = [[ImageAdapter alloc] init];
    ImgProcess *cropProcess=[[ImgProcess alloc]init];
    [cropProcess setImg:_cvImage];
    [cropProcess CropedImg:_editView.getPoints];
    
    
    _cvImage=cvCloneImage(cropProcess.recImg);
    

    self.imageShow.image=[adapter convertToUIImage:_cvImage ];
    IplImage *  resizeImg=cvCreateImage(cvSize(1000,593),IPL_DEPTH_8U,3);
    cvResize(_cvImage,resizeImg,CV_INTER_LINEAR);
    _recImage=cvCloneImage(resizeImg);
    cvReleaseImage(&resizeImg);
    
    self.recButton.enabled=YES;
    self.selectModeButton.enabled=YES;
    self.auxButton.enabled=YES;
    self.cropButton.enabled=NO;
    
    [_modeView setMode:84];
    [self.view addSubview:_modeView];
    
}

- (IBAction)backToMain:(id)sender {
    self.cropButton.hidden=YES;
    self.recButton.enabled=NO;
    self.selectModeButton.enabled=NO;
    self.auxButton.enabled=YES;
    [_editView removeFromSuperview];
    [_modeView removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)recognizeInvoice:(id)sender {
    if (_tesseractIsOpened) {
        [self tesseractRun];
    }
    else
    {
        [self abbyyRun];
    }
}
-(void)tesseractRun
{
    [_editView removeFromSuperview];
    self.selectModeButton.enabled=NO;
    self.recButton.enabled=NO;
    self.cropButton.hidden=YES;
    self.backButton.enabled=NO;
    self.auxButton.enabled=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ActIndactor showWithStatus:@"识别中..."];
    });
    
    
    //识别
    int imageHeight = _recImage->height;
    CGFloat rate = (CGFloat)imageHeight / 255.0f;
    NSLog(@"%d",imageHeight);
    // init the tesseract engine.
    tesseract::TessBaseAPI* tesseract = new tesseract::TessBaseAPI();
    if(tesseract->Init(NULL, "chi_sim+eng"))
    {
        NSLog(@"Failed");
        return;
    }
    else
    {
        NSLog(@"OK");
    }
    
    tesseract->SetVariable("chop_enable", "T");
    tesseract->SetVariable("use_new_state_cost", "F");
    tesseract->SetVariable("segment_segcost_rating", "F");
    tesseract->SetVariable("enable_new_segsearch", "0");
    tesseract->SetVariable("language_model_ngram_on", "0");
    tesseract->SetVariable("textord_force_make_prop_words", "F");
    tesseract->SetImage((uchar*)_recImage->imageData, _recImage->width, _recImage->height, _recImage->nChannels, _recImage->widthStep);
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        
        __block NSString* fpdmStr;
        __block NSString* fphmStr;
        __block NSString* gsbhStr;
        __block NSString* xsbhStr;
        __block NSString* jeStr;
        __block NSString* seStr;
        __block NSString* kprqStr;
        __block NSString* mmStr;
        dispatch_group_t group=dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            tesseract->SetRectangle(_modeView.gsbhX * rate, _modeView.gsbhY * rate, _modeView.gsbhW * rate,  _modeView.gsbhH * rate);
            tesseract->SetVariable("tessedit_char_whitelist", "0123456789");
            //Boxa* boxes = tesseract->GetComponentImages(tesseract::RIL_WORD, true, NULL, NULL);
            char* gsbhUTF8 = tesseract->GetUTF8Text();
            gsbhStr = [NSString stringWithUTF8String: gsbhUTF8];
            gsbhStr = [gsbhStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            gsbhStr = [gsbhStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSLog(@"购货单位：%@", gsbhStr);
            NSLog(@"gouhuo:%f,%f",_modeView.gsbhX * rate,_modeView.gsbhY * rate);
            NSLog(@"%f,%f",_modeView.gsbhW * rate+_modeView.gsbhX* rate,_modeView.gsbhH * rate+_modeView.gsbhY * rate);
            
            tesseract->SetRectangle(_modeView.xsbhX * rate, _modeView.xsbhY * rate, _modeView.xsbhW * rate, _modeView.xsbhH * rate);
            tesseract->SetVariable("tessedit_char_whitelist", "0123456789");
            char* xsbhUTF8 = tesseract->GetUTF8Text();
            xsbhStr = [NSString stringWithUTF8String: xsbhUTF8];
            xsbhStr = [xsbhStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            xsbhStr = [xsbhStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSLog(@"销货单位：%@", xsbhStr);
            
            
            tesseract->SetRectangle(_modeView.fpdmX* rate, _modeView.fpdmY * rate,  _modeView.fpdmW * rate,  _modeView.fpdmH * rate);
            tesseract->SetVariable("tessedit_char_whitelist", "0123456789");
            char* fpdmUTF8 = tesseract->GetUTF8Text();
            fpdmStr = [NSString stringWithUTF8String: fpdmUTF8];
            fpdmStr = [fpdmStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            fpdmStr = [fpdmStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSLog(@"发票代码：%@", fpdmStr);
            
            
            tesseract->SetRectangle(_modeView.fphmX * rate, _modeView.fphmY * rate, _modeView.fphmW * rate, _modeView.fphmH * rate);
            tesseract->SetVariable("tessedit_char_whitelist", "0123456789");
            char* fphmUTF8 = tesseract->GetUTF8Text();
            fphmStr = [NSString stringWithUTF8String: fphmUTF8];
            fphmStr = [fphmStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            fphmStr = [fphmStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSLog(@"发票号码：%@", fphmStr);
            
            
            tesseract->SetRectangle(_modeView.kprqX * rate, _modeView.kprqY * rate,  _modeView.kprqW * rate, _modeView.kprqH * rate);
            NSString* whiteChars = @"年月日0123456789";
            tesseract->SetVariable("tessedit_char_whitelist", [whiteChars UTF8String]);
            char* kprqUTF8 = tesseract->GetUTF8Text();
            kprqStr = [NSString stringWithUTF8String: kprqUTF8];
            kprqStr = [kprqStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            kprqStr = [kprqStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSLog(@"开票日期：%@", kprqStr);
            
            
            tesseract->SetRectangle(_modeView.jeX * rate, _modeView.jeY * rate, _modeView.jeW * rate, _modeView.jeH * rate);
            whiteChars = @"￥0123456789.";
            tesseract->SetVariable("tessedit_char_whitelist", [whiteChars UTF8String]);
            char* jeUTF8 = tesseract->GetUTF8Text();
            jeStr = [NSString stringWithUTF8String: jeUTF8];
            jeStr = [jeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            jeStr = [jeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            jeStr = [jeStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
            NSLog(@"金额：%@", jeStr);
            
            
            tesseract->SetRectangle(_modeView.seX * rate, _modeView.seY * rate, _modeView.seW * rate, _modeView.seH * rate);
            whiteChars = @"¥0123456789.";
            tesseract->SetVariable("tessedit_char_whitelist", [whiteChars UTF8String]);
            char* seUTF8 = tesseract->GetUTF8Text();
            seStr = [NSString stringWithUTF8String: seUTF8];
            seStr = [seStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            seStr = [seStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            seStr = [seStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
            NSLog(@"税额：%@", seStr);
            NSLog(@"se:%f,%f",_modeView.seX * rate,_modeView.seY * rate);
            NSLog(@"se:%f,%f",_modeView.seW * rate+_modeView.seX* rate,_modeView.seH * rate+_modeView.seY * rate);
            
            tesseract->SetRectangle(_modeView.mmX * rate, _modeView.mmY * rate, _modeView.mmW * rate, _modeView.mmH * rate);
            tesseract->SetVariable("tessedit_char_whitelist", "0123456789+-*/<>");
            char* mmUTF8 = tesseract->GetUTF8Text();
            mmStr = [NSString stringWithUTF8String: mmUTF8];
            mmStr = [mmStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"密码：%@", mmStr);
            
        });
        dispatch_group_notify(group, queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ActIndactor dismiss];
                [self presentViewController:self.resultViewController animated:NO completion:nil];
                self.resultViewController.fpdm.text = fpdmStr;
                self.resultViewController.fphm.text = fphmStr;
                self.resultViewController.gsbh.text = gsbhStr;
                self.resultViewController.xsbh.text = xsbhStr;
                self.resultViewController.jine.text = jeStr;
                self.resultViewController.shuie.text = seStr;
                
                
                if(kprqStr.length >= 4)
                    self.resultViewController.year.text = [kprqStr substringWithRange: NSMakeRange(0, 4)];
                if(kprqStr.length >= 7)
                    self.resultViewController.month.text = [kprqStr substringWithRange: NSMakeRange(5, 2)];
                if(kprqStr.length >= 10)
                    self.resultViewController.day.text = [kprqStr substringWithRange: NSMakeRange(8, 2)];
                
                
                NSArray* mms = [mmStr componentsSeparatedByString:@"\n"];
                if(mms.count > 0)
                {
                    self.resultViewController.mm1.text = mms[0];
                }
                if(mms.count > 1)
                {
                    self.resultViewController.mm2.text = mms[1];
                }
                if(mms.count > 2)
                {
                    self.resultViewController.mm3.text = mms[2];
                }
                if(mms.count > 3)
                {
                    self.resultViewController.mm4.text = mms[3];
                }
                
                self.selectModeButton.enabled=YES;
                self.recButton.enabled=YES;
                self.cropButton.hidden=YES;
                self.backButton.enabled=YES;
                self.auxButton.enabled=YES;
            });
            
        });
    });
}

-(void)abbyyRun
{
    
    
    
    [_editView removeFromSuperview];
    self.selectModeButton.enabled=NO;
    self.recButton.enabled=NO;
    self.cropButton.hidden=YES;
    self.backButton.enabled=NO;
    self.auxButton.enabled=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ActIndactor showWithStatus:@"识别中..."];
    });
        
        [[AbbyyClient sharedClient] activateInstallationWithDeviceId:[[[UIDevice currentDevice] identifierForVendor] UUIDString] success:^{
            
            ImageAdapter *adapter = [[ImageAdapter alloc] init];
            UIImage *subImg=[adapter convertToUIImage: _recImage];
            
            NSData *imageData = UIImageJPEGRepresentation(subImg, 1);
            
            
            [[AbbyyClient sharedClient] submitImageData:imageData withParams:nil progressBlock:nil success:^(NSDictionary *taskInfo) {
                [self updateTaskStatus:[taskInfo objectForKey:OCRSDKTaskId]];
            } failure:^(NSError *error) {
                [self showError:error];
                [ActIndactor dismiss];
                self.selectModeButton.enabled=YES;
                self.recButton.enabled=YES;
                self.cropButton.hidden=YES;
                self.backButton.enabled=YES;
                self.auxButton.enabled=YES;
            }];
        } failure:^(NSError *error) {
            [self showError:error];
            [ActIndactor dismiss];
            self.selectModeButton.enabled=YES;
            self.recButton.enabled=YES;
            self.cropButton.hidden=YES;
            self.backButton.enabled=YES;
            self.auxButton.enabled=YES;
        } force:NO];
}
-(void) submitSetData:(NSString *)taskID
{
    NSString *xmlFileContents = [NSString
                                 stringWithContentsOfFile:[[NSBundle mainBundle]
                                                           pathForResource:@"set"
                                                           ofType:@"xml"]
                                 encoding:NSUTF8StringEncoding
                                 error:nil];
    int imageHeight = _recImage->height;
    CGFloat rate = (CGFloat)imageHeight / 255.0f;
    NSLog(@"abbyy rate%ld",(long)rate);
    //fpdm
    NSString *pos_fpdml=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.fpdmX*rate)];
    NSString *pos_fpdmt=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.fpdmY*rate)];
    NSString *pos_fpdmr=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.fpdmX+_modeView.fpdmW)*rate)];
    NSString *pos_fpdmb=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.fpdmY+_modeView.fpdmH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fpdml"] withString:pos_fpdml];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fpdmt"] withString:pos_fpdmt];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fpdmr"] withString:pos_fpdmr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fpdmb"] withString:pos_fpdmb];
    //ghdw
    
    NSString *pos_ghdwl=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.gsbhX*rate)];
    NSString *pos_ghdwt=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.gsbhY*rate)];
    NSString *pos_ghdwr=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.gsbhX+_modeView.gsbhW)*rate)];
    NSString *pos_ghdwb=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.gsbhY+_modeView.gsbhH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"ghdwl"] withString:pos_ghdwl];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"ghdwt"] withString:pos_ghdwt];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"ghdwr"] withString:pos_ghdwr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"ghdwb"] withString:pos_ghdwb];
    NSLog(@"ghdw:%f,%f,%f,%f",_modeView.gsbhX * rate,_modeView.gsbhY * rate,_modeView.gsbhW * rate+_modeView.gsbhX * rate,_modeView.gsbhH * rate+_modeView.gsbhY * rate);
    //xhdw
    NSString *pos_xhdwl=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.xsbhX*rate)];
    NSString *pos_xhdwt=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.xsbhY*rate)];
    NSString *pos_xhdwr=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.xsbhX+_modeView.xsbhW)*rate)];
    NSString *pos_xhdwb=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.xsbhY+_modeView.xsbhH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"xhdwl"] withString:pos_xhdwl];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"xhdwt"] withString:pos_xhdwt];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"xhdwr"] withString:pos_xhdwr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"xhdwb"] withString:pos_xhdwb];

    //fphm
    
    NSString *pos_fphml=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.fphmX*rate)];
    NSString *pos_fphmt=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.fphmY*rate)];
    NSString *pos_fphmr=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.fphmX+_modeView.fphmW)*rate)];
    NSString *pos_fphmb=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.fphmY+_modeView.fphmH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fphml"] withString:pos_fphml];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fphmt"] withString:pos_fphmt];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fphmr"] withString:pos_fphmr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"fphmb"] withString:pos_fphmb];
    //kprq
    NSString *pos_kprql=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.kprqX*rate)];
    NSString *pos_kprqt=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.kprqY*rate)];
    NSString *pos_kprqr=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.kprqX+_modeView.kprqW)*rate)];
    NSString *pos_kprqb=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.kprqY+_modeView.kprqH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"kprql"] withString:pos_kprql];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"kprqt"] withString:pos_kprqt];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"kprqr"] withString:pos_kprqr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"kprqb"] withString:pos_kprqb];

    //je
    
    NSString *pos_jel=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.jeX*rate)];
    NSString *pos_jet=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.jeY*rate)];
    NSString *pos_jer=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.jeX+_modeView.jeW)*rate)];
    NSString *pos_jeb=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.jeY+_modeView.jeH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"jel"] withString:pos_jel];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"jet"] withString:pos_jet];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"jer"] withString:pos_jer];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"jeb"] withString:pos_jeb];
    //se
    NSString *pos_sel=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.seX*rate)];
    NSString *pos_set=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.seY*rate)];
    NSString *pos_ser=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.seX+_modeView.seW)*rate)];
    NSString *pos_seb=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.seY+_modeView.seH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"sel"] withString:pos_sel];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"set"] withString:pos_set];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"ser"] withString:pos_ser];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"seb"] withString:pos_seb];
    //mmq1
    
    CGFloat perH=(_modeView.mmH/4.0);
    NSString *pos_mmql=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.mmX*rate)];
    NSString *pos_mmq1t=[[NSString alloc]initWithFormat:@"%d",(NSInteger)(_modeView.mmY*rate)];
    NSString *pos_mmqr=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.mmX+_modeView.mmW)*rate)];
    NSString *pos_mmq1b=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.mmY+perH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq1l"] withString:pos_mmql];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq1t"] withString:pos_mmq1t];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq1r"] withString:pos_mmqr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq1b"] withString:pos_mmq1b];
    //mmq2
    NSString *pos_mmq2t=pos_mmq1b;
    NSString *pos_mmq2b=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.mmY+2*perH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq2l"] withString:pos_mmql];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq2t"] withString:pos_mmq2t];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq2r"] withString:pos_mmqr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq2b"] withString:pos_mmq2b];
    //mmq3
    NSString *pos_mmq3t=pos_mmq2b;
    NSString *pos_mmq3b=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.mmY+3*perH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq3l"] withString:pos_mmql];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq3t"] withString:pos_mmq3t];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq3r"] withString:pos_mmqr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq3b"] withString:pos_mmq3b];
    //mmq4
    NSString *pos_mmq4t=pos_mmq3b;
    NSString *pos_mmq4b=[[NSString alloc]initWithFormat:@"%d",(NSInteger)((_modeView.mmY+4*perH)*rate)];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq4l"] withString:pos_mmql];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq4t"] withString:pos_mmq4t];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq4r"] withString:pos_mmqr];
    xmlFileContents=[xmlFileContents stringByReplacingCharactersInRange:[xmlFileContents rangeOfString:@"mmq4b"] withString:pos_mmq4b];
  //  NSLog(@"%@",xmlFileContents);
    
    
    NSData* setData = [xmlFileContents dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *processingParams = @{@"taskId": taskID};
    [[AbbyyClient sharedClient] startTaskWithImageData:setData withParams:processingParams progressBlock:nil success:^(NSDictionary *taskInfo) {
        [self updateTaskStatus:[taskInfo objectForKey:OCRSDKTaskId]];
    } failure:^(NSError *error) {
        [self showError:error];
        [ActIndactor dismiss];
        self.selectModeButton.enabled=YES;
        self.recButton.enabled=YES;
        self.cropButton.hidden=YES;
        self.backButton.enabled=YES;
        self.auxButton.enabled=YES;
    }];
}
- (void)updateTaskStatus:(NSString *)taskId
{
	[[AbbyyClient sharedClient] getTaskInfo:taskId success:^(NSDictionary *taskInfo) {
		NSString *status = [taskInfo objectForKey:OCRSDKTaskStatus];
		NSLog(@"s:%@",[taskInfo objectForKey:OCRSDKTaskId]);
        
		if ([status isEqualToString:OCRSDKTaskStatusCompleted]) {
			NSString *downloadURLString = [taskInfo objectForKey:OCRSDKTaskResultURL];
			
			[self downloadResult:[NSURL URLWithString:downloadURLString]];
		} else if ([status isEqualToString:OCRSDKTaskStatusProcessingFailed] || [status isEqualToString:OCRSDKTaskStatusNotEnoughCredits]) {
			NSError *error = [NSError errorWithDomain:@"abbyy.error" code:666 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Error processing image", @"Error processing image")}];
            
			[self showError:error];
            [ActIndactor dismiss];
            self.selectModeButton.enabled=YES;
            self.recButton.enabled=YES;
            self.cropButton.hidden=YES;
            self.backButton.enabled=YES;
            self.auxButton.enabled=YES;
		}
        else if ([status isEqualToString:OCRSDKTaskStatusSubmitted])
        {
            NSLog(@"submited");
            //NSLog(@"%@",[taskInfo objectForKey:OCRSDKTaskId]);
            [self submitSetData:[taskInfo objectForKey:OCRSDKTaskId]];
        }
        else {
			[self performSelector:@selector(updateTaskStatus:) withObject:taskId afterDelay:1.0];
		}
	} failure:^(NSError *error) {
		[self showError:error];
        [ActIndactor dismiss];
        self.selectModeButton.enabled=YES;
        self.recButton.enabled=YES;
        self.cropButton.hidden=YES;
        self.backButton.enabled=YES;
        self.auxButton.enabled=YES;
	}];
}

- (void)downloadResult:(NSURL *)url
{
    
    //  NSString *abbyyResult;
	[[AbbyyClient sharedClient] downloadRecognizedData:url success:^(NSData *downloadedData) {
        NSMutableString *abbyyResult=[[NSMutableString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",downloadedData);
        NSLog(@"%@",abbyyResult);
        
        NSRange Year=[abbyyResult rangeOfString:@"年"];
        NSRange month=[abbyyResult rangeOfString:@"月"];
        NSRange day=[abbyyResult rangeOfString:@"日"];
        NSRange empty=[abbyyResult rangeOfString:@"<value></value>"];
        NSRange specialSmall=[abbyyResult rangeOfString:@"&lt;"];
        NSRange specialBig=[abbyyResult rangeOfString:@"&gt;"];
        if (Year.location!=NSNotFound) {
            [abbyyResult replaceOccurrencesOfString:@"年" withString:@" " options:nil range:Year];
        }
        if (month.location!=NSNotFound) {
            [abbyyResult replaceOccurrencesOfString:@"月" withString:@" " options:nil range:month];
        }
        if (day.location!=NSNotFound) {
            [abbyyResult replaceOccurrencesOfString:@"日" withString:@" " options:nil range:day];
        }
        if (empty.location!=NSNotFound) {
            while (empty.location!=NSNotFound) {
                [abbyyResult replaceOccurrencesOfString:@"<value></value>" withString:@"<value>_</value>" options:nil range:empty];
                empty=[abbyyResult rangeOfString:@"<value></value>"];
            }
        }

        if (specialSmall.location!=NSNotFound) {
            while (specialSmall.location!=NSNotFound) {
                [abbyyResult replaceOccurrencesOfString:@"&lt;" withString:@"s" options:nil range:specialSmall];
                specialSmall=[abbyyResult rangeOfString:@"&lt;"];
            }
        }
        if (specialBig.location!=NSNotFound) {
            while (specialBig.location!=NSNotFound) {
                [abbyyResult replaceOccurrencesOfString:@"&gt;" withString:@"b" options:nil range:specialBig];
                specialBig=[abbyyResult rangeOfString:@"&gt;"];
            }
        }
        NSXMLParser *resultPaser=[[NSXMLParser alloc]initWithData:[abbyyResult dataUsingEncoding:NSUTF8StringEncoding]];
        
        [resultPaser setDelegate:self];
        [resultPaser parse];
        
        for (NSString *str in _resultStrArray) {
            NSLog(@"%@",str);
        }
        [ActIndactor dismiss];
        [self presentViewController:self.resultViewController animated:NO completion:nil];
        self.resultViewController.fpdm.text = _resultStrArray[0];
        self.resultViewController.fphm.text = _resultStrArray[1];
        self.resultViewController.gsbh.text = _resultStrArray[2];
        self.resultViewController.xsbh.text = _resultStrArray[3];
        
       
        NSString *jeStr=[_resultStrArray[5] substringFromIndex:1];
        NSString *seStr=[_resultStrArray[6] substringFromIndex:1];
    
        self.resultViewController.jine.text = jeStr;//_resultStrArray[5];
        self.resultViewController.shuie.text = seStr;//_resultStrArray[6];
        
        
        
        NSString *kprqStr=[[NSString alloc]initWithFormat:@"%@",_resultStrArray[4]];
        if(kprqStr.length >= 4)
            self.resultViewController.year.text = [kprqStr substringWithRange: NSMakeRange(0, 4)];
        if(kprqStr.length >= 7)
            self.resultViewController.month.text = [kprqStr substringWithRange: NSMakeRange(5, 2)];
        if(kprqStr.length >= 10)
            self.resultViewController.day.text = [kprqStr substringWithRange: NSMakeRange(8, 2)];
        
        NSMutableString *mmqStr[4];
       
        for (int i=7; i<=10; i++) {
            mmqStr[i-7]=[[NSMutableString alloc]initWithFormat:@"%@",_resultStrArray[i]];
            NSRange specialHYSmall=[mmqStr[i-7] rangeOfString:@"s"];
            NSRange specialHYBig=[mmqStr[i-7]  rangeOfString:@"b"];
            
            if (specialHYSmall.location!=NSNotFound) {
                while (specialHYSmall.location!=NSNotFound) {
                    [mmqStr[i-7] replaceOccurrencesOfString:@"s" withString:@"<" options:nil range:specialHYSmall];
                    specialHYSmall=[mmqStr[i-7] rangeOfString:@"s"];
                }
            }
            if (specialHYBig.location!=NSNotFound) {
                while (specialHYBig.location!=NSNotFound) {
                    [mmqStr[i-7] replaceOccurrencesOfString:@"b" withString:@">" options:nil range:specialHYBig];
                    specialHYBig=[mmqStr[i-7] rangeOfString:@"b"];
                }
            }
        }
        
        self.resultViewController.mm1.text =mmqStr[0];
        self.resultViewController.mm2.text = mmqStr[1];
        self.resultViewController.mm3.text =mmqStr[2];
        self.resultViewController.mm4.text = mmqStr[3];
        
        [_resultStrArray removeAllObjects];
        [ActIndactor dismiss];
        self.selectModeButton.enabled=YES;
        self.recButton.enabled=YES;
        self.cropButton.hidden=YES;
        self.backButton.enabled=YES;
        self.auxButton.enabled=YES;
    
        
	} failure:^(NSError *error) {
		[self showError:error];
        [ActIndactor dismiss];
        self.selectModeButton.enabled=YES;
        self.recButton.enabled=YES;
        self.cropButton.hidden=YES;
        self.backButton.enabled=YES;
        self.auxButton.enabled=YES;
	}];
}
#pragma mark - Parser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"value"]) {
        _findValueElement=true;
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_findValueElement) {
      //  NSLog(@"%@",string);
        [_resultStrArray addObject:string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    _findValueElement=false;
}


//end paser


- (void)showError:(NSError *)error
{
	if (error.code != NSURLErrorCancelled) {
		[self.alertView dismissWithClickedButtonIndex:-1 animated:YES];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
											  otherButtonTitles:nil];
		[alert show];
	}
}


- (IBAction)auxiliary:(id)sender {
    self.editView = [[ImageEdit alloc] initWithImageView:self.imageShow];
    [self.editView initPoints];
    [self.view addSubview:self.editView];
    
    self.cropButton.hidden=NO;
    self.cropButton.enabled=YES;
    self.auxButton.enabled=NO;
}

- (IBAction)setModeSwitch:(id)sender {
    UISwitch *currentSelcet=(UISwitch *)sender;
    if (currentSelcet.isOn) {
        NSLog(@"108");
        [_modeView setMode:108];
   }
    else
    {
        NSLog(@"84");
        [_modeView setMode:84];
    }
}

- (IBAction)setOcrSwitch:(id)sender {
    UISwitch *currenSelect=(UISwitch *)sender;
    if (currenSelect.isOn) {
        self.tesseractIsOpened=true;
    }
    else
    {
        self.tesseractIsOpened=false;
    }
}


@end
