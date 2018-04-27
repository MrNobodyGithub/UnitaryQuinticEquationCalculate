//
//  TestViewController.m
//  DRAMA
//
//  Created by CityMedia on 2018/4/27.
//  Copyright © 2018年 CityMedia. All rights reserved.
//
/**
  测试公式  x^5 + 10x^3 + 20x - 4 = 0
 
 精确度级别 耗时(/s)    比例         
 * 10^7  63.546081            0.196209
 * 10^6   6.154949   10.324   0.196209
 * 10^5   0.634656   9.698    0.196205
 * 10^4   0.070527   9        0.196250
 * 10^3   0.012508   5.8      0.196500
 * 10^2   0.005212   2.4      0.195000
 */
#import "TestViewController.h"
#define DefNumber_min -100
#define DefNumber_max 100
#define DefPrecision 10000
#import "CommonTool.h"

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField_x5;
@property (weak, nonatomic) IBOutlet UITextField *textField_x4;
@property (weak, nonatomic) IBOutlet UITextField *textField_x3;
@property (weak, nonatomic) IBOutlet UITextField *textField_x2;
@property (weak, nonatomic) IBOutlet UITextField *textField_x1;
@property (weak, nonatomic) IBOutlet UITextField *textField_x0;

@property (weak, nonatomic) IBOutlet UILabel *labLast;
@property (weak, nonatomic) IBOutlet UILabel *labTimeCon;

@end

