//
//  addItemViewController.m
//  EA-WongHoYin
//
//  Created by Horace Wong on 8/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import "addItemViewController.h"

@interface addItemViewController (){
    UIDatePicker *datePicker;
    NSArray *itemArray;
    UIBarButtonItem *itemDoneBtn;
    
    NSString *textPrimaryKey;
    
    NSUserDefaults *db;
    
    int i;
}

@end

@implementation addItemViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _priceTextField.delegate = self;
    
    itemArray = @[@"Breakfast",@"Dinner",@"Snack",@"Daily Essentials",@"Social",@"Lunch",@"Drink",@"Transportation",@"Entertainment",@"Clothes",@"Shopping",@"Gift",@"Medical",@"Rent",@"Telephone Fee",@"Others"];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [_purchaseDateTextField setInputView:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [toolBar setTintColor:[UIColor darkGrayColor]];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    
    [toolBar setItems:[NSArray arrayWithObjects:doneBtn, nil]];
    
    [_purchaseDateTextField setInputAccessoryView:toolBar];
    
    
    
    _itemPicker = [[UIPickerView alloc]init];
    [_itemTextField setInputView:_itemPicker];
    _itemPicker.delegate = self;
    _itemPicker.dataSource = self;
    
    UIToolbar *itemToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [itemToolBar setTintColor:[UIColor darkGrayColor]];
    
    itemDoneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedItem)];
    
    [itemToolBar setItems:[NSArray arrayWithObjects:itemDoneBtn, nil]];
    
    [_itemTextField setInputAccessoryView:itemToolBar];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    db = [NSUserDefaults standardUserDefaults];
    _purchaseDateTextField.text = [db stringForKey:@"selected date"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)ShowSelectedDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    
    [formatter2 setDateFormat:@"dd-MMM-YYYY hh:mm:ss"];
    [formatter setDateFormat:@"dd-MMM-YYYY"];

    _purchaseDateTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
    
    textPrimaryKey = [NSString stringWithFormat:@"%@", [formatter2 stringFromDate:datePicker.date]];
    
    NSLog(@"%@", textPrimaryKey);
    
    
    [_purchaseDateTextField resignFirstResponder];
}

- (void)ShowSelectedItem{
    
    _itemTextField.text = itemArray[[_itemPicker selectedRowInComponent:0]];
    
    [_itemTextField resignFirstResponder];
    
    
}

-(void)dismissKeyboard {
    [_itemTextField resignFirstResponder];
    [_purchaseDateTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
    [_remarkTextField resignFirstResponder];
}

- (IBAction)saveBarBtn:(UIBarButtonItem *)sender {
    
    if ([_itemTextField.text isEqualToString:@""] || [_purchaseDateTextField.text isEqualToString:@""] || [_priceTextField.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"The item, date and spend should not be empty." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        
        [alert addAction:okAction];
        
        [self dismissKeyboard];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        //passing data when these textfield are not empty.
        
        db = [NSUserDefaults standardUserDefaults];
        i = [self valueI];
        
        NSString *theDate = _purchaseDateTextField.text;
        NSString *theItem = _itemTextField.text;
        NSString *theSpend = _priceTextField.text;
        NSString *theRemark = _remarkTextField.text;
        NSString *theIcon = [NSString stringWithFormat:@"%@.png",_itemTextField.text];
        
        NSString *keyForDate = [NSString stringWithFormat:@"date%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForItem = [NSString stringWithFormat:@"item%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForSpend = [NSString stringWithFormat:@"spend%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForRemark = [NSString stringWithFormat:@"remark%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForIcon = [NSString stringWithFormat:@"icon%d/%@", i, [db stringForKey:@"selected date"]];
        
        [db setObject:theDate forKey:keyForDate];
        [db setObject:theItem forKey:keyForItem];
        [db setObject:theSpend forKey:keyForSpend];
        [db setObject:theRemark forKey:keyForRemark];
        [db setObject:theIcon forKey:keyForIcon];
        
        i++;
        
        NSString *keyForNumberOfRecord = [self keyWithDate:@"number of record"];
        
        [db setInteger:i forKey:keyForNumberOfRecord];
        
        
        _purchaseDateTextField.text = @"";
        _itemTextField.text = @"";
        _priceTextField.text = @"";
        _remarkTextField.text = @"";
        
        
        [self dismissKeyboard];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBarBtn:(UIBarButtonItem *)sender {
    
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (int)valueI{
    
    db = [NSUserDefaults standardUserDefaults];
    
    NSString *keyForNumberOfRecord = [self keyWithDate:@"number of record"];
    
    if ([db objectForKey:keyForNumberOfRecord] == nil) {
        return 0;
    }else{
        return (int)[db integerForKey:keyForNumberOfRecord];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return itemArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return itemArray[row];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^[0-9]*((\\.|,)[0-9]{0,1})?$";
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    return numberOfMatches != 0;
}


-(NSString *) keyWithDate:(NSString*)name{
    
    NSString *keyForEvery = [NSString stringWithFormat:@"%@/%@",name, [db stringForKey:@"selected date"]];
    
    return keyForEvery;
}


@end
