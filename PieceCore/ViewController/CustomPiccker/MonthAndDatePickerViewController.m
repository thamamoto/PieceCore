//
//  MonthAndDatePickerViewController.m
//  piece
//
//  Created by ハマモト  on 2014/10/14.
//  Copyright (c) 2014年 ハマモト . All rights reserved.
//

#import "MonthAndDatePickerViewController.h"

@interface MonthAndDatePickerViewController ()

@end

@implementation MonthAndDatePickerViewController

- (void)loadView {
    [[NSBundle mainBundle] loadNibNamed:@"MonthAndDatePickerViewController" owner:self options:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *strMonth = @"";
    NSString *strDay = @"";
    int initMonth = 1;
    int initDay = 1;
    if (self.strDate.length > 0) {
        self.strDate =[self.strDate stringByReplacingOccurrencesOfString:@"月" withString:@"/"];
        self.strDate =[self.strDate stringByReplacingOccurrencesOfString:@"日" withString:@"/"];
        strMonth = [[self.strDate componentsSeparatedByString:@"/"] objectAtIndex:0];
        strDay = [[self.strDate componentsSeparatedByString:@"/"] objectAtIndex:1];
    } else {
        NSString *format = @"yyyy/MM/dd";
        NSString *md =[Common dateToString:[NSDate date] formatString:format];
        strMonth = [[md componentsSeparatedByString:@"/"] objectAtIndex:1];
        strDay = [[md componentsSeparatedByString:@"/"] objectAtIndex:2];
    }
    self.pickerView.delegate = self;
    self.monthList = [[NSMutableArray alloc] initWithCapacity:12];
    self.dayList = [[NSMutableArray alloc] initWithCapacity:31];
    for (int i = 1; i <= 12; i++) {
        [self.monthList addObject:[NSString stringWithFormat:@"%d月", i]];
        if (i == strMonth.intValue) {
            initMonth = i;
        }
        
    }
    for (int i = 1; i <= 31; i++) {
        [self.dayList addObject:[NSString stringWithFormat:@"%d日", i]];
        if (i == strDay.intValue) {
            initDay = i;
        }
    }
    [self.pickerView selectRow:initMonth -1 inComponent:0 animated:NO];
    [self.pickerView selectRow:initDay -1 inComponent:1 animated:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self.delegate didCancelButtonClicked:self];
}

- (IBAction)doneAction:(id)sender {
    int month = [self.pickerView selectedRowInComponent:0];
    int day = [self.pickerView selectedRowInComponent:1];
    
    [self.delegate didCommitButtonClicked:self selectDate:[NSString stringWithFormat:@"%d月%d日",month + 1,day + 1]];

}

# pragma mark UIPIkerView's Delegate
// 列(component)の数を返す
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // 年と月を表示するので2列を指定
    return 2;
}

// 列(component)に対する、行(row)の数を返す
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.monthList count];
        case 1: // 月(2列目)の場合
            return [self.dayList count];
    }
    return 0;
}

// 列(component)と行(row)に対応する文字列を返す
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: //
            return [self.monthList objectAtIndex:row];
        case 1:
            return [self.dayList objectAtIndex:row];    }
    return nil;
}

@end
