//
//  CitySelectViewController.m
//  WeatherRequest
//
//  Created by sxl on 16/12/23.
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
