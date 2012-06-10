//
//  SettingViewController.m
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTrainingModeCell.h"
#import "BubbleCell.h"
#import "SettingSwitchCell.h"
#import "SettingAboutViewController.h"
#import "SettingShowTranslationCell.h"
#import "VoiceAppDelegate.h"

@implementation SettingViewController
@synthesize bFromSence;
@synthesize pathShowText = _pathShowText;
@synthesize pathReadingMode = _pathReadingMode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    bFromSence = NO;
    return self;
}


- (void)dealloc
{
    if (self.pathReadingMode != nil) {
        self.pathReadingMode = nil;
    }
    
    if (self.pathShowText != nil) {
        self.pathShowText = nil;
    }
    [resourcePath release];
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
    if (resourcePath == nil) {
        resourcePath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Image"]];
    }
    if (bFromSence) {
        UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:STRING_BACK style:UIBarButtonItemStyleBordered target:self action:@selector(backToSelectedViewController)];
        self.navigationItem.leftBarButtonItem = back;
        [back release];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        if (app.configData.bShowTranslateText) {
            return 3;
        } else {
            return 2;
        }
    } else if (section == 3) {
        return 1;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if 
{
    if (section == 0) {
        return STRING_TRANING_MODE;
    } else if (section == 1){
        return STRING_CONTROL_SETTING;
    } else if (section == 2){
        return STRING_SHOW_MODE;
    } else if (section == 3) {
        return STRING_DAY;
    } else if (section == 4) {
        return STRING_ABOUT_US;
    } else {
        return STRING_OTHER;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        return 85; 
    } else {
        return 44;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
	NSInteger nSection = indexPath.section;
    if (nSection == 0) {
        if (nRow == 0) {
            SettingTrainingModeCell *cell = (SettingTrainingModeCell *)[tableView dequeueReusableCellWithIdentifier:@"WholeModeCell"];
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingTrainingModeCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
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
                cell.selectedView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath, @"checked.png"]];
                self.pathReadingMode = indexPath;
            } else {
                cell.selectedView.image = nil;
            }
            return cell;
        } else {
            SettingTrainingModeCell *cell = (SettingTrainingModeCell *)[tableView dequeueReusableCellWithIdentifier:@"ReadingFollowCell"];
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingTrainingModeCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
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
                cell.selectedView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath, @"checked.png"]];
                self.pathReadingMode = indexPath;
            } else {
               cell.selectedView.image = nil;
            }
            return cell;
        }
    } else if (nSection == 1) {
        SettingSwitchCell* cell = (SettingSwitchCell*)[tableView dequeueReusableCellWithIdentifier:@"SettingSwitchCell"];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingSwitchCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.label.text = STRING_SETTING_LOOP_TEXT;
            cell.switchControl.tag = LOOPCONTROL_TAG;
            cell.switchControl.on = settingData.bLoop;
            cell.delegate = (id)self;
            return cell;
        }
    } else if (nSection == 2) {
        
       SettingShowTranslationCell * cell =  (SettingShowTranslationCell*)[tableView dequeueReusableCellWithIdentifier:@"SettingShowTranslationCell"];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingShowTranslationCell" owner:self options:nil];
            cell = [array objectAtIndex:0];

        }
        VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
        if (app.configData.bShowTranslateText) {
            switch (nRow) {
                case 0:
                    cell.textLabelTrans.text = STRING_SHOW_SRC_TEXT;
                    break;
                case 1:
                    cell.textLabelTrans.text = STRING_SHOW_SRCANDTRANS_TEXT;
                    break;
                case 2:
                    cell.textLabelTrans.text = STRING_SHOW_NO_TEXT;
                    break;
                    
                default:
                    break;
            }
            if (settingData.eShowTextType == nRow) {
                self.pathShowText = indexPath;
                cell.selectedView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath, @"checked.png"]];
            } else {
                cell.selectedView.image = nil;
            }

        } else {
            switch (nRow) {
                case 0:
                {
                    if (settingData.eShowTextType == SHOW_TEXT_TYPE_SRC) {
                        self.pathShowText = indexPath;
                        cell.selectedView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath, @"checked.png"]];
                    } else {
                        cell.selectedView.image = nil;
                    }

                    cell.textLabelTrans.text = STRING_SHOW_SRC_TEXT;
                    break;
                }
                case 1:
                {
                    if (settingData.eShowTextType == SHOW_TEXT_TYPE_NONE) {
                        self.pathShowText = indexPath;
                        cell.selectedView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath, @"checked.png"]];
                    } else {
                        cell.selectedView.image = nil;
                    }

                    cell.textLabelTrans.text = STRING_SHOW_NO_TEXT;
                    break;
                }
                default:
                    break;
            }

        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (nSection == 3) {
        SettingSwitchCell* cell = (SettingSwitchCell*)[tableView dequeueReusableCellWithIdentifier:@"SettingSwitchCell"];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingSwitchCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.label.text = STRING_DAY_CONTROL;
            cell.switchControl.tag = DAYCONTROL_TAG;
            cell.switchControl.on = settingData.bShowDay;
            cell.delegate = (id)self;
            return cell;
        }
        return cell;
    } else if (nSection == 4) {
        UITableViewCell * cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"otherAbout"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherAbout"] autorelease];
        }
        cell.textLabel.text = STRING_ABOUT_US;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    // Configure the cell...
    UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    return cell;
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
        if (nRow != (NSInteger)self.pathReadingMode.row) {
            SettingTrainingModeCell* cellOld = (SettingTrainingModeCell*)[self.tableView cellForRowAtIndexPath:self.pathReadingMode];
            cellOld.selectedView.image = nil;
            self.pathReadingMode = indexPath;
            
            SettingShowTranslationCell* cell = (SettingShowTranslationCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.selectedView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath, @"checked.png"]];
            settingData.eReadingMode = nRow;
            
            [settingData saveSettingData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGED_SETTING_VALUE object:nil];
        }
    } else if (indexPath.section == 2) {
        NSInteger nRow = indexPath.row;
        if (nRow != (NSInteger)self.pathShowText.row) {
            SettingShowTranslationCell* cellOld = (SettingShowTranslationCell*)[self.tableView cellForRowAtIndexPath:self.pathShowText];
            cellOld.selectedView.image = nil;
            self.pathShowText = indexPath;

            SettingShowTranslationCell* cell = (SettingShowTranslationCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.selectedView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath, @"checked.png"]];
            
            VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
            if (app.configData.bShowTranslateText) {
                settingData.eShowTextType = nRow;
            } else {
                if (nRow == 0) {
                    settingData.eShowTextType = SHOW_TEXT_TYPE_SRC;
                } else if (nRow == 1){
                    settingData.eShowTextType = SHOW_TEXT_TYPE_NONE;
                }
            }

            [settingData saveSettingData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGED_SETTING_VALUE object:nil];
        }
    } else if (indexPath.section == 4) {
        SettingAboutViewController* about = [[SettingAboutViewController alloc] initWithNibName:@"SettingAboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
        [about release];
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

- (void)isOn:(BOOL)bOn withTag:(NSInteger)tag;
{
    if (tag == LOOPCONTROL_TAG) {
        if (settingData.bLoop != bOn) {
            settingData.bLoop = bOn;
            [settingData saveSettingData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGED_SETTING_VALUE object:nil];
        }
    } else {
        if (settingData.bShowDay != bOn) {
            settingData.bShowDay = bOn;
            [settingData saveSettingData];
        }
    }
}

- (void)backToSelectedViewController;
{
    self.tabBarController.selectedIndex = 0;
}
@end
