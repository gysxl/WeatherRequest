//
//  ViewController.h
//  WeatherRequest
//
//  Created by didi on 16/12/22.
//  Copyright © 2016年 didi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SxlLocationCity.h"
#import "SXLLocationDelegate.h"

@interface ViewController : UIViewController <SXLLocationDelegate>
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UILabel *selectCityLabel;
@property (strong,nonatomic)NSString *weatherInfo;
@property (strong,nonatomic)NSString *cityName;
@property (strong,nonatomic)NSString *currentCity;
-(void)showWeatherInfo:(id)weatherInfo;
-(void)showLocationAlert;
@end

