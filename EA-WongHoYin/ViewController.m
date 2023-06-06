//
//  ViewController.m
//  EA-WongHoYin
//
//  Created by Horace Wong on 6/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import "ViewController.h"



@interface ViewController (){
    
    double totalBudget;
    double remainBudget;
    double totalSpend;
    NSMutableArray *devices;
    UITextField *textFieldForBudget;
    
    NSUserDefaults *db;

    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *originalString = @"item5-12-Jul-2019";
    
    NSLog(@"%@",[db objectForKey:@"selected date"]);
    
    db = [NSUserDefaults standardUserDefaults];
    [db setObject:nil forKey:@"did the date selected?"];
    [db setObject:nil forKey:@"selected date"];
    
    // Intermediate
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    // Result.
    int number = (int)[numberString integerValue];
    
    NSLog(@"%d !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", number);
    
    textFieldForBudget.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self checkIfDateSelected])
        [_budgetButton setEnabled:YES];
    else
        [_budgetButton setEnabled:NO];
    
    
    
    if ([self checkIfBudgetAndDateSet])
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
    else
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
    
    [self updateBudget];
    [self getSelectedDate];
    [self updatePercentage];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)setBudgetBtn:(id)sender {
    
    NSString *originalString = [_showBudged text];
    
    NSString *tempString;
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&tempString];
    
    // Result.
    int check = (int)[tempString integerValue];
    
    if (check == 0) {
        [self inputDialogue];
    }else{
        [self askRewriteBudget];
    }
    
    
}

- (IBAction)selectDateBtn:(id)sender {
    
    db = [NSUserDefaults standardUserDefaults];
    
    //https://stackoverflow.com/questions/39158822/how-to-add-uidatepicker-into-uialertcontroller-ios9
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIView *viewDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,200)];
    [viewDatePicker setBackgroundColor:[UIColor clearColor]];
    
    CGRect pickerFrame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [picker setDatePickerMode:UIDatePickerModeDate];
    
    [viewDatePicker addSubview:picker];
    
    [alertController.view addSubview:viewDatePicker];
    
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"dd-MMM-YYYY"];
        
        NSString *selectedDate = [formatter stringFromDate:picker.date];
        
        [self.dateBtn setTitle:selectedDate forState:UIControlStateNormal];
        
        [self->db setObject:selectedDate forKey:@"selected date"];
        
        [self->db setObject:@"YES" forKey:@"did the date selected?"];
        
        [self viewWillAppear:YES];
        
        NSLog(@"%@", [formatter stringFromDate:picker.date]);
        
    }];
    
    
    
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

- (void) inputDialogue{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please set your budget."
                                          message:@"For a day"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textFieldForBudget)
     {
         
         textFieldForBudget.delegate = self;
         textFieldForBudget.placeholder = @"Your Budget";
         
         [textFieldForBudget setKeyboardType:UIKeyboardTypeDecimalPad];
         
         
     }];
    
    
    UIAlertAction *actionCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    UIAlertAction *actionOK = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   self->db = [NSUserDefaults standardUserDefaults];
                                   
                                   NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
                                   
                                   [Formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                                   
                                   [Formatter setMaximumFractionDigits:1];
                                   
 
                                   
                                   UITextField *Budget = alertController.textFields.firstObject;
                                   
                                   NSString *stringForBudget = [Budget text];
                                   
                                   double doubleValueForTotalBudget = [stringForBudget doubleValue];
                                   
                                   NSString *keyForTotalBudget = [self keyWithDate:@"total budget"];
                                   
                                   NSLog(@"%@", keyForTotalBudget);
                                   
                                   [self->db setDouble:doubleValueForTotalBudget forKey:keyForTotalBudget];
                                 
                                   [self viewWillAppear:YES];
                                   //NSLog(@"%@", uBudget);
                                                                          
                                   }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionOK];
    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)askRewriteBudget{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to rewrite your budget ?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self ReInputDialogue];
    }];
    
    [alert addAction:yesAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) ReInputDialogue{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please set your budget again."
                                          message:@"0.0 for reset all"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.delegate = self;
         
         textField.placeholder = @"Your Budget";
         
         [textField setKeyboardType:UIKeyboardTypeDecimalPad];
         
         
     }];
    
    
    UIAlertAction *actionCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    UIAlertAction *actionOK = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                  
                                   self->db = [NSUserDefaults standardUserDefaults];
                                   
                                   NSNumberFormatter *doubleValueWithMaxOneDecimalPlaces = [[NSNumberFormatter alloc] init];
                                   
                                   [doubleValueWithMaxOneDecimalPlaces setNumberStyle:NSNumberFormatterDecimalStyle];
                                   
                                   [doubleValueWithMaxOneDecimalPlaces setMaximumFractionDigits:1];
                                   
                                   UITextField *Budget = alertController.textFields.firstObject;
                                   
                                   NSString *stringForBudget = [Budget text];
                                   
                                   double doubleValueForTotalBudget = [stringForBudget doubleValue];
                                   
                                   NSString *keyForTotalBudget = [self keyWithDate:@"total budget"];
                                   NSString *keyForTotalSpend = [self keyWithDate:@"total spend"];
                                   
                                   if ([stringForBudget isEqualToString:@"0.0"]) {
                                       
                                       
                                       if ([self->db doubleForKey:keyForTotalSpend] > 0) {
                                           [self clearAllRecord];
                                       } else {
                                           [self->db setDouble:0 forKey:keyForTotalBudget];
                                       }
                                       
                                       
                                   }else if ([self->db doubleForKey:keyForTotalSpend] == 0){
                                       
                                       [self->db setDouble:doubleValueForTotalBudget forKey:keyForTotalBudget];
                                       
                                   }else if (doubleValueForTotalBudget > [self->db doubleForKey:keyForTotalBudget]){
                                       
                                       [self->db setDouble:doubleValueForTotalBudget forKey:keyForTotalBudget];
                                       
                                   }else{
                                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You cannot input the budget below the original." message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                       
                                       
                                       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                           
                                       }];
                                       [alert addAction:okAction];
                                       
                                       [self presentViewController:alert animated:YES completion:nil];
                                   }
                                   
                                   [self viewWillAppear:YES];
                               }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionOK];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^[0-9]*((\\.|,)[0-9]{0,1})?$";
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    return numberOfMatches != 0;
}