@implementation TestViewController{
    NSTimeInterval flagTimeInterval;
}
- (void)baseConfiguration{
    self.labLast.numberOfLines = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
}
- (IBAction)btnActionBeginCal:(id)sender {
    NSDate * date = [NSDate date];
    NSTimeInterval  timeInt = [date timeIntervalSince1970];
    flagTimeInterval = timeInt;
    NSLog(@"-- -time begin %f---",flagTimeInterval);
    [self kShowLabCon];
    BOOL verify = [self veritifyAllInfoZero];
    if (verify) {
        [CommonTool AlertViewM:@"请录入数据"];
        return;
    }
    
    self.labLast.text = @"计算结果为:";
    NSMutableArray * mutArr5 = [self kxnWithNumber:self.textField_x5.text.floatValue WithN:5];
    NSMutableArray * mutArr4 = [self kxnWithNumber:self.textField_x4.text.floatValue WithN:4];
    NSMutableArray * mutArr3 = [self kxnWithNumber:self.textField_x3.text.floatValue WithN:3];
    NSMutableArray * mutArr2 = [self kxnWithNumber:self.textField_x2.text.floatValue WithN:2];
    NSMutableArray * mutArr1 = [self kxnWithNumber:self.textField_x1.text.floatValue WithN:1];
    NSMutableArray * mutArr = [NSMutableArray arrayWithCapacity:(DefNumber_max - DefNumber_min)];
    
    for (int i = 0; i<DefNumber_max - DefNumber_min; i++) {
        float floatNum = [mutArr1[i] floatValue] + [mutArr2[i] floatValue] + [mutArr3[i] floatValue] + [mutArr4[i] floatValue] + [mutArr5[i] floatValue];
        [mutArr addObject:@(floatNum)];
    }
    [self kFilterToUnitIntWithArr: mutArr];
}
- (void)kFilterMoreWithBegin:(double)begin andEnd:(double)end withGranularity:(NSInteger)gra{
    if (!gra || gra <= 0) {
        gra = DefPrecision;
    }
    NSMutableArray * mutArr5 = [self kDichotomyWith:begin andEnd:end withGranularity:0 withNumber:self.textField_x5.text.doubleValue withN:5];
    NSMutableArray * mutArr4 = [self kDichotomyWith:begin andEnd:end withGranularity:0 withNumber:self.textField_x4.text.doubleValue withN:4];
    NSMutableArray * mutArr3 = [self kDichotomyWith:begin andEnd:end withGranularity:0 withNumber:self.textField_x3.text.doubleValue withN:3];
    NSMutableArray * mutArr2 = [self kDichotomyWith:begin andEnd:end withGranularity:0 withNumber:self.textField_x2.text.doubleValue withN:2];
    NSMutableArray * mutArr1 = [self kDichotomyWith:begin andEnd:end withGranularity:0 withNumber:self.textField_x1.text.doubleValue withN:1];
    NSMutableArray * mutArr = [NSMutableArray arrayWithCapacity:gra];
    for (int i = 0; i<mutArr1.count; i++) {
        float floatNum = [mutArr1[i] doubleValue] + [mutArr2[i] doubleValue] + [mutArr3[i] doubleValue] + [mutArr4[i] doubleValue] + [mutArr5[i] doubleValue];
        [mutArr addObject:@(floatNum)];
    }
    [self kFilterToUnitDoubleWithArr:mutArr withBegin:begin];
    
}
- (void)kFilterToUnitDoubleWithArr:(NSMutableArray *)mutArr withBegin:(double)begin{
    NSLog(@"--- more -----每次计算分割线----- ---");
    double standNum = -self.textField_x0.text.doubleValue;
    int flag = 0;
    for (int i = 0; i<mutArr.count - 1; i++) {
        double start = [mutArr[i] floatValue];
        double next = [mutArr[i+1] floatValue];
        if (start < standNum && next > standNum) {
            flag = 0;
            NSLog(@"--- 趋势 + ---");
            NSLog(@"--- start: %f next: %f---",start,next);
            NSLog(@"index start: %d next: %d---",i,i+1);
            double bb = (double)(i) / mutArr.count  + begin;
            double bbEnd = (double)(i+1) / mutArr.count  + begin;
            NSLog(@"index_v start: %f next: %f---",bb,bbEnd);
            
            self.labLast.text = [self.labLast.text stringByAppendingString:@"x:"];
            self.labLast.text = [self.labLast.text stringByAppendingString:[NSString stringWithFormat:@"%f",(bb + bbEnd)/2]];
            self.labLast.text = [self.labLast.text stringByAppendingString:@" || "];
            
            [self kShowLabCon];
        }else if (start > standNum && next < standNum){
            flag = 0;
            NSLog(@"--- 趋势 - ---");
            NSLog(@"--- start: %f next: %f---",start,next);
            NSLog(@"index start: %d next: %d---",i,i+1);
 
            double bb = (double)(i) / mutArr.count  + begin;
            double bbEnd = (double)(i+1) / mutArr.count  + begin;
            
            NSLog(@"index_v start: %f next: %f---",bb,bbEnd);

            self.labLast.text = [self.labLast.text stringByAppendingString:@"x:"];
            self.labLast.text = [self.labLast.text stringByAppendingString:[NSString stringWithFormat:@"%f",(bb + bbEnd)/2]];
            self.labLast.text = [self.labLast.text stringByAppendingString:@" || "];
            [self kShowLabCon];
        }else if(start == standNum){
            flag = 0;
            NSLog(@"--- int find ---");
            NSLog(@"--- int find :%f ---",start);
            NSLog(@"index start: %d  ---",i );
            double bb = (double)(i) / mutArr.count  + begin;
            NSLog(@"index_v start: %f ---",bb);
            
            self.labLast.text = [self.labLast.text stringByAppendingString:@"\n"];
            self.labLast.text = [self.labLast.text stringByAppendingString:@"x:"];
            self.labLast.text = [self.labLast.text stringByAppendingString:[NSString stringWithFormat:@"%f",start]];
            [self kShowLabCon];
        }else{
            flag ++;
        }
    }
    if (flag == DefNumber_max - DefNumber_min - 1) {
        NSLog(@"--- 当前方程式 无值 ---");
        self.labLast.text = @"当前方程式 无值";
        [CommonTool AlertViewM:@"当前方程式 无值"];
    }
    
}
- (void)kFilterToUnitIntWithArr:(NSMutableArray *)mutArr{
    NSLog(@"--- -----每次计算分割线----- ---");
    float standNum = -self.textField_x0.text.floatValue;
    int flag = 0;
    for (int i = 0; i<DefNumber_max - DefNumber_min - 1; i++) {
        float start = [mutArr[i] floatValue];
        float next = [mutArr[i+1] floatValue];
        if (start < standNum && next > standNum) {
            flag = 0;
            NSLog(@"--- 趋势 + ---");
            NSLog(@"--- start: %f next: %f---",start,next);
            NSLog(@"index start: %d next: %d---",i+DefNumber_min,i+DefNumber_min+1);
            
            [self kFilterMoreWithBegin:i+DefNumber_min andEnd:i+DefNumber_min+1 withGranularity:0];
        }else if (start > standNum && next < standNum){
            flag = 0;
            NSLog(@"--- 趋势 - ---");
            NSLog(@"--- start: %f next: %f---",start,next);
            NSLog(@"index start: %d next: %d---",i+DefNumber_min,i+DefNumber_min+1);
            [self kFilterMoreWithBegin:i+DefNumber_min andEnd:i+DefNumber_min+1 withGranularity:0];
        }else if(start == standNum){
            flag = 0;
            NSLog(@"--- int find ---");
            NSLog(@"--- int find :%f ---",start);
            NSLog(@"index start: %d  ---",i+DefNumber_min );
            
            self.labLast.text = [self.labLast.text stringByAppendingString:@"x:"];
            self.labLast.text = [self.labLast.text stringByAppendingString:[NSString stringWithFormat:@"%d",i + DefNumber_min]];
            
            self.labLast.text = [self.labLast.text stringByAppendingString:@" || "];
 
            [self kShowLabCon];
            
        }else{
            flag ++;
        }
    }
    if (flag == DefNumber_max - DefNumber_min - 1) {
         NSLog(@"--- 当前方程式 无值 ---");
        self.labLast.text = @"当前方程式 无值";
        [CommonTool AlertViewM:@"当前方程式 无值"];
        
    }
    
}
// 二分法 精细化 Dichotomy granularity
- (NSMutableArray *)kDichotomyWith:(double)begin andEnd:(double)end withGranularity:(NSInteger)gra withNumber:(float)number withN:(NSInteger)n{
    if (!gra || gra <= 0) {
        gra = DefPrecision;
    }
    
    NSMutableArray * mutArr = [NSMutableArray array];
    double dif = (end - begin) / gra;
    for (int i = 0; i<gra; i++) {
        if (number == 0) {
            [mutArr addObject:@(0)];
        }else{
            double beginV = begin + i * dif;
            double powV = pow(beginV, n);
            double lastV = number * powV;
            [mutArr addObject:@(lastV)];
        }
     }
    
    return mutArr;
    
}

