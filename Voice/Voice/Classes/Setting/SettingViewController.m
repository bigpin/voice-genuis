//
//  SettingViewController.m
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTrainingModeCell.h"
#import "SettingBubbleColorCell.h"
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if 
{
    if (section == 0) {
        return STRING_TRANING_MODE;
    } else if (section == 1){
        return STRING_CONTROL_SETTING;
    } else {
        return STRING_SHOW_MODE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        return 120; 
    } else {
        return 60;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
	NSInteger nSection = indexPath.section;
    if (nSection == 0) {
        if (nRow == 0) {
            SettingTrainingModeCell *cell = (SettingTrainingModeCell *)[tableView dequeueReusableCellWithIdentifier:@"WholeModeCell"];
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingTrainingModeCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.slider.tag = TAG_OF_TIME_INTEVAL;
            cell.slider.minimumValue = 0.0;
            cell.slider.maximumValue = 10.0;
            cell.slider.value = settingData.dTimeInterval;
            cell.label.text = STRING_WHOLE_LESSON_MODE;
            cell.sliderText.text = STRING_SETTING_TIME;
            NSString* str = STRING_TIME_DE_COUNT_FORMAT;
            cell.timeLabel.text = [NSString stringWithFormat:str, cell.slider.value];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = (id)self;
            if (settingData.eReadingMode == nRow) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                pathReadingMode = indexPath;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        } else if (nSection == 1) {
        
        } else {
            SettingTrainingModeCell *cell = (SettingTrainingModeCell *)[tableView dequeueReusableCellWithIdentifier:@"ReadingFollowCell"];
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingTrainingModeCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.slider.tag = TAG_OF_READING_COUNT;
            cell.delegate = (id)self;
            cell.slider.minimumValue = 1;
            cell.slider.maximumValue = 10;
            cell.slider.value = settingData.nReadingCount;
            cell.label.text = STRING_SENTENCE_MODE;
            cell.sliderText.text = STRING_READING_COUNT;
            NSString* str = STRING_READING_COUNT_FORMAT;
            cell.timeLabel.text = [NSString stringWithFormat:str, settingData.nReadingCount];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (settingData.eReadingMode == nRow) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                pathReadingMode = indexPath;
           } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
    } else {
        static NSString *cellName = @"showModeCell";
       UITableViewCell * cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
        }
        switch (nRow) {
            case 0:
                cell.textLabel.text = STRING_SHOW_SRC_TEXT;
                break;
            case 1:
                cell.textLabel.text = STRING_SHOW_SRCANDTRANS_TEXT;
                break;
            case 2:
                cell.textLabel.text = STRING_SHOW_NO_TEXT;
                break;
                
            default:
                break;
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (settingData.eShowTextType == nRow) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            pathShowText = indexPath;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
    if (indexPath.section == 0) {
        NSInteger nRow = indexPath.row;
        if (nRow != (NSInteger)pathReadingMode.row) {
            UITableViewCell* cellOld = [self.tableView cellForRowAtIndexPath:pathReadingMode];
            cellOld.accessoryType = UITableViewCellAccessoryNone;
            pathReadingMode = indexPath;
            
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            settingData.eReadingMode = nRow;
            
            [settingData saveSettingData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGED_SETTING_VALUE object:nil];
        }
    } else if (indexPath.section == 2) {
        NSInteger nRow = indexPath.row;
        if (nRow != (NSInteger)pathShowText.row) {
            UITableViewCell* cellOld = [self.tableView cellForRowAtIndexPath:pathShowText];
            cellOld.accessoryType = UITableViewCellAccessoryNone;
            pathShowText = indexPath;

            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            settingData.eShowTextType = nRow;

            [settingData saveSettingData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGED_SETTING_VALUE object:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (SettingData*)getSettingData;
{
    return settingData;
}

- (void)didSettingTimeInterval:(CGFloat)dTimeInterval withTag:(NSInteger)tag;
{
    if (tag == TAG_OF_TIME_INTEVAL) {
        settingData.dTimeInterval = dTimeInterval;
    } else {
        settingData.nReadingCount = dTimeInterval;
    }
    
    [settingData saveSettingData];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGED_SETTING_VALUE object:nil];
}

@end
