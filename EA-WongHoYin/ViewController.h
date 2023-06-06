//
//  ViewController.h
//  EA-WongHoYin
//
//  Created by Horace Wong on 6/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

- (IBAction)setBudgetBtn:(id)sender;
- (IBAction)selectDateBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UILabel *showBudged;


@property (weak, nonatomic) IBOutlet UIButton *budgetButton;

@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;

@end

