//
//  SXLLocationDelegate.h
//  WeatherRequest
//
//  Created by didi on 2017/5/2.
//  Copyright © 2017年 didi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SXLLocationDelegate <NSObject>

- (void)receiveData:(id)data;
- (void)showLocationAlert;

@end
