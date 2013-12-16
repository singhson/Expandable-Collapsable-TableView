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

NSString *Title;

@implementation ExpandableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
	self.items=[dict valueForKey:@"Items"];
	self.itemsForTable=[[NSMutableArray alloc] init];
	[self.itemsForTable addObjectsFromArray:self.items];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsForTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Title = [[self.itemsForTable objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    return [self createCellWithTitle:Title image:[[self.itemsForTable objectAtIndex:indexPath.row] valueForKey:@"Image name"] indexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *d=[self.itemsForTable objectAtIndex:indexPath.row];
    if([d valueForKey:@"SubItems"])
    {
        		NSArray *ar=[d valueForKey:@"SubItems"];
        		NSLog(@"d %@",d);
        		BOOL isAlreadyInserted=NO;
        
        		for(NSDictionary *subitems in ar )
                {
        			NSInteger index=[self.itemsForTable indexOfObjectIdenticalTo:subitems];
        			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
        			if(isAlreadyInserted) break;
        		}
        
        		if(isAlreadyInserted)
                {
        			[self miniMizeThisRows:ar];
        		}
                else
                {
        			NSUInteger count=indexPath.row+1;
                    NSMutableArray *arCells=[NSMutableArray array];
        			for(NSDictionary *dInner in ar )
                    {
        				[arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
        				[self.itemsForTable insertObject:dInner atIndex:count++];
        			}
                [self.menuTableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
                }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar
{
	for(NSDictionary *dInner in ar )
    {
		NSUInteger indexToRemove=[self.itemsForTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"SubItems"];
		if(arInner && [arInner count]>0)
        {
			[self miniMizeThisRows:arInner];
		}
		
		if([self.itemsForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
			[self.itemsForTable removeObjectIdenticalTo:dInner];
			[self.menuTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationLeft];
        }
	}
}

- (UITableViewCell*)createCellWithTitle:(NSString *)title image:(UIImage *)image  indexPath:(NSIndexPath*)indexPath
{
    NSString *CellIdentifier = @"Cell";
    ExpandableTableViewCell* cell = [self.menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor grayColor];
        cell.selectedBackgroundView = bgView;
        cell.lblTitle.text = title;
        cell.lblTitle.textColor = [UIColor blackColor];
        
        [cell setIndentationLevel:[[[self.itemsForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
        cell.indentationWidth = 25;
  
        float indentPoints = cell.indentationLevel * cell.indentationWidth;
        
        cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
        
        NSDictionary *d1=[self.itemsForTable objectAtIndex:indexPath.row] ;
    
        if([d1 valueForKey:@"SubItems"])
        {
            cell.btnExpand.alpha = 1.0;
            [cell.btnExpand addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.btnExpand.alpha = 0.0;
        }
        return cell;
}

-(void)showSubItems :(id) sender
{
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.menuTableView];
    NSIndexPath *indexPath = [self.menuTableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    NSLog(@"buttonFrameInTableViewindexpath=%d",indexPath.row);
    
    NSLog(@"btn tag = %ld",(long)btn.tag);
    if(btn.alpha==1.0)
    {
        if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"down-arrow.png"]])
        {
            [btn setImage:[UIImage imageNamed:@"up-arrow.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
        }
        
    }
    
    NSDictionary *d=[self.itemsForTable objectAtIndex:indexPath.row] ;
    NSLog(@"d = %@",d);
    NSArray *ar=[d valueForKey:@"SubItems"];
    if([d valueForKey:@"SubItems"])
    {
        BOOL isAlreadyInserted=NO;
        for(NSDictionary *subitems in ar )
        {
            NSInteger index=[self.itemsForTable indexOfObjectIdenticalTo:subitems];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        
        if(isAlreadyInserted)
        {
            [self miniMizeThisRows:ar];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(NSDictionary *dInner in ar )
            {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.itemsForTable insertObject:dInner atIndex:count++];
            }
            [self.menuTableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
    
}


@end
