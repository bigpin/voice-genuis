//
//  VoicePlayer.h
//  Voice
//
//  Created by Ding Li on 11-8-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

//start(AudioQueueStart)开始录音或者播放队列
//Prime(AudioQueuePrime)只对播放有用，在start之前调用，确保有足够可用的数据用于播放；
//Stop（AudioQueueStop）重置audio queue，停止录音或者播放，当没有更多的data需要播放时，播放audio queue将会回调这个函数。
//Pause（AudioQueuePause）仅仅是暂停，调用START继续
//Flush（AudioQueueFlush）在使用最后一个queue时调用，确保所有缓存过的数据；
//Reset（AudioQueueReset）Call to immediately silence an audio queue, remove all buffers from previously scheduled use, and reset all decoder and DSP state.
//Synchronous stopping happens immediately, without regard for previously buffered audio data.
//Asynchronous stopping happens after all queued buffers have been played or recorded.

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>

#define NUM_BUFFERS 3

@interface VoicePlayer : NSObject {
    
    //播放音频文件ID
    AudioFileID audioFile;
    
    //音频流描述对象
    AudioStreamBasicDescription dataFormat;
    
    //音频队列
    AudioQueueRef queue;
    
    SInt64 packetIndex;
    
    UInt32 numPacketsToRead;
    
    UInt32 bufferByteSize;
    
    AudioStreamPacketDescription *packetDescs;
    
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    
}

//定义队列为实例属性

@property AudioQueueRef queue;

//播放方法定义

- (void) play:(CFURLRef) path;

//定义缓存数据读取方法

- (void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue
                       queueBuffer:(AudioQueueBufferRef)audioQueueBuffer;

//定义回调（Callback）函数

static void BufferCallback(void *inUserData, AudioQueueRef inAQ,
                           AudioQueueBufferRef buffer);

//定义包数据的读取方法

- (UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer;

@end
@end
