//
//  CommonTool.m
//  DRAMA
//
//  Created by CityMedia on 2018/4/27.
//  Copyright © 2018年 CityMedia. All rights reserved.
//

#import "CommonTool.h"
#import <UIKit/UIKit.h>


@implementation CommonTool
+ (void)AlertViewM:(NSString *)message{ 
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alertView show];
}
@end
