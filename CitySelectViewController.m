//
//  CitySelectViewController.m
//  WeatherRequest
//
//  Created by didi on 16/12/23.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "CitySelectViewController.h"
#import "SXLBaseApi.h"

@interface CitySelectViewController ()<SXLBaseApiDelegate>

//@property (nonatomic,retain)NSString *pmInfoStr;
@end

@implementation CitySelectViewController

//NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityid";
//NSString *cityInfoUrl = @"http://apis.baidu.com/apistore/weatherservice/cityinfo";
//NSString *openWeatherMapUrl = @"http://api.openweathermap.org/data/2.5/weather";
//NSString *forecastWeatherUrl = @"http://api.openweathermap.org/data/2.5/forecast/daily";
//NSString *queryPmInfoUrl = @"http://api.waqi.info/feed/";
////NSString *httpArg = @"cityid=101010100";
//NSString *responseByGet;
//NSString *cityId;
//NSString *cityPinyin;
//NSMutableDictionary *weatherinfoDic;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = [[UIView alloc]init];
//    _tableView.backgroundColor = [UIColor clearColor];
//    weatherinfoDic = [NSMutableDictionary dictionary];
    [self.view addSubview:_tableView];
    NSArray *cityList = @[@"北京",@"上海",@"天津",@"杭州",@"武汉",@"南京",@"石家庄",@"深圳",@"广州",@"重庆",@"连云港"];
    
    NSMutableArray *arrayValue = [[NSMutableArray alloc]init];
    NSMutableArray *arrayImageValue = [[NSMutableArray alloc]init];
    NSInteger cityNumber = cityList.count;
    for (NSInteger i = 0; i< cityNumber; i++)
    {
        NSString *string = cityList[i];
        NSString *value = [NSString stringWithFormat:@"%@",string];
        NSString *imageName = [NSString stringWithFormat:@"image%ld.png",i];
        UIImage *image = [UIImage imageNamed:imageName];
        NSLog(@"imageName == %@",imageName);
        [arrayValue addObject:value];
        [arrayImageValue addObject:image];
    }
    self.array = arrayValue;
    self.arrayImage = arrayImageValue;
    [self loadGroupData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(!cell)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    cell.imageView.image = [self.arrayImage objectAtIndex:[indexPath row]];
    cell.textLabel.text = [self.array objectAtIndex:[indexPath row]];

    return cell;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableView.frame = CGRectMake(0,
                                  0,
                                  [UIScreen mainScreen].bounds.size.width,
                                  [UIScreen mainScreen].bounds.size.height);
}

//首个cell缩进10
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row ==0) {
//        return 10;
//    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = [self.array objectAtIndex:[indexPath row]];
    self.delegate.cityName = cityName;
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center=CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    activityView.color = [UIColor redColor];
    
    NSString *titileString =[NSString stringWithFormat:@"是否查看%@的天气",cityName];
    UIAlertController *alertview=[UIAlertController alertControllerWithTitle:@"提示" message:titileString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(self)weakSelf = self;
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        __weak typeof(self)strongSelf = weakSelf;
        NSLog(@"您点击了OK..");
    
        [activityView startAnimating];
        [strongSelf.view addSubview:activityView];
        strongSelf.delegate.selectCityLabel.text = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            SXLBaseApi *baseApi = [SXLBaseApi new];
            baseApi.delegate = self;
            [baseApi transCitynameToCityid:cityName];
        });
        
    }];
    [alertview addAction:cancel];
    [alertview addAction:defult];
    [self presentViewController:alertview animated:YES completion:nil];
}

