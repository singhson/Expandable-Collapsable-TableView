//
//  ExpandableTableViewController.m
//  ExpandableTable
//
//  Created by Manpreet Singh on 06/12/13.
//  Copyright (c) 2013 Manpreet Singh. All rights reserved.
//

#import "ExpandableTableViewController.h"
#import "ExpandableTableViewCell.h"

@interface ExpandableTableViewController ()

@end

NSUInteger rowcount;
@implementation ExpandableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
	self.items=[dict valueForKey:@"Objects"];
    
//    self.items = [[NSArray alloc] initWithObjects:@"National",@"International",@"Sports", nil];
	
	self.itemsForTable=[[NSMutableArray alloc] init];
    
	[self.itemsForTable addObjectsFromArray:self.items];
    


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    rowcount = [self.itemsForTable count];
    {
        
    }
    return rowcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
   static NSString *CellIdentifier = @"Cell";
  ExpandableTableViewCell *cell= [self.menuTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
    if (cell == nil)
           {
                cell = [[ExpandableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
           }
    cell.lblTitle.text=[[self.itemsForTable objectAtIndex:indexPath.row] valueForKey:@"English name"];
//    cell.lblTitle.text=[self.itemsForTable objectAtIndex:indexPath.row];
    [cell setIndentationLevel:[[[self.itemsForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    cell.indentationWidth = 25;
    
    
    float indentPoints = cell.indentationLevel * cell.indentationWidth;
    
    cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
    
    NSLog(@"level= %d",[[[self.itemsForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexpath did = %ld",(long)indexPath.row);
    ExpandableTableViewCell *cell = (ExpandableTableViewCell*)[self.menuTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"celltitle = %@",cell.lblTitle.text);
    NSDictionary *d=[self.itemsForTable objectAtIndex:indexPath.row];
    if([d valueForKey:@"Objects"])
            {
        		NSArray *ar=[d valueForKey:@"Objects"];
        		NSLog(@"d %@",d);
        		BOOL isAlreadyInserted=NO;
        
        		for(NSDictionary *subitems in ar )
                {
        			NSInteger index=[self.itemsForTable indexOfObjectIdenticalTo:subitems];
        			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
        			if(isAlreadyInserted) break;
        		}
        
        		if(isAlreadyInserted) {
        			[self miniMizeThisRows:ar];
        		} else {
        			NSUInteger count=indexPath.row+1;
                  			NSMutableArray *arCells=[NSMutableArray array];
        			for(NSDictionary *dInner in ar ) {
        				[arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
        				[self.itemsForTable insertObject:dInner atIndex:count++];
        			}
        			[self.menuTableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        	}
        	}

}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"indexpath did = %ld",(long)indexPath.row);
//    ExpandableTableViewCell *cell = (ExpandableTableViewCell*)[self.menuTableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"celltitle = %@",cell.lblTitle.text);
//    NSDictionary *d=[self.itemsForTable objectAtIndex:indexPath.row];
//	if([d valueForKey:@"Objects"])
//    {
//		NSArray *ar=[d valueForKey:@"Objects"];
//		NSLog(@"d %@",d);
//		BOOL isAlreadyInserted=NO;
//		
//		for(NSDictionary *subitems in ar )
//        {
//			NSInteger index=[self.itemsForTable indexOfObjectIdenticalTo:subitems];
//			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
//			if(isAlreadyInserted) break;
//		}
//		
//		if(isAlreadyInserted) {
//			[self miniMizeThisRows:ar];
//		} else {
//			NSUInteger count=indexPath.row+1;
//          			NSMutableArray *arCells=[NSMutableArray array];
//			for(NSDictionary *dInner in ar ) {
//				[arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
//				[self.itemsForTable insertObject:dInner atIndex:count++];
//			}
//			[self.menuTableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
//		}
//	}

//}
- (void)selectViewControllerWithIdentifier:(NSString *)identifier
{
    
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
}

//- (void)btnExpand
//{
//    rowcount = rowcount + 3; // update the data source
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//    [self.menuTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

-(void)miniMizeThisRows:(NSArray*)ar{
	
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.itemsForTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"Objects"];
		if(arInner && [arInner count]>0){
			[self miniMizeThisRows:arInner];
		}
		
		if([self.itemsForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
			[self.itemsForTable removeObjectIdenticalTo:dInner];
			[self.menuTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
