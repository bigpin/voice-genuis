//
//  LessonsViewController.m
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LessonsViewController.h"
#import "ListeningViewController.h"
#import "SettingViewController.h"
#import "LessonCell.h"
#import "BubbleCell.h"
#import "VoiceAppDelegate.h"

@implementation LessonsViewController
@synthesize scenesName = _scenesName;
@synthesize pageSegment = _pageSegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    nSelectedPage = 0;
    
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    nPageCount = IS_IPAD ? app.nPageCountOfiPad : app.nPageCountOfiPhone;
    return self;
}

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
	[_courseParser release];
    [self.scenesName release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)loadView 
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* backString = STRING_BACK;
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self loadCourses];
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.bPagination) {
        if ([_courseParser.course.lessons count] > nPageCount) {
            [self loadToolbarItems];
        } else {
            app.bPagination = NO;
        }
    } 
    
    if (app.bLessonViewAsRootView) {
        NSString* displayName = [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleDisplayName"];
        self.title = displayName;
        UIBarButtonItem* itemSetting = [[UIBarButtonItem alloc] initWithTitle:STRING_SETTING
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(onSetting:)];
        self.navigationItem.rightBarButtonItem = itemSetting;
        [itemSetting release];
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
    [self.tableView reloadData];
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
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{
    [self.tableView reloadData];
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
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!(app.bPagination)) {
        return [_courseParser.course.lessons count];
    } else {
        NSInteger nCount = (nSelectedPage+1) * nPageCount;
        if (nCount <= [_courseParser.course.lessons count]) {
            return nPageCount;
        } else {
            return (nPageCount - (nCount - [_courseParser.course.lessons count]));
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* static NSString *CellIdentifier = @"Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
     }
     
     if (indexPath.row < [_courseParser.course.lessons count]) {
     Lesson * lesson = [_courseParser.course.lessons objectAtIndex:indexPath.row];
     cell.textLabel.text = lesson.title;
     cell.textLabel.numberOfLines = 0;
     cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     }*/
    // Configure the cell...
    static NSString *CellIdentifier = @"LessonCell";
    
    LessonCell *cell = (LessonCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[LessonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }else {
        [cell cleanUp];
    }
    
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSInteger nPostion = nSelectedPage * nPageCount + indexPath.row;
    if (!(app.bPagination)) {
        nPostion = indexPath.row;
    }
    if (nPostion < [_courseParser.course.lessons count]) {
        Lesson * lesson = [_courseParser.course.lessons objectAtIndex:nPostion];
        cell.lessonTitle = lesson.title;
        cell.useDarkBackground = (nPostion % 2 == 0);
        cell.nIndex = nPostion;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } else {
        UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LessonCellBlank"] autorelease];
        return cell;
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.bPagination) {
        NSInteger nPostion = nSelectedPage*nPageCount + indexPath.row;
        if (nPostion < ([_courseParser.course.lessons count])) {
            LessonCell *cell = (LessonCell*)[self tableView: tableView cellForRowAtIndexPath: indexPath];
            CGSize size   = [BubbleCell calcTextHeight:cell.lessonTitle withWidth:cell.frame.size.width  - CELL_CONTENT_MARGIN*2 - MAGIN_OF_LESSON_TITLE - MAGIN_OF_RIGHT];
            return size.height + 44;
            
        } else {
            return 44;
        }

    } else {
        LessonCell *cell = (LessonCell*)[self tableView: tableView cellForRowAtIndexPath: indexPath];
        CGSize size   = [BubbleCell calcTextHeight:cell.lessonTitle withWidth:cell.frame.size.width  - CELL_CONTENT_MARGIN*2 - MAGIN_OF_LESSON_TITLE - MAGIN_OF_RIGHT];
        return size.height + 44;        
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
    ListeningViewController *detailViewController = [[ListeningViewController alloc] initWithNibName:@"ListeningViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [_courseParser loadLesson:indexPath.row];
    Lesson* lesson = (Lesson*)[_courseParser.course.lessons objectAtIndex:indexPath.row];
    detailViewController.sentencesArray = lesson.setences;
    detailViewController.teachersArray = lesson.teachers;
    detailViewController.wavefile = lesson.wavfile;
    detailViewController.isbfile = lesson.isbfile;
    detailViewController.navigationItem.title = lesson.title; 
    [self.navigationController pushViewController:detailViewController animated:YES];

    [detailViewController release];
    

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)loadCourses
{
    if (_courseParser != nil) {
        return;
    }
    _courseParser = [[CourseParser alloc] init];
    
	// Load and parse the books.xml file
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = STRING_RESOURCE_DATA;
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    if (self.scenesName != nil) {
        resourcePath = [NSString stringWithFormat:@"/%@/%@", resourcePath, self.scenesName];
    }
    NSString* indexString = STRING_LESSONS_INDEX_XML;
    _courseParser.resourcePath = resourcePath;
    [_courseParser loadCourses:indexString];
 }

- (void) loadToolbarItems;
{
    self.navigationController.toolbarHidden = NO;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    // Flexible Space
    UIBarButtonItem* itemFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Flexed Space
    UIBarButtonItem* itemFlexedSpaceSmall = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    itemFlexedSpaceSmall.width = 5;
    
    // Flexed Space
    UIBarButtonItem* itemFlexedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    itemFlexedSpace.width = IS_IPAD ? 35.0 : 2.0;
    /*itemFlexedSpace.width = [[UIDevice currentDevice] userInterfaceIdiom] == [UIUserInterfaceIdiomPad]? 35.0 : 20.0;*/
    
    [items addObject:itemFlexibleSpace];
    
    // Previous
    [items addObject:itemFlexedSpaceSmall];
    UIBarButtonItem* itemPrevious = [[UIBarButtonItem alloc] initWithTitle:STRING_PRE_PAGE
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(onPrevious:)];
    [items addObject:itemPrevious];
    //self.previousItem = itemPrevious;
    [itemPrevious release];
    
    // playImage
    [items addObject:itemFlexedSpace];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger nMode = [_courseParser.course.lessons count] % nPageCount;
    NSInteger nCountTemp =[_courseParser.course.lessons count] / nPageCount;
    NSInteger nCount = nMode == 0 ? nCountTemp : (nCountTemp + 1);
    for (NSInteger i = 0; i < nCount; i++) {
        [array addObject:[NSString stringWithFormat:@"    %d    ", (i+1)]];
    }
    UISegmentedControl* seg = [[UISegmentedControl alloc] initWithItems:array];
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    seg.tintColor = [UIColor colorWithRed:app.naviRed green:app.naviGreen blue:app.naviBlue alpha:1.0];
    [array release];
    UIBarButtonItem* itemPlay = [[UIBarButtonItem alloc] initWithCustomView:seg];
    [items addObject:itemPlay];
    [seg addTarget:self action:@selector(onSelectedPage:) forControlEvents:UIControlEventValueChanged];
    self.pageSegment = seg;
    self.pageSegment.selectedSegmentIndex = nSelectedPage;
    self.pageSegment.momentary = NO;
    [itemPlay release];
    
    // nextImage
    [items addObject:itemFlexedSpace];
    UIBarButtonItem* itemNext = [[UIBarButtonItem alloc] initWithTitle:STRING_NEXT_PAGE
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(onNext:)];
    [items addObject:itemNext];
    //self.nextItem = itemNext;
    [itemNext release];
    
    
    
    [items addObject:itemFlexedSpaceSmall];
    [items addObject:itemFlexibleSpace];
    
    [itemFlexibleSpace release];
    [itemFlexedSpace release];
    [itemFlexedSpaceSmall release];
    [self setToolbarItems:items animated:YES];
    [items release];
    
}

- (void) onPrevious:(id)sender;
{
    if (nSelectedPage > 0) {
        nSelectedPage --;
        self.pageSegment.selectedSegmentIndex = nSelectedPage;
        [self.tableView reloadData];
    }
}

- (void) onNext:(id)sender;
{
    NSInteger nSegmentNum = self.pageSegment.numberOfSegments;
    if (nSelectedPage < (nSegmentNum-1)) {
        nSelectedPage ++;
        self.pageSegment.selectedSegmentIndex = nSelectedPage;
        [self.tableView reloadData];
    }
    
}

- (void) onSelectedPage:(id)sender;
{
    NSInteger nSelected = self.pageSegment.selectedSegmentIndex;
    if (nSelected != nSelectedPage) {
        nSelectedPage = nSelected;
        [self.tableView reloadData];
    }
}

- (void) onSetting:(id)sender;
{
    SettingViewController* setting = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    NSString* settingTitle = STRING_SETTING_TITLE;
    setting.title = settingTitle;
    [self.navigationController pushViewController:setting animated:YES];
    [setting release];
}

@end
