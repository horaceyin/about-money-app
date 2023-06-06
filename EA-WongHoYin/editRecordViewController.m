//
//  editRecordViewController.m
//  EA-WongHoYin
//
//  Created by Horace Wong on 13/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import "editRecordViewController.h"
#import "showRecordViewController.h"

@interface editRecordViewController (){
    NSUserDefaults *db;
    NSArray *itemArray;
    UIBarButtonItem *itemDoneBtn;
}

@end

@implementation editRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _editableSpendTextField.delegate = self;
    
    db = [NSUserDefaults standardUserDefaults];
    
    itemArray = @[@"Breakfast",@"Dinner",@"Snack",@"Daily Essentials",@"Social",@"Lunch",@"Drink",@"Transportation",@"Entertainment",@"Clothes",@"Shopping",@"Gift",@"Medical",@"Rent",@"Telephone Fee",@"Others"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self selectedRowForItemTextField];
    
    _editableItemTextField.enabled = NO;
    _editableSpendTextField.enabled = NO;
    _editableRemarkTextField.enabled = NO;
    
    _editableItemTextField.borderStyle = UITextBorderStyleNone;
    _editableSpendTextField.borderStyle = UITextBorderStyleNone;
    _editableRemarkTextField.borderStyle = UITextBorderStyleNone;
    
    NSString *keyForItem = _recordForAItemArray[0];
    NSString *keyForSpend = _recordForAItemArray[1];
    NSString *keyForRemark = _recordForAItemArray[2];
    
    _editableItemTextField.text = [db stringForKey:keyForItem];
    _editableSpendTextField.text = [db stringForKey:keyForSpend];
    _editableRemarkTextField.text = [db stringForKey:keyForRemark];
    
    
}

-(void) selectedRowForItemTextField{
    
    _itemPicker = [[UIPickerView alloc]init];
    [_editableItemTextField setInputView:_itemPicker];
    _itemPicker.delegate = self;
    _itemPicker.dataSource = self;
    
    UIToolbar *itemToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [itemToolBar setTintColor:[UIColor darkGrayColor]];
    
    itemDoneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedItem)];
    
    [itemToolBar setItems:[NSArray arrayWithObjects:itemDoneBtn, nil]];
    
    [_editableItemTextField setInputAccessoryView:itemToolBar];
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

- (void)ShowSelectedItem{
    
    _editableItemTextField.text = itemArray[[_itemPicker selectedRowInComponent:0]];
    
    [_editableItemTextField resignFirstResponder];
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


- (IBAction)editRecordCancel:(UIBarButtonItem *)sender {
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editRecordEditSave:(UIBarButtonItem *)sender {
    
    if ([_editSaveBtn.title isEqualToString:@"Edit"]) {
        
        _editableItemTextField.enabled = YES;
        _editableSpendTextField.enabled = YES;
        _editableRemarkTextField.enabled = YES;
        
        _editableItemTextField.borderStyle = UITextBorderStyleRoundedRect;
        _editableSpendTextField.borderStyle = UITextBorderStyleRoundedRect;
        _editableRemarkTextField.borderStyle = UITextBorderStyleRoundedRect;
        
        _editSaveBtn.title = @"Save";
    }else if ([_editSaveBtn.title isEqualToString:@"Save"]) {
        
        _editableItemTextField.enabled = NO;
        _editableSpendTextField.enabled = NO;
        _editableRemarkTextField.enabled = NO;
        
        _editableItemTextField.borderStyle = UITextBorderStyleNone;
        _editableSpendTextField.borderStyle = UITextBorderStyleNone;
        _editableRemarkTextField.borderStyle = UITextBorderStyleNone;
        
        _editSaveBtn.title = @"Edit";
        
        db = [NSUserDefaults standardUserDefaults];
        
        NSString *keyForItem = _recordForAItemArray[0];
        NSString *keyForSpend = _recordForAItemArray[1];
        NSString *keyForRemark = _recordForAItemArray[2];
        NSString *keyForIcon = _recordForAItemArray[3];
        
        NSString *theIcon = [NSString stringWithFormat:@"%@.png",_editableItemTextField.text];
        
        [db setObject:_editableItemTextField.text forKey:keyForItem];
        [db setObject:_editableSpendTextField.text forKey:keyForSpend];
        [db setObject:_editableRemarkTextField.text forKey:keyForRemark];
        [db setObject:theIcon forKey:keyForIcon];
        
        [self dismissKeyboard];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)dismissKeyboard {
    [_editableItemTextField resignFirstResponder];
    [_editableSpendTextField resignFirstResponder];
    [_editableRemarkTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^[0-9]*((\\.|,)[0-9]{0,1})?$";
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    return numberOfMatches != 0;
}
@end
