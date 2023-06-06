//
//  addItemViewController.h
//  EA-WongHoYin
//
//  Created by Horace Wong on 8/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addItemViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
}

@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UITextField *purchaseDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;

@property (strong, nonatomic) UIPickerView *itemPicker;



- (IBAction)saveBarBtn:(UIBarButtonItem *)sender;

- (IBAction)cancelBarBtn:(UIBarButtonItem *)sender;

@end
