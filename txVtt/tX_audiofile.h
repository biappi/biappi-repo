/*
    terminatorX - realtime audio scratching software
    Copyright (C) 1999-2004  Alexander Kˆnig
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
 
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
 
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
    File: tX_audiofile.h
 
    Description: Header to audiofile.cc
*/   

#ifndef _h_tx_audiofile
#define _h_tx_audiofile 1

#define SOX_BLOCKSIZE 32000

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

// #include <tX_endian.h>
#include <stdlib.h>


enum tX_audio_error {
	TX_AUDIO_SUCCESS,
	TX_AUDIO_ERR_ALLOC,
	TX_AUDIO_ERR_PIPE_READ,
	TX_AUDIO_ERR_SOX,
	TX_AUDIO_ERR_MPG123,
	TX_AUDIO_ERR_WAV_NOTFOUND,
	TX_AUDIO_ERR_NOT_16BIT,
	TX_AUDIO_ERR_NOT_MONO,
	TX_AUDIO_ERR_WAV_READ,
	TX_AUDIO_ERR_NOT_SUPPORTED,
	TX_AUDIO_ERR_OGG123,
	TX_AUDIO_ERR_MAD_OPEN,
	TX_AUDIO_ERR_MAD_STAT,
	TX_AUDIO_ERR_MAD_DECODE,
	TX_AUDIO_ERR_MAD_MMAP,
	TX_AUDIO_ERR_MAD_MUNMAP,
	TX_AUDIO_ERR_VORBIS_OPEN,
	TX_AUDIO_ERR_VORBIS_NODATA,
	TX_AUDIO_ERR_AF_OPEN,
	TX_AUDIO_ERR_AF_NODATA	
};

enum tX_audio_storage_type {
	TX_AUDIO_UNDEFINED,
	TX_AUDIO_MMAP,
	TX_AUDIO_LOAD
};

enum tX_audio_file_type {
	TX_FILE_UNDEFINED,
	TX_FILE_WAV,
	TX_FILE_MPG123,
	TX_FILE_OGG123
};

#include <limits.h>
#include <stdio.h>

#define USE_BUILTIN_WAV

class tx_audiofile
{
	private:
	tX_audio_storage_type mem_type;
	tX_audio_file_type file_type;
	
	FILE *file;
	char filename[PATH_MAX];
	int16_t *mem;
	size_t memsize;
	long no_samples;	
	unsigned int sample_rate; //in HZ	

#ifdef USE_BUILTIN_WAV
	tX_audio_error load_wav();
#endif
	
#ifdef USE_AUDIOFILE_INPUT
	tX_audio_error load_af();
#endif

#ifdef USE_MAD_INPUT
	tX_audio_error load_mad();
	int mad_decode(unsigned char const *start, unsigned long length);	
#endif

#ifdef USE_VORBIS_INPUT
	tX_audio_error load_vorbis();
#endif

	void figure_file_type();
	
	public:
	tx_audiofile();
	unsigned int get_sample_rate() { return sample_rate; }
	
	tX_audio_error load(char *p_file_name);
	int16_t *get_buffer() { return mem; };
	long get_no_samples() { return no_samples; };
	
	~tx_audiofile();
};

#endif
