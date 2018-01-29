//
//  DTRevenueStaticticsViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRevenueStaticticsViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "PopoverView.h"
#import "DTStatisticsModel.h"

@interface DTRevenueStaticticsViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@property (strong, nonatomic) NSMutableArray *values;
@property (strong, nonatomic) NSMutableArray *dates;

@property (assign, nonatomic) BOOL isWeek;

@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPaybackLabel;

@property (weak, nonatomic) IBOutlet UIButton *changeDataBtn;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;


@end

@implementation DTRevenueStaticticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.values = [NSMutableArray new];
    self.dates = [NSMutableArray new];
    self.arrayOfDates = [NSMutableArray new];
    self.arrayOfValues = [NSMutableArray new];
    
    self.navigationItem.title = @"营收统计";
    self.changeDataBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.changeDataBtn.layer.borderWidth = 1;
    
    self.isWeek = true;
    self.graphView.enableTouchReport = YES;
    self.graphView.enablePopUpReport = YES;
    self.graphView.enableYAxisLabel = false;
    self.graphView.autoScaleYAxis = YES;
    self.graphView.alwaysDisplayDots = YES;
    self.graphView.alwaysDisplayPopUpLabels = YES;
    self.graphView.enableReferenceXAxisLines = false;
    self.graphView.enableReferenceYAxisLines = false;
    self.graphView.enableReferenceAxisFrame = YES;
    self.graphView.enableBezierCurve = true;
    self.graphView.colorBottom = [UIColor whiteColor];
    
    // Draw an average line
    self.graphView.averageLine.enableAverageLine = false;
    self.graphView.averageLine.alpha = 0.6;
    self.graphView.averageLine.color = [UIColor darkGrayColor];
    self.graphView.averageLine.width = 2.5;
    self.graphView.averageLine.dashPattern = @[@(2),@(2)];
    
    
    CGColorSpaceRef spaceRef = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.9,0.8,0.7,1, 0.95,0.55,0.55,1, 0.9,0.1,0.2,1};
    CGFloat locations[] = {0.0, 0.6, 1.0};
    CGGradientRef gradeRef = CGGradientCreateWithColorComponents(spaceRef,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    
    self.graphView.gradientBottom = gradeRef;
    
//    self.arrayOfValues = @[@"22", @"33", @"55", @"44", @"33", @"88", @"11"];
//    self.arrayOfDates = @[@"\r\n一\r\n", @"\r\n二\r\n", @"\r\n三\r\n", @"\r\n四\r\n", @"\r\n五\r\n", @"\r\n六\r\n", @"\r\n日\r\n"];
//
//    self.values = @[@"22", @"33", @"55", @"44", @"33", @"88", @"11", @"33", @"55", @"44", @"33", @"88", @"11"];
//    self.dates = @[@"\r\n1\r\n", @"\r\n2\r\n", @"\r\n3\r\n", @"\r\n4\r\n", @"\r\n5\r\n", @"\r\n6\r\n", @"\r\n7\r\n", @"\r\n2\r\n", @"\r\n3\r\n", @"\r\n4\r\n", @"\r\n5\r\n", @"\r\n6\r\n", @"\r\n7\r\n"];
    
    [self loadOrderAmount];
    [self loadStatisticsWeekends:true];
    [self loadStatisticsWeekends:false];
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    
    NSString *label = nil;
    
    if (_isWeek) {
        label = self.arrayOfDates[index];
    } else {
        label = self.dates[index];
    }
    return label;
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    if (_isWeek) {
        return self.arrayOfValues.count;
    } else {
        return self.values.count;
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (_isWeek) {
        return [self.arrayOfValues[index] floatValue];
    } else {
        return [self.values[index] floatValue];
    }
    
}


- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {

}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

    } completion:^(BOOL finished) {

    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {

}

/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @" 元";
}

- (IBAction)touchResetDataBtn:(id)sender {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"周视图" handler:^(PopoverAction *action) {
        self.isWeek = true;
        [self.graphView reloadGraph];
    }];
    
    PopoverAction *action2 = [PopoverAction actionWithTitle:@"月视图" handler:^(PopoverAction *action) {
        self.isWeek = false;
        [self.graphView reloadGraph];
    }];
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleRed;
    [popoverView showToView:sender withActions:@[action1, action2]];
}

#pragma mark - Data Request

- (void)loadStatisticsWeekends:(BOOL)isWeekends {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (isWeekends) {
        [params setValue:@"1" forKey:@"type"];
    } else {
        [params setValue:@"2" forKey:@"type"];
    }
    
    // FIXME: 排查数据异常问题
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:storeWorkOrNot] headParams:@{@"token": [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            DTStatisticsCollectionModel *collectionModel = [DTStatisticsCollectionModel mj_objectWithKeyValues:responseObject];
            if (isWeekends) {
                for (DTStatisticsModel *model in collectionModel.data) {
                    
                    [self.arrayOfDates addObject:[NSString stringWithFormat:@"\r\n%@\r\n", model.time]];
                    [self.arrayOfValues addObject:model.income];
                }
            } else {
                for (DTStatisticsModel *model in collectionModel.data) {
                    [self.dates addObject:[NSString stringWithFormat:@"\r\n%@\r\n", model.time]];
                    [self.values addObject:model.income];
                }
            }
            
            if (self.values.count == 0) {
                self.noDataLabel.hidden = false;
            } else {
                self.noDataLabel.hidden = true;
            }
            
            [self.graphView reloadGraph];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)loadOrderAmount {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:storeTotalOrderInfo] headParams:@{@"token": [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([responseObject[@"status"] integerValue] == 1) {
            self.orderCountLabel.text = [NSString stringWithFormat:@"%zd", [responseObject[@"data"][@"num"] integerValue]];
            self.allIncomeLabel.text = [NSString stringWithFormat:@"￥ %zd", [responseObject[@"data"][@"price"] integerValue]];
            self.allPaybackLabel.text = [NSString stringWithFormat:@"￥ %@", responseObject[@"data"][@"sendPrice"]];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
