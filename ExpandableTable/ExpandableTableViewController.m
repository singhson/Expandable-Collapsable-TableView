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
	self.itemsInTable=[[NSMutableArray alloc] init];
	[self.itemsInTable addObjectsFromArray:self.items];
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
    return [self.itemsInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Title= [[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    return [self createCellWithTitle:Title image:[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"Image name"] indexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[self.itemsInTable objectAtIndex:indexPath.row];
    if([dic valueForKey:@"SubItems"])
    {
        		NSArray *arr=[dic valueForKey:@"SubItems"];
        		BOOL isTableExpanded=NO;
        
        		for(NSDictionary *subitems in arr )
                {
        			NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
        			isTableExpanded=(index>0 && index!=NSIntegerMax);
        			if(isTableExpanded) break;
        		}
        
        		if(isTableExpanded)
                {
        			[self CollapseRows:arr];
        		}
                else
                {
        			NSUInteger count=indexPath.row+1;
                    NSMutableArray *arrCells=[NSMutableArray array];
        			for(NSDictionary *dInner in arr )
                    {
        				[arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
        				[self.itemsInTable insertObject:dInner atIndex:count++];
        			}
                [self.menuTableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
                }
    }
}

-(void)CollapseRows:(NSArray*)ar
{
	for(NSDictionary *dInner in ar )
    {
		NSUInteger indexToRemove=[self.itemsInTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"SubItems"];
		if(arInner && [arInner count]>0)
        {
			[self CollapseRows:arInner];
		}
		
		if([self.itemsInTable indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
			[self.itemsInTable removeObjectIdenticalTo:dInner];
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
        
        [cell setIndentationLevel:[[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
        cell.indentationWidth = 25;
  
        float indentPoints = cell.indentationLevel * cell.indentationWidth;
        
        cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
        
        NSDictionary *d1=[self.itemsInTable objectAtIndex:indexPath.row] ;
    
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
    
    NSDictionary *d=[self.itemsInTable objectAtIndex:indexPath.row] ;
    NSArray *arr=[d valueForKey:@"SubItems"];
    if([d valueForKey:@"SubItems"])
    {
        BOOL isTableExpanded=NO;
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.itemsInTable insertObject:dInner atIndex:count++];
            }
            [self.menuTableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
    
}


@end
