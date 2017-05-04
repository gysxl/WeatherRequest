//
//  SXLBaseApi.h
//  WeatherRequest
//
//  Created by didi on 2017/5/3.
//  Copyright © 2017年 didi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "SXLBaseApiDelegate.h"

@interface SXLBaseApi : NSObject
@property (nonatomic,weak)  id <SXLBaseApiDelegate> delegate;
//@property (nonatomic,weak) ViewController *delegate;
-(void)transCitynameToCityid:(NSString *)cityname;

@end
