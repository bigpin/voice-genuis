//
//  SettingViewController.m
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingPauseTimeCell.h"
#import "SettingBubbleColorCell.h"
#import "SettingShowTranslationCell.h"
#import "BubbleCell.h"

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (settingData == nil) {
        settingData = [[SettingData alloc] init];
        [settingData loadSettingData];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if 
{
    if (section == 0) {
        return STRING_SETTING_READING;
    } else {
        return STRING_SETTING_BUBBLE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //NSInteger nRow = indexPath.row;
    return 60.0;
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
	NSInteger nSection = indexPath.section;
    if (nSection == 0) {
        if (nRow == 0) {
            SettingPauseTimeCell *cell = (SettingPauseTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingPauseTimeCell"];
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingPauseTimeCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.slider.value = settingData.dTimeInterval;
            cell.label.text = STRING_SETTING_TIME;
            cell.timeLabel.text = [NSString stringWithFormat:@"%0.1fs", cell.slider.value];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = (id)self;
            return cell;
        } else {
            SettingShowTranslationCell *cell = (SettingShowTranslationCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingShowTranslationCell"];
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingShowTranslationCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.label.text = STRING_SHOW_TRANSLATION;
            cell.switchControll.on = settingData.isShowTranslation;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = (id)self;
            return cell;
           
        }
    } else {
        SettingBubbleColorCell *cell = (SettingBubbleColorCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingBubbleColorCell"];
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingBubbleColorCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        BubbleImageView *newImage = [[BubbleImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.bubbleView.frame.size.width, cell.bubbleView.frame.size.height)];
        
        //[newImage setBurnColor:1.0 withGreen:SELECTED_COLOR_G withBlue:SELECTED_COLOR_B];
        
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString* stringResource = @"Image";
        resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
        resourcePath = [NSString stringWithFormat:@"%@/aqua.png", resourcePath];
        newImage.imgName = resourcePath;
        [cell.bubbleView addSubview:newImage];
        [newImage release];

        if (nRow == 0) {
            cell.label.text = STRING_COLOR_1;
            cell.bubbleText.text = STRING_COLOR_1;
        } else if (nRow == 1) {
            cell.label.text = STRING_COLOR_2;
            cell.bubbleText.text = STRING_COLOR_2;
        } else {
            cell.label.text = STRING_COLOR_3;
            cell.bubbleText.text = STRING_COLOR_3;
        }
        [cell.bubbleView bringSubviewToFront:cell.bubbleText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    // Configure the cell...
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (SettingData*)getSettingData;
{
    return settingData;
}

- (void)didSettingTimeInterval:(CGFloat)dTimeInterval;
{
    settingData.dTimeInterval = dTimeInterval;
    [settingData saveSettingData];
}

- (void)isOn:(BOOL)isOn
{
    settingData.isShowTranslation = isOn;
    [settingData saveSettingData];
    
}
@end
