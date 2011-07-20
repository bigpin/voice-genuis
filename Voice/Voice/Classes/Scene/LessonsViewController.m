//
//  LessonsViewController.m
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LessonsViewController.h"
#import "ListeningViewController.h"


@implementation LessonsViewController
@synthesize scenesName = _scenesName;

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
	for (int i = 0; i < [course.lessons count]; i++) {
		[[course.lessons objectAtIndex:i] release];
	}
	[course.lessons release];
	
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"lessons";
    [self loadCourses];
	for (int i = 0; i < [course.lessons count]; i++) {
		[self loadLesson:[course.lessons objectAtIndex:i]];
	}
    //[self loadLessonsFolder];
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
    return [course.lessons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.row < [course.lessons count]) {
        Lesson * lesson = [course.lessons objectAtIndex:indexPath.row];
        cell.textLabel.text = lesson.title;
    }
     // Configure the cell...
    
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
    ListeningViewController *detailViewController = [[ListeningViewController alloc] initWithNibName:@"ListeningViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [ListeningViewController release];

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)loadURL {
	// Load and parse an xml string
	tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.w3schools.com/XML/note.xml"]];
	
	// If TBXML found a root node, process element and iterate all children
	if (tbxml.rootXMLElement)
		[self traverseElement:tbxml.rootXMLElement];
	
	// release resources
	[tbxml release];
}

- (void)loadXMLString {
	// Load and parse an xml string
	tbxml = [[TBXML alloc] initWithXMLString:@"<root><elem1 attribute1=\"elem1-attribute1\"/><elem2 attribute2=\"attribute2\"/></root>"];
	
	// If TBXML found a root node, process element and iterate all children
	if (tbxml.rootXMLElement)
		[self traverseElement:tbxml.rootXMLElement];
	
	// release resources
	[tbxml release];
}

- (void)loadXMLData {
	// Load and parse an NSData object
	NSString * xmlString = @"<root><elem1 attribute1=\"elem1-attribute1\"/><elem2 attribute2=\"attribute2\"/></root>";
	NSData * xmlData = [xmlString dataUsingEncoding:NSASCIIStringEncoding];
	
	tbxml = [[TBXML alloc] initWithXMLData:xmlData];
	
	// If TBXML found a root node, process element and iterate all children
	if (tbxml.rootXMLElement)
		[self traverseElement:tbxml.rootXMLElement];
	
	// release resources
	[tbxml release];
}

- (void)loadBooks {
}

- (void)loadUnknownXML {	
	// Load and parse the books.xml file
	tbxml = [[TBXML alloc] initWithXMLFile:@"books" fileExtension:@"xml"];
	
	// If TBXML found a root node, process element and iterate all children
	if (tbxml.rootXMLElement)
		[self traverseElement:tbxml.rootXMLElement];
	
	// release resources
	[tbxml release];
}

- (void) traverseElement:(TBXMLElement *)element {
	
	do {
		// Display the name of the element
		NSLog(@"%@",[TBXML elementName:element]);
		
		// Obtain first attribute from element
		TBXMLAttribute * attribute = element->firstAttribute;
		
		// if attribute is valid
		while (attribute) {
			// Display name and value of attribute to the log window
			NSLog(@"%@->%@ = %@",[TBXML elementName:element],[TBXML attributeName:attribute], [TBXML attributeValue:attribute]);
			
			// Obtain the next attribute
			attribute = attribute->next;
		}
		
		// if the element has child elements, process them
		if (element->firstChild) [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
	} while ((element = element->nextSibling));  
}

- (void)loadCourses
{
	// Load and parse the books.xml file
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = STRING_RESOURCE_DATA;
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    resourcePath = [NSString stringWithFormat:@"/%@/%@", resourcePath, self.scenesName];
    NSString* indexString = STRING_LESSONS_INDEX_XML;
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, indexString]; 
    NSData* d = [NSData dataWithContentsOfFile:resourcePath];
	tbxml = [[TBXML tbxmlWithXMLData:d] retain];
	
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
		TBXMLElement * body = [TBXML childElementNamed:@"body" parentElement:root];
		if (body) {
			if (!course) {
				course = [[Course alloc]init];
			}
			// metas
			TBXMLElement* metas = [TBXML childElementNamed:@"metas" parentElement:body];
			[self loadMetadata:metas];
			// lessons
			TBXMLElement* lessons = [TBXML childElementNamed:@"lessons" parentElement:body];
			[self loadLessons:lessons];
		}
		
	}
	[tbxml release];
	
}

- (void)loadMetadata:(TBXMLElement*)element
{
	if (element) {
		TBXMLElement* meta = [TBXML childElementNamed:@"meta" parentElement:element];
		while (meta) {
			// title
			TBXMLElement* title = [TBXML childElementNamed:@"title" parentElement:meta];
			if (title) {
				course.title = [TBXML textForElement:title];
			}
			// subject
			TBXMLElement* subject = [TBXML childElementNamed:@"subject" parentElement:meta];
			if (subject) {
				course.subject = [TBXML textForElement:subject];
			}
			// level
			TBXMLElement* level = [TBXML childElementNamed:@"level" parentElement:meta];
			if (level) {
				course.level = [[TBXML textForElement:level] integerValue];
			}
			// language
			TBXMLElement* language = [TBXML childElementNamed:@"language" parentElement:meta];
			if (language) {
				course.language = [TBXML textForElement:language];
			}
			
			meta = nil; // [TBXML nextSiblingNamed:@"meta" searchFromElement:meta];
		} 
	}
}

