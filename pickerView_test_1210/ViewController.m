//
//  ViewController.m
//  pickerView_test_1210
//
//  Created by wangchangyang on 15/12/10.
//  Copyright © 2015年 wangchangyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) UIPickerView *pickeVw;
@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, copy) NSMutableString *locationStr;
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *areaStr;

@property (nonatomic, assign) NSInteger stateIndex;
@property (nonatomic, assign) NSInteger cityIndex;
@property (nonatomic, assign) NSInteger areaIndex;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *areas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    
    _areas = areas;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [self.view addSubview:textField];
    _textField = textField;
    
    textField.placeholder = @"地区";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.center = CGPointMake(self.view.center.x, 100);
    
    UIPickerView *pickerVw = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    textField.inputView = pickerVw;
    
    pickerVw.backgroundColor = [UIColor blueColor];
    
    pickerVw.delegate = self;
    
    pickerVw.dataSource = self;
    
    UIView *assview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    assview.backgroundColor = [UIColor greenColor];
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * (self.view.bounds.size.width / 2.f), 0, self.view.bounds.size.width /2.f, 44)];
    
        btn.tag = i;
        
        [btn setTitle:[NSString stringWithFormat:@"%ld", i] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [assview addSubview:btn];
    }
    
    textField.inputAccessoryView = assview;
    
    _pickeVw = pickerVw;
}

- (void)btnTapped:(UIButton *)btn {
    
    [self.view endEditing:YES];
    
    if (btn.tag == 1) {

        
        _stateIndex = [_pickeVw selectedRowInComponent:0];
        
        if (_stateIndex >= _areas.count) {
            
            return;
        }
        
        NSDictionary *stateDict = _areas[_stateIndex];
        NSString *stateName = stateDict[@"state"];
        
        NSArray *cities = stateDict[@"cities"];
        
        _cityIndex = [_pickeVw selectedRowInComponent:1];
        
        if (_cityIndex >= cities.count) {
            
            return;
        }
        
        
        NSDictionary *cityDict = cities[_cityIndex];
        NSString *cityName = cityDict[@"city"];
        
        NSArray *areas = cityDict[@"areas"];
        
        NSString *areaName = nil;
        
        _areaIndex = [_pickeVw selectedRowInComponent:2];
        
        if (areas.count > 0) {
            
            if (_areaIndex >= areas.count) {
                
                return;
            }
            areaName = areas[_areaIndex];
        }
        
        _textField.text = [NSString stringWithFormat:@"%@ %@ %@", stateName, cityName, (areaName == nil ? @"":areaName)];
    }
}

#pragma mark - datasouce
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    

    if (component == 0) {
    // 省/直辖市
        
        NSArray *stateArr = _areas;
        return stateArr.count;
    
    } else if (component == 1) {
    // 市
        
        NSArray *stateArr = _areas;
        
        NSInteger stateIndex = [_pickeVw selectedRowInComponent:0];
        
        if (stateIndex >= stateArr.count) {
            
            return 0;
        }
        
        NSDictionary *state = stateArr[stateIndex];
        
        NSString *stateName = state[@"state"];
        
        NSArray *cities = state[@"cities"];
        
        return cities.count;
        
    } else {
    // 区

        NSArray *stateArr = _areas;
        
        NSInteger stateIndex = [_pickeVw selectedRowInComponent:0];
        
        if (stateIndex >= stateArr.count) {
            
            return 0;
        }
        
        NSDictionary *state = stateArr[stateIndex];
        NSString *stateName = state[@"state"];
        NSArray *cities = state[@"cities"];
        
        
        NSInteger cityIndex = [_pickeVw selectedRowInComponent:1];
        
        if (cityIndex >= cities.count) {
            
            return 0;
        }
        
        NSDictionary *city = cities[cityIndex];
        NSString *cityName = city[@"city"];

        NSArray *areas = city[@"areas"];
        
        return areas.count;
    }
}

#pragma mark - delegate
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
 
    return self.view.bounds.size.width / 3.f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 44;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    
    if (component == 0) {
        
        NSArray *areas = _areas;
        
        if (row >= areas.count) {
            
            return @"";
        }
        
        NSDictionary *state = areas[row];
        
        return  state[@"state"];
        
    } else if (component == 1) {

        NSArray *areas = _areas;
        
        NSInteger stateIndex = [_pickeVw selectedRowInComponent:0];
        
        if (stateIndex >= areas.count) {

            return @"";
        }
        
        NSDictionary *state = areas[stateIndex];
        
        NSArray *cities = state[@"cities"];
        
        if (row >= cities.count) {
            
            return @"";
        }
        
        NSDictionary *city = cities[row];
        
        return city[@"city"];
        
    }else {
        // 区
        
        NSArray *stateArr = _areas;
        
        NSInteger stateIndex = [_pickeVw selectedRowInComponent:0];
        
        if (stateIndex >= stateArr.count) {
            
            return @"";
        }
        
        NSDictionary *state = stateArr[stateIndex];
        NSString *stateName = state[@"state"];
        NSArray *cities = state[@"cities"];
        
        
        NSInteger cityIndex = [_pickeVw selectedRowInComponent:1];
        
        if (cityIndex >= cities.count) {
            
            return @"";
        }
        
        NSDictionary *city = cities[cityIndex];
        NSString *cityName = city[@"city"];
        
        
        NSArray *areas = city[@"areas"];
        
        if (row >= areas.count) {
            return @"";
        }
        
        NSString *areaName = areas[row];
        return areaName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        [_pickeVw reloadComponent:1];
        [_pickeVw reloadComponent:2];
        
    } else if (component == 1) {
        
        [_pickeVw reloadComponent:2];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
