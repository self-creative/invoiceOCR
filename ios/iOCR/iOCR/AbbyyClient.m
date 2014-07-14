//
//  AbbyyClient.m
//  iOCR
//
//  Created by xwdmac on 14-3-8.
//  Copyright (c) 2014年 liqilei. All rights reserved.
//

#import "AbbyyClient.h"
#import "AppDelegate.h"

@implementation AbbyyClient

+ (instancetype)sharedClient
{
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSLog(@"ID:%@",appDelegate.kApplicationId);
    NSLog(@"PASSWORD:%@",appDelegate.kPassowrd);
    
	static AbbyyClient* sharedClient;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [[AbbyyClient alloc] initWithApplicationId:appDelegate.kApplicationId password:appDelegate.kPassowrd];
	});
	
	return sharedClient;
}

@end
