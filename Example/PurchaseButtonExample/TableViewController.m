//
//  TableViewController.m
//  PurchaseButtonExample
//
//  Created by Andreas Verhoeven on 20-12-15.
//  Copyright © 2015 AveApps. All rights reserved.
//

#import "TableViewController.h"
#import "AvePurchaseButton.h"

@implementation TableViewController
{
	NSMutableIndexSet* _busyIndexes;
}

-(void)purchaseButtonTapped:(AvePurchaseButton*)button
{
	NSIndexPath* indexPath = [self.tableView indexPathForCell:(UITableViewCell*)button.superview];
	NSInteger index = indexPath.row;
	
	// handle taps on the purchase button by
	switch(button.buttonState)
	{
		case AvePurchaseButtonStateNormal:
			// progress -> confirmation
			[button setButtonState:AvePurchaseButtonStateConfirmation animated:YES];
			break;
			
		case AvePurchaseButtonStateConfirmation:
			// confirmation -> "purchase" progress
			[_busyIndexes addIndex:index];
			[button setButtonState:AvePurchaseButtonStateProgress animated:YES];
			break;
			
		case AvePurchaseButtonStateProgress:
			// progress -> back to normal
			[_busyIndexes removeIndex:index];
			[button setButtonState:AvePurchaseButtonStateNormal animated:YES];
			break;
	}
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	_busyIndexes = [NSMutableIndexSet new];
	
	self.tableView.rowHeight = 54;
	
	self.tableView.layoutMargins = UIEdgeInsetsZero;
	self.tableView.separatorInset = UIEdgeInsetsZero;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* const CellIdentifier = @"Cell";
	
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(nil == cell)
	{
		// create  a cell with some nice defaults
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.layoutMargins = UIEdgeInsetsZero;
		cell.separatorInset = UIEdgeInsetsZero;
		cell.detailTextLabel.textColor = [UIColor grayColor];
		
		// add a buttons as an accessory and let it respond to touches
		AvePurchaseButton* button = [[AvePurchaseButton alloc] initWithFrame:CGRectZero];
		[button addTarget:self action:@selector(purchaseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = button;
	}
	
	// configure the cell
	cell.textLabel.text = @"Some Nice Item";
	cell.detailTextLabel.text = @"Really nice!";
	
	// configure the purchase button in state normal
	AvePurchaseButton* button = (AvePurchaseButton*)cell.accessoryView;
	button.buttonState = AvePurchaseButtonStateNormal;
	button.normalTitle = @"$ 2.99";
	button.confirmationTitle = @"BUY";
	[button sizeToFit];
	
	// if the item at this indexPath is being "busy" with purchasing, update the purchase
	// button's state to reflect so.
	if([_busyIndexes containsIndex:indexPath.row] == YES)
	{
		button.buttonState = AvePurchaseButtonStateProgress;
	}
	
	
	return cell;
}

@end
