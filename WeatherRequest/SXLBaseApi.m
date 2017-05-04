//
//  SXLBaseApi.m
//  WeatherRequest
//
//  Created by didi on 2017/5/3.
//  Copyright © 2017年 didi. All rights reserved.
//

#import "SXLBaseApi.h"

@interface SXLBaseApi()<NSURLSessionDelegate>

@property (nonatomic, retain) NSString *httpUrl;
@property (nonatomic, retain) NSString *cityInfoUrl;
@property (nonatomic, retain) NSString *openWeatherMapUrl;
@property (nonatomic, retain) NSString *forecastWeatherUrl;
@property (nonatomic, retain) NSString *queryPmInfoUrl;
@property (nonatomic, retain) NSString *responseByGet;
@property (nonatomic, retain) NSString *cityId;
@property (nonatomic, retain) NSString *cityPinyin;
@property (nonatomic, retain) NSMutableDictionary *weatherinfoDic;
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation SXLBaseApi

-(void)transCitynameToCityid:(NSString *)cityname{
    //城市名称转换为拼音
    self.httpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityid";
    self.cityInfoUrl = @"http://apis.baidu.com/apistore/weatherservice/cityinfo";
    self.openWeatherMapUrl = @"http://api.openweathermap.org/data/2.5/weather";
    self.forecastWeatherUrl = @"http://api.openweathermap.org/data/2.5/forecast/daily";
    self.queryPmInfoUrl = @"http://api.waqi.info/feed/";
    self.cityPinyin = [self transformToPinyin:cityname];
    self.cityPinyin = [self.cityPinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", self.cityPinyin);
    [self queryPmWithCityid:self.cityPinyin];
    
}

- (NSString *)transformToPinyin:(NSString *)cityname{
    NSMutableString *mutableString = [NSMutableString stringWithString:cityname];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

-(void)queryPmWithCityid:(NSString *)cityId{
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@%@/?token=%@",self.queryPmInfoUrl,cityId,@"b84a75d9513fd04387a75cc7e88406d07373cf55"];
    NSMutableURLRequest *resuest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [resuest setHTTPMethod:@"GET"];

    __weak typeof(self)weakSelf = self;
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:self.queue];
    NSURLSessionTask *task = [session dataTaskWithRequest:resuest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __weak typeof(self)strongSelf = weakSelf;
        //请求返回转换为dic
        NSError *dicError;
        NSDictionary *pmDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&dicError];
        NSString *pm25 = pmDictionary[@"data"][@"iaqi"][@"pm25"][@"v"];
        if (pm25 != NULL)
            [self.weatherinfoDic setObject:pm25 forKey:@"pm2.5"];
        [strongSelf requestWeatherWithCityid:self.cityPinyin];
        
//        [self.delegate receiveInfo:self.weatherinfoDic];
        
    }];
    [task resume];
    
}

-(void)requestWeatherWithCityid:(NSString *)cityid{
    //    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?q=%@&APPID=%@", openWeatherMapUrl, cityid,@"1050bedee1f19c5861ba89a1c122cae6"];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?q=%@&APPID=%@", self.forecastWeatherUrl, cityid,@"1050bedee1f19c5861ba89a1c122cae6"];
    NSMutableURLRequest *resuest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [resuest setHTTPMethod:@"GET"];
    
    //    NSData *tempData = [httpArg dataUsingEncoding:NSUTF8StringEncoding];
    //    [resuest setHTTPBody:tempData];
    //    [resuest addValue: @"1050bedee1f19c5861ba89a1c122cae6" forHTTPHeaderField: @"APPID"];
    
    __weak typeof(self)weakSelf = self;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:self.queue];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:resuest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __weak typeof(self)strongSelf = weakSelf;
        
        NSError *dicError;
        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&dicError];
        [self.weatherinfoDic addEntriesFromDictionary:dictionary];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate receiveInfo:self.weatherinfoDic];
        });
//        [self.delegate showWeatherInfo:responseByGet];
//
//        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    [task resume];
    
    
}

- (NSMutableDictionary *)weatherinfoDic {
    if (!_weatherinfoDic) {
        _weatherinfoDic = [NSMutableDictionary dictionary];
    }
    return _weatherinfoDic;
}

- (NSURLSession *)session {

    if (_session) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return _session;
}

- (NSOperationQueue *)queue {

    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}



@end
