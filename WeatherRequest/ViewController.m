//
//  ViewController.m
//  WeatherRequest
//
//  Created by sxl on 16/12/22.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "ViewController.h"
#import "CitySelectViewController.h"
#import "SXLCustomView.h"
#import "NSString+CSTExtention.h"
#import "SxlLocationCity.h"
#import "SXLBaseApi.h"
#import "SxlCollectionViewCell.h"

@interface ViewController ()<SXLBaseApiDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//@property (nonatomic,strong) UIButton *addCityButton;
@property (nonatomic,retain)UIImageView *bgImgView;
@property (nonatomic,retain)UIImageView *adviceImgView;
@property (nonatomic,retain)UILabel *tmpLable;
@property (nonatomic,retain)UILabel *weatherLable;
@property (nonatomic,retain)UILabel *adviceLable;
@property (nonatomic,retain)UILabel *speedLable;
@property (nonatomic,retain)UILabel *pressLable;
@property (nonatomic,retain)UILabel *pmLable;
@property (nonatomic,strong)UILabel *pmQualityLable;
@property (nonatomic,retain)NSDictionary *weatherInfoNow;
@property (nonatomic,retain)NSDictionary *weatherInfoDay1;
@property (nonatomic,retain)NSDictionary *weatherInfoDay2;
@property (nonatomic,retain)NSDictionary *weatherInfoDay3;
@property (nonatomic,retain)NSDictionary *weatherInfoDay4;
@property (nonatomic,retain)NSDictionary *weatherInfoDay5;
@property (nonatomic,retain)NSDictionary *weatherInfoDay6;
@property (nonatomic,retain)NSNumber *pmInfoStr;
@property (nonatomic,strong)NSString *pmQuality;
@property (nonatomic, strong) NSString *locationInfo;
@property (nonatomic, strong) UILabel *testLabel;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SxlLocationCity sharedInstance] locate];
    [SxlLocationCity sharedInstance].delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"天气预报";
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds))];
//    self.bgImgView.image = [UIImage imageNamed:@"bg.png"];
    self.view.backgroundColor = [UIColor clearColor];
    self.bgImgView.image = [UIImage imageNamed:@"clear.png"];
    
//    SXLCustomView *customView = [[SXLCustomView alloc]initWithFrame:CGRectMake(10, 200, 300,200)];
//    SXLCustomView *customView = [[SXLCustomView alloc]initWithFrame:CGRectMake(195, 45, 180,70)];
    self.adviceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-160, 70, 150, 50)];
//    self.adviceLable.text = @"请点击左上角按钮选择查看城市";
    self.adviceLable.text = [NSString stringWithFormat:@"中国  %@",self.currentCity];
    self.adviceLable.numberOfLines = 0;
    self.adviceLable.layer.cornerRadius = 20;
    self.adviceLable.layer.masksToBounds = YES;
    self.adviceLable.textAlignment = NSTextAlignmentCenter;
    self.adviceLable.textColor = [UIColor whiteColor];
    self.adviceLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.1];
    self.adviceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-190, 130, 180,180)];
    self.adviceImgView.image = [UIImage imageNamed:@"神乐.png"];
    [self.view addSubview:self.bgImgView];
//    [self.view addSubview:customView];
    [self.view addSubview:self.adviceLable];
    [self.view addSubview:self.adviceImgView];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    UIButton *selectCityButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    UIButton *selectCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectCityButton setFrame:CGRectMake(10, 10, 22, 22)];
    [selectCityButton setTitle:@"按钮" forState:UIControlStateNormal];
    [selectCityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectCityButton setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:selectCityButton];
    self.navigationItem.leftBarButtonItem = rightButton;
//    [self.view addSubview:selectCityButton];
    [selectCityButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
    self.tmpLable.textColor = [UIColor clearColor];
    self.tmpLable.font = [UIFont fontWithName:@"HelveticaNeue" size:40];
    
    self.weatherLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
    self.weatherLable.textColor = [UIColor clearColor];
    self.weatherLable.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    
    self.pressLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
    self.pressLable.textColor = [UIColor clearColor];
    self.pressLable.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    
    
    self.pmLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
    self.pmLable.textColor = [UIColor clearColor];
    self.pmLable.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    
    self.pmQualityLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
    self.pmQualityLable.textColor =[UIColor clearColor];
    self.pmQualityLable.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    
    self.speedLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
    self.speedLable.textColor = [UIColor clearColor];
    self.speedLable.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
//    self.pmLable.backgroundColor = [UIColor redColor];

    
    [self.view addSubview:self.tmpLable];
    [self.view addSubview:self.weatherLable];
    [self.view addSubview:self.pressLable];
    [self.view addSubview:self.pmLable];
    [self.view addSubview:self.speedLable];
    [self.view addSubview:self.pmQualityLable];
    
    
    //设置collectionview
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
    layout.itemSize =CGSizeMake(100, 300);
    
    //2.初始化collectionView
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-230,CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)*0.5) collectionViewLayout:layout];
    [self.view addSubview:self.mainCollectionView];
    
    self.mainCollectionView.backgroundColor = [UIColor clearColor];

    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.mainCollectionView registerClass:[SxlCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    
}


