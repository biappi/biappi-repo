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
 
    File: tX_vtt.h
 
    Description: Header to tX_vtt.cc
    
    08 Dec 1999 - added audiofile support
*/    

#ifndef _h_tx_vtt
#define _h_tx_vtt 1

#include <list>
// #include "tX_types.h"
#include <float.h>
#include <stdio.h>
#include "tX_audiofile.h"

#define VTT_INERTIA 10.0
#define SENSE_CYCLES 80

#define NEED_FADE_OUT 0
#define NEED_FADE_IN 1

#define SAMPLE_MAX    32760.0
#define SAMPLE_BORDER 30000.0

class vtt_class
{
	public:
	static float mix_max_l;
	static float mix_max_r;
	
	static int last_sample_rate;
		
	/* main object vars */
	char filename[PATH_MAX]; // The corresponding audiofile
	
	int is_playing;
	int sync_cycles;
	int sync_countdown;
	bool want_stop;
	int sense_cycles;
	
	bool control_hidden;
	bool audio_hidden;
	double control_scroll_adjustment;
	
	float max_value;
	float max_value2;
	
	int16_t * buffer;	// Actual audio data
	unsigned int samples_in_buffer;  // No. of samples in audio data
	int do_scratch;
	
	float *output_buffer; 
	float *end_of_outputbuffer;
	
	float *output_buffer2; // 2nd audio channel
	
	float samples_in_outputbuffer;
	float inv_samples_in_outputbuffer;
	
	/* main playback vars */
	float rel_volume; // The (user-selected) relative volume
	float res_volume; // The resulting volume
	float rel_pitch; // The (user-selected) relative pitch
	float res_pitch;
	
	float pan; // The logical pan value -1 left, 0 center, 1 right
	float res_volume_left;
	float res_volume_right;
	
	int loop;
	
	double speed;
	double speed_real;
	double speed_target;
	double speed_step;
	double speed_last;
	int fade_in;
	int fade_out;
	bool do_mute;
		
	double pos_f;
	unsigned int pos_i;
	unsigned int pos_i_max;
	double maxpos;
	
	bool mute;
	bool res_mute;
	bool res_mute_old;
	
	bool mix_mute;
	int fade;
		
	tx_audiofile *audiofile;
	float audiofile_pitch_correction;

	public:
	/* Methods */		
	vtt_class();
	~vtt_class();
		
	/* Parameter setup methods */
	void set_name(char *);
	int set_output_buffer_size(int);

	void set_volume(float);
	void recalc_volume();
	
	void set_pan(float);
	void set_pitch(float);
	void recalc_pitch();
	
	void set_autotrigger(int);
	void set_loop(int);
	
	void set_mute(int);
		
	void set_scratch(int);
	
	void calc_speed();
	void render();
	
	static int set_mix_buffer_size(int);
	static void set_master_volume(float);
	static void set_master_pitch(float);
	
	void set_sample_rate(double samplerate);

	void retrigger();
	int trigger(bool need_lock=true);
	
	int stop();
	int stop_nolock();
	bool cleanup_required;
	bool needs_cleaning_up() { return cleanup_required; }
		
	tX_audio_error load_file(char *name);	

	void render_scratch();
	
	void hide_audio(bool);
	void hide_control(bool);
	
	void set_mix_mute(int newstate);

	// static int get_last_sample_rate() { return last_sample_rate; }
	
	void calc_mute() {
		res_mute=((mute));
	}
	
	// code by willy
	float * get_output_buffer()             { return output_buffer;  };
	float * get_output_buffer2()            { return output_buffer2; };
	float   get_samples_in_output_buffer () { return samples_in_outputbuffer; };
	// end code by willy	
};

extern vtt_class * the_only_vtt;

#endif
