//===========================================================================
// class CWaveFile
//
// ���ܣ�	ʵ��wav�ļ��Ĳ���

//===========================================================================

#include "WaveFile.h"

//===========================================================================

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//===========================================================================
CWaveFile::CWaveFile()
{
    m_wavFile = NULL;
}

CWaveFile::~CWaveFile()
{
	Close();
}

// ��wav�ļ���������header��Ϣ
bool CWaveFile::Open(const char* lpszFileName)
{
	// ���ļ��Ѿ������ȹر�
	Close();	

	// ���ļ�
    m_wavFile = fopen(lpszFileName, "rb");
	if (!m_wavFile)
		return false;

	// ��ȡ�ļ�ͷ��Ϣ
	ReadHeader();

	return true;
}

//===========================================================================
// �ر�wave�ļ����ҽ�������0
void CWaveFile::Close()
{
	if (m_wavFile)
		fclose(m_wavFile);

	m_nDataStartFrom = 0;
	m_dwDataChunkSize = 0;
	m_nBytesWritten = 0;
}

// ����wave��ȡ����ȡwave��Format��Ϣ������¼data��ʼλ��
void CWaveFile::ReadHeader()
{	
	int nOffSet= 0;
	unsigned int nRead = 0;
	FormatChunk fmt;
	DataChunkHeader dataHeader;

	char chunkId[5];
	unsigned long chunkSize;

	// �ļ��Ƿ��
	if (m_wavFile)
	{
		// ����Riff header�ĳ���, �ļ�ָ���Ƶ�riff header֮��
		nOffSet = sizeof(RiffHeader);
        fseek(m_wavFile, nOffSet, SEEK_SET);

		// ��ȡformat chunk
		nRead = fread(&fmt, 1, sizeof(fmt), m_wavFile);

		// ��ȡData Chunk header��Ϣ		
		// ����fmt chunk�ĳ��ȣ��ƶ�����һ��chunk����ʼ��
		nOffSet = fmt.chunkSize + sizeof(fmt.chunkId) + sizeof(fmt.chunkSize) - nRead;
        fseek(m_wavFile, nOffSet, SEEK_CUR);

		// ʵ��strcmp�ж�
		chunkId[4] = '\0';

		// ����������chunk
		while (nRead > 0)
		{
			nRead = fread(chunkId, 1, sizeof(chunkId) - sizeof(char), m_wavFile);

			// ����data chunk
			if (strcmp(chunkId, DEFAULT_DATA_ID) == 0)
			{
				// ����data chunk��ʼλ��
				nOffSet = sizeof(char) - sizeof(chunkId);
                fseek(m_wavFile, nOffSet, SEEK_CUR);
                fread(&dataHeader, 1, sizeof(dataHeader), m_wavFile);

				break;
			}
			else
			{
				// ��������chunk
				nRead = fread(&chunkSize, 1, sizeof(chunkSize), m_wavFile);

                fseek(m_wavFile, chunkSize, SEEK_CUR);
			}
		}

		// ��������Ƶ������ʼλ��
		m_nDataStartFrom = ftell(m_wavFile);
		// ����format��Ϣ
		m_format = fmt;
		// ��������Ƶ�����ܳ���
		m_dwDataChunkSize = dataHeader.chunkSize;
	}
}

// ����wave��ȡ�����ֽ�����ȡ������
unsigned int CWaveFile::ReadBytes(void* pData, unsigned int nCount)
{
	unsigned int nRead = 0;
	// �ļ��Ƿ��
	if (m_wavFile)
		nRead = fread(pData, 1, nCount, m_wavFile);

	return nRead;
}

unsigned long long CWaveFile::Seek(long long lOffset)
{
	if (m_wavFile)
	{
        fseek(m_wavFile, m_nDataStartFrom + lOffset, SEEK_SET);
	}
	return 0;
}

bool CWaveFile::ReadWaveData(unsigned long dwStartMilli, unsigned long dwEndMilli, unsigned char* &pBuffer, unsigned long &nBufferSize)
{
	unsigned long dwSamplesPerMilli = m_format.waveFormatEx.nSamplesPerSec / 1000;

	unsigned long dwStartSample = dwStartMilli * dwSamplesPerMilli;
	unsigned long dwEndSample = dwEndMilli * dwSamplesPerMilli;


	unsigned long dwStartByte = dwStartSample * m_format.waveFormatEx.nBlockAlign;
	unsigned long dwEndByte = dwEndSample * m_format.waveFormatEx.nBlockAlign;

	nBufferSize = dwEndByte - dwStartByte;
	pBuffer = new unsigned char[nBufferSize];
	if (pBuffer != NULL)
	{
		Seek(dwStartByte);		
		nBufferSize = ReadBytes(pBuffer, nBufferSize);
	}	

	return true;
}

bool CWaveFile::ReadAllWaveData(unsigned char* &pBuffer, unsigned long &nBufferSize)
{
	pBuffer = new unsigned char[m_dwDataChunkSize];
	if (pBuffer != NULL)
	{
		fseek(m_wavFile, m_nDataStartFrom, SEEK_SET);
		nBufferSize = ReadBytes(pBuffer, m_dwDataChunkSize);
	}	

	return true;
}

//===========================================================================

void GetWaveSample(const WAVEFORMATEX sWaveFormatEx,
				   unsigned char *pWaveData,
				   unsigned long nWaveByte,
				   const int nSamplesPerSecond,
				   const int nWindowHeight,
				   IntPairVector& WaveSampleVector)
{
	if (pWaveData != NULL && nWaveByte > 0)
	{
		if (sWaveFormatEx.nChannels == 1 || sWaveFormatEx.nChannels == 2)
		{
			if(sWaveFormatEx.wBitsPerSample == 16)
			{
				unsigned char* pStWaveData = pWaveData;
				unsigned char* pEdWaveData = pWaveData + nWaveByte;

				float ratio = (float)nWindowHeight / 65536;

				int den = sWaveFormatEx.nSamplesPerSec / nSamplesPerSecond;

				unsigned char* pTempWaveData = pStWaveData;

				while(pTempWaveData>=pWaveData && pTempWaveData <pEdWaveData)
				{
					short minvalue = 32767, maxvalue = -32767;
					bool hasvalue = false;
					for(int i=0; i<den; i++)
					{
						pTempWaveData += sWaveFormatEx.nBlockAlign;
						if(pTempWaveData >= pEdWaveData)
							break;

						hasvalue = true;
						short waveeng = (short)((pTempWaveData[0] & 0xff) | (pTempWaveData[1] << 8));

						if(waveeng < minvalue) minvalue = waveeng;
						if(waveeng > maxvalue) maxvalue = waveeng;
					}
					if (hasvalue)
					{
						int a = (int)((minvalue+32768) * ratio);
						int b = (int)((maxvalue+32768) * ratio);
						WaveSampleVector.push_back(IntPair(a, b));
					}
				}
			}
		}
	}
}

//===========================================================================