- (void)selectCity:(UIButton*)button{
    CitySelectViewController *citySelect = [[CitySelectViewController alloc] init];
    citySelect.delegate = self;
    [self.navigationController pushViewController:citySelect animated:YES];
}

//定位失败弹出提示框
-(void)showLocationAlert{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//show 选中查看城市的当天的天气信息
-(void)showWeatherInfo:(id)weatherInfo{
    
    NSDictionary *weatherInfoDic = weatherInfo;
    
    self.pmInfoStr = weatherInfoDic[@"pm2.5"];
    NSString *pmStr = [self.pmInfoStr stringValue];
    self.testLabel.text = pmStr;
    //获取空气质量分级描述
    if ([self.pmInfoStr intValue]<= 50 && [self.pmInfoStr intValue]>0){
        self.pmQuality = @"优";
    }else if ([self.pmInfoStr intValue] >50 && [self.pmInfoStr intValue] <=100){
        self.pmQuality = @"良好";
    }else if ([self.pmInfoStr intValue] >100 && [self.pmInfoStr intValue] <=200){
        self.pmQuality = @"轻度污染";
    }else if ([self.pmInfoStr intValue] >200 && [self.pmInfoStr intValue] <=300){
        self.pmQuality = @"中度污染";
    }else if ([self.pmInfoStr intValue] >300){
        self.pmQuality = @"重度污染";
    }
    self.pmQualityLable.text = self.pmQuality;
//    return ;
    
    if (self.cityName){
        self.adviceLable.text = [NSString stringWithFormat:@"中国  %@",self.cityName];
    }
    //获取每天的天气信息与当天的空气质量信息
    self.weatherInfoNow = [weatherInfoDic[@"list"] firstObject];
    self.weatherInfoDay1 = [weatherInfoDic[@"list"]objectAtIndex:1];
    self.weatherInfoDay2 = [weatherInfoDic[@"list"]objectAtIndex:2];
    self.weatherInfoDay3 = [weatherInfoDic[@"list"]objectAtIndex:3];
    self.weatherInfoDay4 = [weatherInfoDic[@"list"]objectAtIndex:4];
    self.weatherInfoDay5 = [weatherInfoDic[@"list"]objectAtIndex:5];
    self.weatherInfoDay6 = [weatherInfoDic[@"list"]objectAtIndex:6];
    self.pmInfoStr = weatherInfoDic[@"pm2.5"];
    //显示当天的天气信息
//    NSString *tmpString = [[[weatherInfoDic[@"list"] firstObject] objectForKey:@"temp"] objectForKey:@"day"];
    NSString *tmpString = self.weatherInfoNow[@"temp"][@"day"];
    NSString *weatherString = [[self.weatherInfoNow[@"weather"] firstObject] objectForKey:@"main"];
    //风速
    NSString *speedString = [self roundNumber:self.weatherInfoNow[@"speed"]];
    speedString = [NSString stringWithFormat:@"%@级",speedString];
    //大气压
    NSString *pressureString = [self roundNumber:self.weatherInfoNow[@"pressure"]];
    pressureString = [NSString stringWithFormat:@"%@hPa",pressureString];
    if ( [weatherString isEqualToString:@"Clear"] ){
        weatherString = @"晴";
    } else if ([weatherString isEqualToString:@"Clouds"]){
        weatherString = @"多云";
        self.bgImgView.image = [UIImage imageNamed:@"bg.png"];
    } else if ([weatherString isEqualToString:@"Rain"]){
        weatherString = @"雨";
        self.bgImgView.image = [UIImage imageNamed:@"rain.png"];
    } else if ([weatherString isEqualToString:@"Snow"]){
        weatherString = @"雪";
    }
    //天气显示
    CGRect rectWeather = [weatherString cst_rectWithFont:[UIFont fontWithName:@"HelveticaNeue" size:20] height:40];
    tmpString = [NSString stringWithFormat:@"%@",[self tranFctoOc:tmpString]];
    CGRect rectTmp = [tmpString cst_rectWithFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:100] height:120];
    CGRect rectSpeed = [speedString cst_rectWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] height:30];
    CGRect rectPress = [pressureString cst_rectWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] height:30];
    self.weatherLable.frame = CGRectMake(CGRectGetWidth(rectTmp)+ 50, 70, CGRectGetWidth(rectWeather), CGRectGetHeight(rectWeather));
    self.weatherLable.text = weatherString;
    self.weatherLable.textColor = [UIColor whiteColor];
    self.weatherLable.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
