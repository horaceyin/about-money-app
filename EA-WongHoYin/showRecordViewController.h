//
//  showRecordViewController.h
//  EA-WongHoYin
//
//  Created by Horace Wong on 8/7/2019.
//  Copyright © 2019 Horace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showRecordViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewObject;

@property (nonatomic, retain) NSMutableArray *theDateArrary;
@property (nonatomic, retain) NSMutableArray *theItemArrary;
@property (nonatomic, retain) NSMutableArray *theSpendArrary;
@property (nonatomic, retain) NSMutableArray *theRemarkArrary;
@property (weak, nonatomic) IBOutlet UILabel *totalSpendLabel;

@property (weak, nonatomic) IBOutlet UILabel *showDateLabel;

@end
