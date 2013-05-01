//
//  isaybios.h
//  isaybios
//
//  Created by kouyuhuoban on 13-3-23.
//  Copyright (c) 2013年 Isayb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _ISAYB5WORD
{
	char text[128]; // 单词
	char pronun[128]; // 发音
	float curve[40];// 音高曲线
	float fTimeSt; // 开始时间
	float fTimeEd; // 结束时间
	float fFY;     // 发音
	float fSC;     // 时长
	float fYL;     // 音量
	float fYG;     // 音高
} ISAYB5WORD;

@interface isaybios : NSObject

{
    
}

+(bool) ISAYB_SetModel:(const char * )model;
+(bool) ISAYB_SetLesson:(const char *)filename;
+(bool) ISAYB_Recognition:(const char *)sentence From:(short *)pWAV Length:(int)nWAV  To:(ISAYB5WORD **)pISAYB3WORD Length:(int *)nISAYB3WORD AndScore:(int*)score;

@end
