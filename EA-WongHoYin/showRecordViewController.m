//
//  showRecordViewController.m
//  EA-WongHoYin
//
//  Created by Horace Wong on 8/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import "showRecordViewController.h"
#import "showRecordTableViewCell.h"
#import "editRecordViewController.h"

@interface showRecordViewController (){
    
    NSMutableArray *dateArray;
    NSMutableArray *itemArray;
    NSMutableArray *spendArray;
    NSMutableArray *remarkArray;
    NSMutableArray *iconArray;
    
    NSNumber *myTotalSpend;
    
    NSUserDefaults *db;
    
    
}

@end

@implementation showRecordViewController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    db = [NSUserDefaults standardUserDefaults];
    
    
    
    _tableViewObject.delegate = self;
    _tableViewObject.dataSource = self;
    _tableViewObject.layer.cornerRadius = 15;
    _tableViewObject.showsHorizontalScrollIndicator = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self loadDataFromSQL];
    [self getRecord];
    [_tableViewObject reloadData];
    [self updateTotalSpend];
    _showDateLabel.text = [db stringForKey:@"selected date"];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    db = [NSUserDefaults standardUserDefaults];
    NSString *keyForNumberOfRecord = [self keyWithDate:@"number of record"];
    
    return (int)[db integerForKey:keyForNumberOfRecord];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        db = [NSUserDefaults standardUserDefaults];
        NSString *keyForNumberOfRecord = [self keyWithDate:@"number of record"];
        
        int numberOfRecord =(int)[db integerForKey:keyForNumberOfRecord];
        int checkIfTheRowIsLastOne = numberOfRecord - 1;
        
        //delete the row if the row is the last one
        if (checkIfTheRowIsLastOne == (int)indexPath.row) {
            [db setInteger:checkIfTheRowIsLastOne forKey:keyForNumberOfRecord];
            
            [_tableViewObject deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self viewWillAppear:YES];
        }else{
            //delete the selected row except the last one
            
            int theSelectedRow;
            
            for (theSelectedRow = (int)indexPath.row; theSelectedRow < checkIfTheRowIsLastOne; theSelectedRow++) {
                
                int i = theSelectedRow + 1;
                
                //create key for the next data of selected row
                NSString *keyForDate = [NSString stringWithFormat:@"date%d/%@", i, [db stringForKey:@"selected date"]];
                
                NSString *keyForItem = [NSString stringWithFormat:@"item%d/%@", i, [db stringForKey:@"selected date"]];
                
                NSString *keyForSpend = [NSString stringWithFormat:@"spend%d/%@", i, [db stringForKey:@"selected date"]];
                
                NSString *keyForRemark = [NSString stringWithFormat:@"remark%d/%@", i, [db stringForKey:@"selected date"]];
                
                NSString *keyForIcon = [NSString stringWithFormat:@"icon%d/%@", i, [db stringForKey:@"selected date"]];
                
                
                //as a temp to save the next data of selected row
                NSString *theDateWasPullUp = [db stringForKey:keyForDate];
                NSString *theItemWasPullUp = [db stringForKey:keyForItem];
                NSString *theSpendWasPullUp = [db stringForKey:keyForSpend];
                NSString *theRemarkWasPullUp = [db stringForKey:keyForRemark];
                NSString *theIconWasPullUp = [db stringForKey:keyForIcon];
                
                //create a new key for putting all the data move up
                NSString *keyForDateWasPullUp = [NSString stringWithFormat:@"date%d/%@", theSelectedRow, [db stringForKey:@"selected date"]];
                
                NSString *keyForItemWasPullUp = [NSString stringWithFormat:@"item%d/%@", theSelectedRow, [db stringForKey:@"selected date"]];
                
                NSString *keyForSpendWasPullUp = [NSString stringWithFormat:@"spend%d/%@", theSelectedRow, [db stringForKey:@"selected date"]];
                
                NSString *keyForRemarkWasPullUp = [NSString stringWithFormat:@"remark%d/%@", theSelectedRow, [db stringForKey:@"selected date"]];
                
                NSString *keyForIconWasPullUp = [NSString stringWithFormat:@"icon%d/%@", theSelectedRow, [db stringForKey:@"selected date"]];
                
                //put the data moving up
                [db setObject:theDateWasPullUp forKey:keyForDateWasPullUp];
                [db setObject:theItemWasPullUp forKey:keyForItemWasPullUp];
                [db setObject:theSpendWasPullUp forKey:keyForSpendWasPullUp];
                [db setObject:theRemarkWasPullUp forKey:keyForRemarkWasPullUp];
                [db setObject:theIconWasPullUp forKey:keyForIconWasPullUp];
                
            }
            
            [db setInteger:checkIfTheRowIsLastOne forKey:keyForNumberOfRecord];
            
            [_tableViewObject deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self viewWillAppear:YES];
            
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    db = [NSUserDefaults standardUserDefaults];
    
    static NSString *MyIdentifier = @"myCell";
    
    showRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    NSNumberFormatter *spendFormatter = [[NSNumberFormatter alloc] init];
    
    [spendFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [spendFormatter setMaximumFractionDigits:1];
    

    NSString *stringForItemLabel = [itemArray objectAtIndex:(NSUInteger)indexPath.row];
    NSString *stringForDateLabel = [dateArray objectAtIndex:(NSUInteger)indexPath.row];
    NSString *stringForIconLabel = [iconArray objectAtIndex:(NSUInteger)indexPath.row];
    
    
    
    double tempSpend = [[spendArray objectAtIndex:(NSUInteger)indexPath.row] doubleValue];
    
    NSNumber *spendToNSNumber = [NSNumber numberWithDouble:tempSpend];
    
    NSString *stringForSpendLabel = [spendFormatter stringFromNumber:spendToNSNumber];
    
    cell.itemLabel.text = stringForItemLabel;
    cell.dateLabel.text = stringForDateLabel;
    cell.spendLabel.text = [NSString stringWithFormat:@"HK$ %@", stringForSpendLabel];
    cell.iconLabel.image = [UIImage imageNamed:stringForIconLabel];
    
    return cell;
}

-(void) updateTotalSpend{

    double totalSpend = 0;

    for (int i = 0; i < spendArray.count; i++) {
        double tempSpend = [[spendArray objectAtIndex:i] doubleValue];
        
        totalSpend += tempSpend;
    }
    
    NSNumberFormatter *totalSpendFormatter = [[NSNumberFormatter alloc] init];
    
    [totalSpendFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [totalSpendFormatter setMaximumFractionDigits:1];
    
    NSNumber *totalSpendToNSNumber = [NSNumber numberWithDouble:totalSpend];
    
    NSString *stringForTotalSpend = [totalSpendFormatter stringFromNumber:totalSpendToNSNumber];
    
    _totalSpendLabel.text = stringForTotalSpend;
    
    NSString *keyForTotalSpend = [self keyWithDate:@"total spend"];
    
    [db setDouble:totalSpend forKey:keyForTotalSpend];
}

-(void) getRecord{
    
    dateArray = [[NSMutableArray alloc]init];
    itemArray = [[NSMutableArray alloc]init];
    spendArray = [[NSMutableArray alloc]init];
    remarkArray = [[NSMutableArray alloc]init];
    iconArray = [[NSMutableArray alloc]init];
    
    db = [NSUserDefaults standardUserDefaults];
    NSString *keyForNumberOfRecord = [self keyWithDate:@"number of record"];
    int numberOfRecord = (int)[db integerForKey:keyForNumberOfRecord];
    
    for (int i = 0; i < numberOfRecord; i++) {
        NSString *keyForDate = [NSString stringWithFormat:@"date%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForItem = [NSString stringWithFormat:@"item%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForSpend = [NSString stringWithFormat:@"spend%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForRemark = [NSString stringWithFormat:@"remark%d/%@", i, [db stringForKey:@"selected date"]];
        
        NSString *keyForIcon = [NSString stringWithFormat:@"icon%d/%@", i, [db stringForKey:@"selected date"]];
        
        [dateArray addObject:[db stringForKey:keyForDate]];
        [itemArray addObject:[db stringForKey:keyForItem]];
        [spendArray addObject:[db stringForKey:keyForSpend]];
        [remarkArray addObject:[db stringForKey:keyForRemark]];
        [iconArray addObject:[db stringForKey:keyForIcon]];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender{
    
    if ([[segue identifier] isEqualToString:@"editRecord"]) {
        
        db = [NSUserDefaults standardUserDefaults];
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        editRecordViewController *editRecordVC = (editRecordViewController*) navigationController.topViewController;
        
        NSIndexPath *indexPath = [_tableViewObject indexPathForCell:sender];
        int row = (int)[indexPath row];
        
        NSString *keyForItem = [NSString stringWithFormat:@"item%d/%@", row, [db stringForKey:@"selected date"]];
        
        NSString *keyForSpend = [NSString stringWithFormat:@"spend%d/%@", row, [db stringForKey:@"selected date"]];
        
        NSString *keyForRemark = [NSString stringWithFormat:@"remark%d/%@", row, [db stringForKey:@"selected date"]];
        
        NSString *keyForIcon = [NSString stringWithFormat:@"icon%d/%@", row, [db stringForKey:@"selected date"]];
        
        editRecordVC.recordForAItemArray = @[keyForItem, keyForSpend, keyForRemark, keyForIcon];
    }
}

-(NSString *) keyWithDate:(NSString*)name{
    
    NSString *keyForEvery = [NSString stringWithFormat:@"%@/%@",name, [db stringForKey:@"selected date"]];
    
    return keyForEvery;
}

//- (int)valueOfRow{
//
//    db = [NSUserDefaults standardUserDefaults];
//
//    if ([db objectForKey:@"number of record"] == nil) {
//        return 0;
//    }else{
//        return (int)[db integerForKey:@"number of record"];
//    }
//}



@end
