//
//  SXLBaseApiDelegate.h
//  WeatherRequest
//
//  Created by didi on 2017/5/3.
//  Copyright © 2017年 didi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SXLBaseApiDelegate <NSObject>
- (void)receiveInfo:(id)data;
@end
