//
//  ExpandableTableViewCell.h
//  ExpandableTable
//
//  Created by Manpreet Singh on 06/12/13.
//  Copyright (c) 2013 Manpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExpandableTableViewController;
@interface ExpandableTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;


@end
