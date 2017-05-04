//
//  SxlLocationCity.h
//  WeatherRequest
//
//  Created by didi on 2017/5/2.
//  Copyright © 2017年 didi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "SXLLocationDelegate.h"

@interface SxlLocationCity : NSObject
@property (nonatomic,weak)  id <SXLLocationDelegate> delegate;
- (void)locate;           
+ (instancetype)sharedInstance;
@end
