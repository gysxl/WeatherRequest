//
//  CitySelectViewController.h
//  WeatherRequest
//
//  Created by sxl on 16/12/23.
//  Copyright © 2016年 didi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface CitySelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SXLLocationDelegate>
{
//    UITableView *tableview;
//    NSArray *array; //创建个数组来放我们的数据
//    NSArray *arrayImage;
//    NSString *httpUrl;
}
-(NSString *)transformToPinyin:(NSString *)cityname;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groupDatas;
@property (strong,nonatomic)NSArray *array;
@property (strong,nonatomic)NSArray *arrayImage;
@property (strong,nonatomic)NSString *httpUrl;
@property (nonatomic,weak) ViewController *delegate;
- (void)locate;


@end
