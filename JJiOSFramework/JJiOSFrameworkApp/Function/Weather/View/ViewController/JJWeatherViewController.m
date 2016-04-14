//
//  JJWeatherViewController.m
//  JJiOSFrameworkApp
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJWeatherViewController.h"

#import "JJWeatherPresenter.h"
#import "JJWeatherModel.h"

@interface JJWeatherViewController ()

@property (nonatomic, strong) JJWeatherPresenter *weatherPresenter;

@property (nonatomic, assign) NSInteger requestCount;

@end

@implementation JJWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPress:(id)sender {
    
    [self.weatherPresenter requestWeather:^(JJWeatherModel *weatherModel, NSString *responseString, id otherInfo){
        self.requestCount += 1;
        self.textLabel.text = [NSString stringWithFormat:@"%@  %ld", weatherModel.errMsg, self.requestCount];
    } networkFailResponse:^(NSError *error, id otherInfo) {
        self.textLabel.text = @"网络异常！";
    }];
}

- (JJWeatherPresenter *)weatherPresenter
{
    if (_weatherPresenter)
    {
        return _weatherPresenter;
    }
    
    _weatherPresenter = [[JJWeatherPresenter alloc] init];
    return _weatherPresenter;
}

@end