//    NSString *cityName = weatherInfoDic[@"name"];
    //温度显示
    self.tmpLable.frame = CGRectMake(10, CGRectGetHeight(self.view.bounds)*0.25-120, CGRectGetWidth(rectTmp)+ 40, CGRectGetHeight(rectTmp));
//    [self.tmpLable sizeToFit];
//    weatherLable.text = tmpString;
    self.tmpLable.text = [NSString stringWithFormat:@"%@°",tmpString];
    self.tmpLable.textColor = [UIColor whiteColor];
    self.tmpLable.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:100];

    //大气压
    self.pressLable.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds)*0.25, CGRectGetWidth(rectPress), CGRectGetHeight(rectPress));
    self.pressLable.text = pressureString;
    self.pressLable.textColor = [UIColor whiteColor];
    self.pressLable.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    //风速
    self.speedLable.frame = CGRectMake(CGRectGetWidth(rectPress)+30, CGRectGetHeight(self.view.bounds)*0.25, CGRectGetWidth(rectSpeed), CGRectGetHeight(rectSpeed));
    self.speedLable.text = speedString;
    self.speedLable.textColor = [UIColor whiteColor];
    self.speedLable.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    //空气质量
    if (self.pmInfoStr != nil){
        NSString *pmStr = [self.pmInfoStr stringValue];
        CGRect rectPmInfo = [pmStr cst_rectWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] height:40];
        
        self.pmLable.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds)*0.25+30, CGRectGetWidth(rectPmInfo)+20, CGRectGetHeight(rectPmInfo));
        self.pmLable.text = pmStr;
        self.pmLable.textColor = [UIColor whiteColor];
        self.pmLable.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
        //空气质量分级
        CGRect rectPmQuality = [self.pmQuality cst_rectWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] height:40];
        
        self.pmQualityLable.frame = CGRectMake(CGRectGetWidth(rectPmInfo)+40, CGRectGetHeight(self.view.bounds)*0.25+30, CGRectGetWidth(rectPmQuality)+20, CGRectGetHeight(rectPmQuality));
        self.pmQualityLable.text = self.pmQuality;
        self.pmQualityLable.textColor = [UIColor whiteColor];
        self.pmQualityLable.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
}

//华氏温度转换为摄氏度
-(NSString*)tranFctoOc:(NSString*)weatherString{
    double Fcweather = [weatherString floatValue];
    double OcWeather = Fcweather - 273.15;
    int tmp = (int)OcWeather;
    NSString *weatherString2 = [NSString stringWithFormat:@"%d", tmp];
    return weatherString2;
}


//小数点四舍
-(NSString*)roundNumber:(NSString*)number{
    float numberfloatString = [number floatValue];
    NSInteger numnerInt = ceil(numberfloatString);
    number = [NSString stringWithFormat:@"%ld",numnerInt];
    return number;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LocationDelegate

- (void)receiveData:(id)data {
   
    if ([self.locationInfo isEqualToString:data]) {
        return;
    }
    NSString *cityInfo = data;
    self.locationInfo = data;
//    self.pmLable.text = cityInfo;
    self.adviceLable.text = [NSString stringWithFormat:@"中国  %@",cityInfo];
    SXLBaseApi *baseApi = [SXLBaseApi new];
    baseApi.delegate = self;
    [baseApi transCitynameToCityid:cityInfo];
    
//    [self showWeatherInfo:@{@"pm2.5": @40}];
    
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SxlCollectionViewCell *cell = (SxlCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.botlabel.text = @"测试测试";
    cell.botlabel.textColor = [UIColor redColor];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 160);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    headerView.backgroundColor =[UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = @"未来六天天气情况";
    label.font = [UIFont systemFontOfSize:20];
    [headerView addSubview:label];
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SxlCollectionViewCell *cell = (SxlCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *msg = cell.botlabel.text;
    NSLog(@"%@",msg);
}




#pragma mark - SXLBaseApiDelegate

- (void)receiveInfo:(id)data {
    
    [self showWeatherInfo:data];
    //    [self.navigationController popViewControllerAnimated:YES];
    
    //    NSString *cityInfo = data;
    //    self.pmLable.text = cityInfo;
    //    self.adviceLable.text = [NSString stringWithFormat:@"中国  %@",cityInfo];
}

@end