- (void)loadLessons:(TBXMLElement*)element
{
	if (element) {
		int lessonsCount = [[TBXML valueOfAttributeNamed:@"count" forElement:element] integerValue];
		course.lessons = [[NSMutableArray alloc]initWithCapacity:lessonsCount];
		
		TBXMLElement* lessonElement = [TBXML childElementNamed:@"lesson" parentElement:element];
		while (lessonElement) {
			Lesson* lesson = [[Lesson alloc]init];
			lesson.title = [TBXML valueOfAttributeNamed:@"title" forElement:lessonElement];
			lesson.lessonid = [TBXML valueOfAttributeNamed:@"id" forElement:lessonElement];
			lesson.order = [[TBXML valueOfAttributeNamed:@"order" forElement:lessonElement] integerValue];
			lesson.path = [TBXML valueOfAttributeNamed:@"path" forElement:lessonElement];
			lesson.file = [TBXML valueOfAttributeNamed:@"file" forElement:lessonElement];
			[course.lessons addObject:lesson];
			lessonElement = [TBXML nextSiblingNamed:@"lesson" searchFromElement:lessonElement];
		}
	}
}

- (void)loadLesson:(Lesson *)lesson
{
	if (lesson) {
		// load file
		NSString* filepath = lesson.path;
		filepath = [filepath stringByAppendingPathComponent:lesson.file];
		tbxml = [[TBXML tbxmlWithXMLFile:@"cnl-sjy-301.xml"] retain];
		
		TBXMLElement* root = tbxml.rootXMLElement;
		if (root) {
			TBXMLElement* body = [TBXML childElementNamed:@"body" parentElement:root];
			if (body) {
				// load sentences
				TBXMLElement* textStream = [TBXML childElementNamed:@"textstream" parentElement:body];
				if (textStream) {
					lesson.setences = [[NSMutableArray alloc] init];
					[self loadSentence:textStream toSentences:lesson.setences];
				}
				// load teachers
				TBXMLElement* teachers = [TBXML childElementNamed:@"teachers" parentElement:body];
				if (teachers) {
					lesson.teachers = [[NSMutableArray alloc] init];
					[self loadTeacher:teachers toTeachers:lesson.teachers];
				}
				// get wav file
				TBXMLElement* media = [TBXML childElementNamed:@"media" parentElement:body];
				if (media) {
					TBXMLElement* file = [TBXML childElementNamed:@"file" parentElement:media];
					if (file) {
						lesson.wavfile = [TBXML valueOfAttributeNamed:@"src" forElement:file];
					}
				}
			}
		}
		[tbxml release];
	}
}

- (void)loadSentence:(TBXMLElement *)element toSentences:(NSMutableArray *)sentences
{
	if (element) {
		// paragraph
		TBXMLElement* para = [TBXML childElementNamed:@"p" parentElement:element];
		while (para) {
			TBXMLElement* sentenceEle = [TBXML childElementNamed:@"s" parentElement:para];
			while (sentenceEle) {
				Sentence* sentence = [[Sentence alloc] init];
				sentence.starttime = [TBXML valueOfAttributeNamed:@"st" forElement:sentenceEle];
				sentence.endtime = [TBXML valueOfAttributeNamed:@"et" forElement:sentenceEle];
				sentence.techerid = [TBXML valueOfAttributeNamed:@"t" forElement:sentenceEle];
				TBXMLElement* orintext = [TBXML childElementNamed:@"ot" parentElement:sentenceEle];
				if (orintext) {
					sentence.orintext = [TBXML textForElement:orintext];
				}
				TBXMLElement* transtext = [TBXML childElementNamed:@"tt" parentElement:sentenceEle];
				if (transtext) {
					sentence.transtext = [TBXML textForElement:transtext];
				}
				TBXMLElement* ps = [TBXML childElementNamed:@"ps" parentElement:sentenceEle];
				if (ps) {
					sentence.ps = [TBXML textForElement:ps];
				}
				[sentences addObject:sentence];
				sentenceEle = [TBXML nextSiblingNamed:@"s" searchFromElement:sentenceEle];
			}
			para = [TBXML nextSiblingNamed:@"p" searchFromElement:para];
		}
	}
}

- (void) loadTeacher:(TBXMLElement *)element toTeachers:(NSMutableArray *)teachers
{
	if (element) {
		TBXMLElement* teacherEle = [TBXML childElementNamed:@"teacher" parentElement:element];
		while (teacherEle) {
			Teacher* teacher = [[Teacher alloc] init];
			teacher.teacherid = [TBXML valueOfAttributeNamed:@"id" forElement:teacherEle];
			TBXMLElement* surname = [TBXML childElementNamed:@"surname" parentElement:teacherEle];
			teacher.surname = [TBXML textForElement:surname];
			TBXMLElement* name = [TBXML childElementNamed:@"name" parentElement:teacherEle];
			teacher.name = [TBXML textForElement:name];
			TBXMLElement* description = [TBXML childElementNamed:@"description" parentElement:teacherEle];
			teacher.description = [TBXML textForElement:description];
			TBXMLElement* gender = [TBXML childElementNamed:@"gender" parentElement:teacherEle];
			teacher.gender = [TBXML textForElement:gender];
			TBXMLElement* avatar = [TBXML childElementNamed:@"avatar" parentElement:teacherEle];
			teacher.avatar = [TBXML textForElement:avatar];
			[teachers addObject:teacher];
			teacherEle = [TBXML nextSiblingNamed:@"teache" searchFromElement:teacherEle];
		}
	}
}

@end
