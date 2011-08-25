//===========================================================================
// class CWaveFile
//
// 功能：	实现wav文件的操作
//===========================================================================

#pragma once

//===========================================================================

#include <vector>
typedef std::pair<int, int> IntPair;
typedef std::vector<IntPair> IntPairVector;


//===========================================================================
//	RIFF WAV文件结构(未压缩)
//	__________________________
//	| RIFF WAVE Chunk		   |
//	|   groupID  = 'RIFF'      |
//	|   riffType = 'WAVE'      |
//	|    __________________    |
//	|   | Format Chunk     |   |
//	|   |	ckID = 'fmt '  |   |
//	|   |__________________|   |
//	|    __________________    |
//	|   | Sound Data Chunk |   |
//	|   |	ckID = 'data'  |   |
//	|   |__________________|   |
//	|__________________________|

//===========================================================================
//	定义RIFF Header数据结构
//
//	RIFF Header
//	A RIFF file has an 8-byte RIFF header, identifying the file, 
//	and giving the residual length after the header (i.e. file_length - 8):
//	struct {     
//	 	char  id[4];  	// identifier string = "RIFF"
//		unsigned long len;    	// remaining length after this header
//	} riff_hdr;
//
//	The riff_hdr is immediately followed by a 4-byte data type identifier.  
//	For .WAV files this is "WAVE" as follows:
//	char wave_id[4];	// WAVE file identifier = "WAVE"

#define DEFAULT_RIFF_TYPE "WAVE"
#define DEFAULT_RIFF_ID "RIFF"

typedef struct _riffHeader
{
	char groupId[4];			// "RIFF"
	unsigned long chunkSize;	// remaining length of this header, not including length of groupdId and len
	char riffTypeId[4];			// "WAVE"

} RiffHeader, *LPRiffHeader;

//===========================================================================
// 定义Format Chunk数据结构, 仅对wFormatTag为WAVE_FORMAT_PCM情况适用
//
//	The WAVE form is defined as follows. 
//	Programs must expect(and ignore) any unknown chunks encountered, as with all RIFF forms. 
//	However, <fmt-ck> must always occur before <wave-data>, 
//	and both of these chunks are mandatory in a WAVE file.
//	<WAVE-form> ->
//	RIFF( 'WAVE'
//		 <fmt-ck>     		// Format
//		[<fact-ck>]  		// Fact chunk
//		[<cue-ck>]  		// Cue points
//		[<playlist-ck>] 		// Playlist
//		[<assoc-data-list>] 	// Associated data list
//		<wave-data>   ) 		// Wave data

#define DEFAULT_FMT_ID "fmt"

// 定义win32中的WAVE_FORMAT_PCM
#ifndef WAVE_FORMAT_PCM
#define WAVE_FORMAT_PCM 0x0001
#endif

// 定义WAVEFORMATEX
typedef struct tWAVEFORMATEX
{
	unsigned short      wFormatTag;		/* format type */
	unsigned short      nChannels;		/* number of channels (i.e. mono, stereo...) */
	unsigned long		nSamplesPerSec;     /* sample rate */
	unsigned long		nAvgBytesPerSec;    /* for buffer estimation */
	unsigned short      nBlockAlign;		/* block size of data */
	unsigned short      wBitsPerSample;   /* number of bits per sample of mono data */
	unsigned short      cbSize;            /* the count in bytes of the size of */
} WAVEFORMATEX;

// 定义format chunk 信息
typedef struct _formatchunk
{
	char chunkId[4];			// "fmt"
	unsigned long chunkSize;	// numbers of bits of this chunk, not including chunkId and chunkSize

	WAVEFORMATEX waveFormatEx;

} FormatChunk, *LPFormatChunk;

//	定义Data Chunk数据结构
#define DEFAULT_DATA_ID "data"

typedef struct _datachunkheader
{
	char chunkId[4];
	unsigned long chunkSize;			// numbers of bits in the chunk, not including chuckId and chunkSize

} DataChunkHeader, *LPDataChunkHeader;

//===========================================================================
// 定义Fact Chunk数据结构
#define DEFAULT_FACT_ID "fact"

typedef struct _factchunk
{
	char chunkId[4];
	unsigned long chunkSize;

	unsigned long dwFileSize;			// numbers of samples before compress
} FactChunk, *LPFactChunk;

//===========================================================================
//定义音频文件类
class CWaveFile
{
public:
	CWaveFile();
	~CWaveFile();

public:
	// 打开wave文件，并读入header信息
	bool Open(const char* lpszFileName);	
	// 关闭wave文件
	void Close();

public:
	// 读取裸音频数据
	unsigned int ReadBytes(void* pData, unsigned int nCount);	
	unsigned long long Seek(long long lOffset) ;

public:
	// 返回wave文件的formatex信息
	WAVEFORMATEX GetWaveFormat() const { return m_format.waveFormatEx; }
	bool ReadWaveData(unsigned long dwStartMilli, unsigned long dwEndMilli, unsigned char* &pBuffer, unsigned long &nBufferSize);
	bool ReadAllWaveData(unsigned char* &pBuffer, unsigned long &nBufferSize);
    
private:
	// 读取wave文件的Format信息，被Open调用来设置m_format
	void ReadHeader();

private:
	FILE* m_wavFile;					// wave文件

	FormatChunk m_format;				// wav文件格式
	unsigned long m_dwDataChunkSize;	// 数据部分的长度
	unsigned long long m_nDataStartFrom;			// 裸音频数据开始的位置
	unsigned long m_nBytesWritten;		// 已写入字节数
};

//===========================================================================

void GetWaveSample(const WAVEFORMATEX sWaveFormatEx,
					unsigned char *pWaveData,
					unsigned long nWaveByte,
					const int nSamplesPerSecond,
					const int nWindowHeight,
					IntPairVector& WaveSampleVector);

//===========================================================================