- (NSMutableArray *)kxnWithNumber:(float)number WithN:(NSInteger)n{
    if (!n) {
        n = 1;
    }
    if (n<=1) {
        n = 1;
    }
    NSMutableArray * mutArr = [NSMutableArray arrayWithCapacity:(DefNumber_max - DefNumber_min)];
    for (int i = DefNumber_min; i<DefNumber_max; i++) {
        if (number == 0) {
            [mutArr addObject:@(0)];
        }else{
            int xn = 1;
            for (int j = 0; j< n; j++) {
                xn *= i;
            }
            float last = number * xn;

            [mutArr addObject:@(last)];
        }
//        double pow(double x, double y）;计算以x为底数的y次幂
    }
    return mutArr;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (BOOL)veritifyAllInfoZero{
    if (self.textField_x0.text.length == 0) {
        self.textField_x0.text = @"0";
    }
    if (self.textField_x1.text.length == 0) {
        self.textField_x1.text = @"0";
    }
    if (self.textField_x2.text.length == 0) {
        self.textField_x2.text = @"0";
    }
    if (self.textField_x3.text.length == 0) {
        self.textField_x3.text = @"0";
    }
    if (self.textField_x4.text.length == 0) {
        self.textField_x4.text = @"0";
    }
    if (self.textField_x5.text.length == 0) {
        self.textField_x5.text = @"0";
    }
    
    if ([self.textField_x0.text isEqualToString:@"0"] && [self.textField_x1.text isEqualToString:@"0"] && [self.textField_x2.text isEqualToString:@"0"] && [self.textField_x3.text isEqualToString:@"0"] && [self.textField_x4.text isEqualToString:@"0"] && [self.textField_x5.text isEqualToString:@"0"] ) {
        return YES;
        
    }
    return NO;
}

- (void)kShowLabCon{
    NSDate * date = [NSDate date];
    NSTimeInterval  timeInt = [date timeIntervalSince1970];
    NSLog(@"--- data %@ %f ---",date, timeInt);
    NSTimeInterval dif = flagTimeInterval - timeInt;
    NSString * str = @"耗时:";
    self.labTimeCon.text = [str stringByAppendingString:[NSString stringWithFormat:@"%f s",-dif]];
}
@end