//-(void)requestWeatherWithCityid:(NSString *)cityid{
////    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?q=%@&APPID=%@", openWeatherMapUrl, cityid,@"1050bedee1f19c5861ba89a1c122cae6"];
//    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?q=%@&APPID=%@", forecastWeatherUrl, cityid,@"1050bedee1f19c5861ba89a1c122cae6"];
//    NSMutableURLRequest *resuest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [resuest setHTTPMethod:@"GET"];
//    
//    //    NSData *tempData = [httpArg dataUsingEncoding:NSUTF8StringEncoding];
//    //    [resuest setHTTPBody:tempData];
////    [resuest addValue: @"1050bedee1f19c5861ba89a1c122cae6" forHTTPHeaderField: @"APPID"];
//    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    __weak typeof(self)weakSelf = self;
//    
//    NSURLSessionTask *task = [session dataTaskWithRequest:resuest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        __weak typeof(self)strongSelf = weakSelf;
//        
//        NSError *dicError;
//        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&dicError];
//        [weatherinfoDic addEntriesFromDictionary:dictionary];
//        NSData *data2 = [NSJSONSerialization dataWithJSONObject:weatherinfoDic options:NSJSONWritingPrettyPrinted error:nil];
//        responseByGet = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
//        
////        responseByGet = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        [strongSelf.delegate showWeatherInfo:responseByGet];
//
//        [strongSelf.navigationController popViewControllerAnimated:YES];
//    }];
//    [task resume];
//    
//    
//}

////获取选中城市的pm2.5
//-(void)queryPmWithCityid:(NSString *)cityId{
//    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@%@/?token=%@",queryPmInfoUrl,cityId,@"b84a75d9513fd04387a75cc7e88406d07373cf55"];
//    NSMutableURLRequest *resuest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [resuest setHTTPMethod:@"GET"];
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    __weak typeof(self)weakSelf = self;
//    NSURLSessionTask *task = [session dataTaskWithRequest:resuest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        __weak typeof(self)strongSelf = weakSelf;
//        //请求返回转换为dic
//        NSError *dicError;
//        NSDictionary *pmDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&dicError];
//        NSString *pm25 = pmDictionary[@"data"][@"iaqi"][@"pm25"][@"v"];
//        if (pm25 != NULL)
//            [weatherinfoDic setObject:pm25 forKey:@"pm2.5"];
//        [strongSelf requestWeatherWithCityid:cityPinyin];
////        
////        NSString *pmStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////        NSArray *pmInfoArr = [NSJSONSerialization JSONObjectWithData: [pmStr dataUsingEncoding:NSUTF8StringEncoding]
////                                                                       options: NSJSONReadingMutableContainers
////                                                                         error: &error];
////        NSInteger number = pmInfoArr.count;
////        if (number > 1){
////            NSDictionary *PMInfoDic = pmInfoArr[number-1];
////            [weatherinfoDic setObject:PMInfoDic forKey:@"pm2.5"];
////        }
////        [strongSelf requestWeatherWithCityid:cityPinyin];
//        
//    }];
//    [task resume];
//    
//}

//-(void)transCitynameToCityid:(NSString *)cityname{
//    //城市名称转换为拼音
//    cityPinyin = [self transformToPinyin:cityname];
//    cityPinyin = [cityPinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"%@", [self transformToPinyin:cityname]);
//    //将城市name转换为cityid
////    NSString *citynameUTF8 = [cityname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
////    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?cityname=%@",cityInfoUrl, citynameUTF8];
////    
////    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
////    [request addValue: @"d9c96d61fcf50b77a07f006c223251c7" forHTTPHeaderField: @"apikey"];
////    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
////    
////    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
////    __weak typeof(self)weakSelf = self;
////    
////    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////        __weak typeof(self)strongSelf = weakSelf;
////        if (data != nil){
////            NSDictionary *cityInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
////            cityId = cityInfo[@"retData"][@"cityCode"];
////            [strongSelf requestWeatherWithCityid:cityId];
////        }
////    }];
////    [task resume];
//     [self queryPmWithCityid:cityPinyin];
//    
//}
//
//- (NSString *)transformToPinyin:(NSString *)cityname{
//    NSMutableString *mutableString = [NSMutableString stringWithString:cityname];
//    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
//    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
//    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
//}

- (void)backToHome:(UIButton*)button{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadGroupData
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SXLBaseApiDelegate

- (void)receiveInfo:(id)data {
    
    [self.delegate showWeatherInfo:data];
    [self.navigationController popViewControllerAnimated:YES];
    
//    NSString *cityInfo = data;
    //    self.pmLable.text = cityInfo;
//    self.adviceLable.text = [NSString stringWithFormat:@"中国  %@",cityInfo];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