-(BOOL) checkIfBudgetAndDateSet{
    db = [NSUserDefaults standardUserDefaults];
    
    NSString *keyForTotalBudget = [self keyWithDate:@"total budget"];
    
    if ([db objectForKey:keyForTotalBudget] == nil) {
        return NO;
    }else{
        if ([db objectForKey:@"selected date"] == nil)
            return NO;
        else
            return YES;
        }
}

-(BOOL) checkIfDateSelected{
    db = [NSUserDefaults standardUserDefaults];
    
    if ([db objectForKey:@"did the date selected?"] == nil)
        return NO;
    else
        return YES;
}

-(void) updateBudget{
    
    db = [NSUserDefaults standardUserDefaults];
    
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    
    [Formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [Formatter setMaximumFractionDigits:1];
    
    NSString *keyForTotalBudget = [self keyWithDate:@"total budget"];
    
    NSString *keyForTotalSpend = [self keyWithDate:@"total spend"];
    
    totalBudget = [db doubleForKey:keyForTotalBudget]; // must show
    totalSpend = [db doubleForKey:keyForTotalSpend];
    
    remainBudget = totalBudget - totalSpend; //must show
    
    NSNumber *totalBudgetToNSNumber = [NSNumber numberWithDouble:totalBudget];
    NSNumber *remainSpendToNSNumber = [NSNumber numberWithDouble:remainBudget];
    
    NSString *stringForTotalBudget = [Formatter stringFromNumber:totalBudgetToNSNumber];
    NSString *stringForRemainBudget = [Formatter stringFromNumber:remainSpendToNSNumber];
    
    _showBudged.text = [NSString stringWithFormat:@"HK$ %@ /%@", stringForRemainBudget, stringForTotalBudget];
    
}

-(void) updatePercentage{
    
    db = [NSUserDefaults standardUserDefaults];
    
    NSString *keyForTotalBudget = [self keyWithDate:@"total budget"];

    if ([self checkIfDateSelected]) {
        
        if ([db objectForKey:keyForTotalBudget] != nil) {
            
            if (remainBudget > 0) {
                double percentage = (remainBudget / totalBudget) * 100;
                
                NSString *text = [NSString stringWithFormat:@"There is still %d%% for you", (int)roundf(percentage)];
                
                _percentageLabel.text = text;
                //NSLog(@"&&&&&&&&&&&&&&&&& %d", (int)roundf(percentage));
            }else{
                NSString *text = @"There is still 0% for you";
                
                _percentageLabel.text = text;
            }
        }
    }
}

-(void) clearAllRecord{
    
    db = [NSUserDefaults standardUserDefaults];
    
    NSString *keyForNumberOfRecord = [self keyWithDate:@"number of record"];
    
    [db setInteger:0 forKey:keyForNumberOfRecord];
    
    NSString *keyForTotalBudget = [self keyWithDate:@"total budget"];
    NSString *keyForTotalSpend = [self keyWithDate:@"total spend"];
    
    [db removeObjectForKey:keyForTotalBudget];
    [db setDouble:0 forKey:keyForTotalSpend];
    
    
}

-(void) getSelectedDate{
    
    NSString *selectedDate = [db stringForKey:@"selected date"];
    
    if ([db objectForKey:@"selected date"] != nil)
        [self.dateBtn setTitle:selectedDate forState:UIControlStateNormal];
}


-(NSString *) keyWithDate:(NSString*)name{
    
    NSString *keyForEvery = [NSString stringWithFormat:@"%@/%@",name, [db stringForKey:@"selected date"]];
    
    return keyForEvery;
}

@end
