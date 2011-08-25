//===========================================================================
// class CWaveFile
//
// ���ܣ�	ʵ��wav�ļ��Ĳ���
//===========================================================================

#pragma once

//===========================================================================

#include <vector>
typedef std::pair<int, int> IntPair;
typedef std::vector<IntPair> IntPairVector;


//===========================================================================
//	RIFF WAV�ļ��ṹ(δѹ��)
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
//	����RIFF Header���ݽṹ
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
// ����Format Chunk���ݽṹ, ����wFormatTagΪWAVE_FORMAT_PCM�������
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

// ����win32�е�WAVE_FORMAT_PCM
#ifndef WAVE_FORMAT_PCM
#define WAVE_FORMAT_PCM 0x0001
#endif

// ����WAVEFORMATEX
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

// ����format chunk ��Ϣ
typedef struct _formatchunk
{
	char chunkId[4];			// "fmt"
	unsigned long chunkSize;	// numbers of bits of this chunk, not including chunkId and chunkSize

	WAVEFORMATEX waveFormatEx;

} FormatChunk, *LPFormatChunk;

//	����Data Chunk���ݽṹ
#define DEFAULT_DATA_ID "data"

typedef struct _datachunkheader
{
	char chunkId[4];
	unsigned long chunkSize;			// numbers of bits in the chunk, not including chuckId and chunkSize

} DataChunkHeader, *LPDataChunkHeader;

//===========================================================================
// ����Fact Chunk���ݽṹ
#define DEFAULT_FACT_ID "fact"

typedef struct _factchunk
{
	char chunkId[4];
	unsigned long chunkSize;

	unsigned long dwFileSize;			// numbers of samples before compress
} FactChunk, *LPFactChunk;

//===========================================================================
//������Ƶ�ļ���
class CWaveFile
{
public:
	CWaveFile();
	~CWaveFile();

public:
	// ��wave�ļ���������header��Ϣ
	bool Open(const char* lpszFileName);	
	// �ر�wave�ļ�
	void Close();

public:
	// ��ȡ����Ƶ����
	unsigned int ReadBytes(void* pData, unsigned int nCount);	
	unsigned long long Seek(long long lOffset) ;

public:
	// ����wave�ļ���formatex��Ϣ
	WAVEFORMATEX GetWaveFormat() const { return m_format.waveFormatEx; }
	bool ReadWaveData(unsigned long dwStartMilli, unsigned long dwEndMilli, unsigned char* &pBuffer, unsigned long &nBufferSize);
	bool ReadAllWaveData(unsigned char* &pBuffer, unsigned long &nBufferSize);
    
private:
	// ��ȡwave�ļ���Format��Ϣ����Open����������m_format
	void ReadHeader();

private:
	FILE* m_wavFile;					// wave�ļ�

	FormatChunk m_format;				// wav�ļ���ʽ
	unsigned long m_dwDataChunkSize;	// ���ݲ��ֵĳ���
	unsigned long long m_nDataStartFrom;			// ����Ƶ���ݿ�ʼ��λ��
	unsigned long m_nBytesWritten;		// ��д���ֽ���
};

//===========================================================================

void GetWaveSample(const WAVEFORMATEX sWaveFormatEx,
					unsigned char *pWaveData,
					unsigned long nWaveByte,
					const int nSamplesPerSecond,
					const int nWindowHeight,
					IntPairVector& WaveSampleVector);

//===========================================================================