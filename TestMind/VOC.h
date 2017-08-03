//
//  VOC.h
//  VOC
//
//  Created by gaypin on 2015/11/2.
//  Copyright © 2015年 gaypin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
typedef void(^VocPremissionResult)(BOOL success); //api CallBack function

@interface VOC : NSObject
+(VOC*)InitSDKWithSN:(NSString*)sn;
+(VOC*)InitSDKWithSN:(NSString*)sn Sex:(int) sex;

-(void)VOCstart;
-(void)VOCstop;
-(void)reset;

-(void)setPropKey:(NSString*)key andValue:(NSString*)value;
-(void)updateData;
-(void)clearData;

-(void)checkVocPremission:(VocPremissionResult)vocPremissionResult showAlert:(BOOL)isShow;


@end
