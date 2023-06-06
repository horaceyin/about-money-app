//
//  editRecordViewController.h
//  EA-WongHoYin
//
//  Created by Horace Wong on 13/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editRecordViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *editableItemTextField;
@property (weak, nonatomic) IBOutlet UITextField *editableSpendTextField;
@property (weak, nonatomic) IBOutlet UITextField *editableRemarkTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editSaveBtn;
@property (strong, nonatomic) NSArray *recordForAItemArray;
@property (strong, nonatomic) UIPickerView *itemPicker;




- (IBAction)editRecordCancel:(UIBarButtonItem *)sender;
- (IBAction)editRecordEditSave:(UIBarButtonItem *)sender;


@end
