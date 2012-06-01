//
//  DayParser.m
//  Voice
//
//  Created by JiaLi on 12-5-15.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import "DayParser.h"
@implementation EveryDay
@synthesize orintext = _orintext;
@synthesize transtext = _transtext;
@synthesize wordsArray = _wordsArray;
/*
 <w>
 <txt>be frank with</txt>
 <pro></pro>
 <pos></pos>
 <def>对……坦白、直率</def>
 </w>
*/

/*
 wordsArray:
 @"txt"
 @"pro"
 @"def"
 */
- (void)dealloc
{
    [self.orintext release];
    [self.transtext release];
    [self.wordsArray release];
    [super dealloc];
}
@end

@implementation DayParser
@synthesize everydaySentences = _everydaySentences;

- (id) init
{
    self = [super init];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    self.everydaySentences = array;
    [array release];
    return self;
}

- (void) dealloc
{
    [self.everydaySentences release];
    [_resourcePath release];
    _resourcePath = nil;
    [super dealloc];
}

- (void)loadWord:(TBXMLElement*)parentElement withDic:(NSMutableDictionary*)dic
{
    TBXMLElement* wdElement = [TBXML childElementNamed:@"wd" parentElement:parentElement];
    
    if (wdElement == nil) {
        return;
    }
    TBXMLElement* wordElement = [TBXML childElementNamed:@"w" parentElement:wdElement];
    NSMutableArray* wordArray = [[NSMutableArray alloc] init];
        
    while (wordElement) {
        NSMutableDictionary* wordDic = [[NSMutableDictionary alloc] init];
        TBXMLElement* txtElem = [TBXML childElementNamed:@"txt" parentElement:wordElement];
        if (txtElem != nil) {
            NSString* txt = [TBXML textForElement:txtElem];
            if (txt != nil) {
                [wordDic setObject:txt forKey:@"txt"];
                //NSLog(@"%@", txt);
            }
        }
        
        TBXMLElement* proElem = [TBXML childElementNamed:@"pro" parentElement:wordElement];;
        if (proElem != nil) {
            NSString* pro = [TBXML textForElement:proElem];
            if (pro != nil) {
                [wordDic setObject:pro forKey:@"pro"];
                //NSLog(@"%@", pro);
            }
        }
        TBXMLElement* defElem = [TBXML childElementNamed:@"def" parentElement:wordElement];;
        if (defElem != nil) {
            NSString* def = [TBXML textForElement:defElem];
            if (def != nil) {
                [wordDic setObject:def forKey:@"def"];
                //NSLog(@"%@", def);
            }
        }
        [wordArray addObject:wordDic];
        [wordDic release];
        wordElement = [TBXML nextSiblingNamed:@"w" searchFromElement:wordElement];
     }
    if ([wordArray count] > 0) {
        [dic setObject:wordArray forKey:@"words"];
        [wordArray release];
    } else {
        [wordArray release];
    }
}

- (void)loadSentence:(TBXMLElement*)parentElement
{
    TBXMLElement* para = [TBXML childElementNamed:@"p" parentElement:parentElement];
    if (para) {
         TBXMLElement* sentenceElement =  [TBXML childElementNamed:@"s" parentElement:para];
        while (sentenceElement) {
            NSMutableDictionary* sentenceDic = [[NSMutableDictionary alloc] init];
           // 原文
            TBXMLElement* orintext = [TBXML childElementNamed:@"ot" parentElement:sentenceElement];
            if (orintext) {
                NSString* ori = [TBXML textForElement:orintext];
                if (ori != nil) {
                    [sentenceDic setObject:ori forKey:@"orintext"];
                    //NSLog(@"%@", ori);
                }
            }
            // 译文
            TBXMLElement* transtext = [TBXML childElementNamed:@"tt" parentElement:sentenceElement];
            if (transtext) {
                NSString* trans = [TBXML textForElement:transtext];
                if (trans != nil) {
                    [sentenceDic setObject:trans forKey:@"transtext"];
                   // NSLog(@"%@", trans);
               }
            }
            [self loadWord:sentenceElement withDic:sentenceDic];
            [self.everydaySentences addObject:sentenceDic];
            [sentenceDic release];
            sentenceElement =  [TBXML nextSiblingNamed:@"s" searchFromElement:sentenceElement];
        }
    }
}

- (void)loadData:(NSString*)path;
{
    if (path != nil) {
        _resourcePath = [[NSString alloc] initWithFormat:@"%@", path];
    } else {
        return;
    }
    
    if ([_everydaySentences count] > 0) {
        return;
    }
    NSData* filedata = [NSData dataWithContentsOfFile:_resourcePath];
   TBXML* tbxml = [[TBXML tbxmlWithXMLData:filedata] retain];
	
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
    if (root) {
        TBXMLElement * body = [TBXML childElementNamed:@"body" parentElement:root];
		if (body) {
            TBXMLElement * textstream = [TBXML childElementNamed:@"textstream" parentElement:body];
            if (textstream) {
                [self loadSentence:textstream];
            }
		}

    }
	
	if (root) {
		
	}
	[tbxml release];

}

@end
