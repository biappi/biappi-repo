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
 
    File: tX_vtt.cc
 
    Description: This implements the new virtual turntable class. It replaces
		 the old turntable.c from terminatorX 3.2 and earlier. The lowpass
		 filter is based on some sample code by Paul Kellett
		 <paul.kellett@maxim.abel.co.uk>
		 
    08 Dec 1999 - Switched to the new audiofile class		 
*/    

#include "tX_vtt.h"
#include <stdio.h>
#include <math.h>

int vtt_class::last_sample_rate=44100;

vtt_class :: vtt_class ()
{	
	cleanup_required=false;
	
	strcpy(filename, "NONE");
	buffer=NULL;
	samples_in_buffer=0;
	pos_i_max=0;

	pan=0;
	rel_pitch=1; 
	audiofile_pitch_correction=1.0;
	output_buffer=NULL;
	output_buffer2=NULL;
	
	set_volume(1);
	set_pitch(1);
	
	loop=1;
	
	is_playing=0;
	sync_cycles=0,
	sync_countdown=0;
		
	set_pan(0);	
	
	audiofile = NULL;
	audiofile_pitch_correction=1.0;

	mute=0;
	mix_mute=0;
	res_mute=mute;
	res_mute_old=0;
	
	do_scratch=0;
	speed_last=1;
	speed_real=1;
}

vtt_class :: ~vtt_class()
{
	stop();

	if (audiofile)
		delete audiofile;
	
	if (output_buffer)
		free(output_buffer);
	if (output_buffer2)
		free(output_buffer2);		
}


tX_audio_error vtt_class :: load_file(char *fname)
{
	tX_audio_error res;
	int was_playing=is_playing;
	
	if (is_playing) stop();

	if (audiofile) delete audiofile;
	
	buffer=NULL;
	samples_in_buffer=0;
	maxpos=0;
	pos_i_max=0;
	strcpy(filename,"");

	audiofile=new tx_audiofile();
	res=audiofile->load(fname);	
	
	if (res==TX_AUDIO_SUCCESS) {
		buffer=audiofile->get_buffer();
		double file_rate=audiofile->get_sample_rate();
		audiofile_pitch_correction=file_rate/((double) last_sample_rate);
		recalc_pitch();
		samples_in_buffer=audiofile->get_no_samples();
		pos_i_max=samples_in_buffer-1;
		maxpos=audiofile->get_no_samples();
		strcpy(filename, fname);
		if (was_playing) trigger();
	}
		
	return(res);
}

int vtt_class :: set_output_buffer_size(int newsize)
{
	if (output_buffer)
		free (output_buffer);
	
	if (output_buffer2)
		free(output_buffer2);

	output_buffer = (float *) malloc(sizeof(float) * newsize);	
	output_buffer2 = (float *) malloc(sizeof(float) * newsize);

	end_of_outputbuffer = output_buffer + newsize; 
	
	samples_in_outputbuffer=newsize;
	inv_samples_in_outputbuffer=1.0/samples_in_outputbuffer;
	
	return 0;	
}

void vtt_class :: set_volume(float newvol)
{
	rel_volume=newvol;
	recalc_volume();
}

void vtt_class :: recalc_volume()
{
	res_volume=rel_volume;
	
	if (pan>0.0) {
		res_volume_left=(1.0-pan)*res_volume;
		res_volume_right=res_volume;
	} else if (pan<0.0) {
		res_volume_left=res_volume;
		res_volume_right=(1.0+pan)*res_volume;
	} else {
		res_volume_left=res_volume_right=res_volume;
	}	
}

void vtt_class :: set_pan(float newpan)
{
	pan=newpan;
	recalc_volume();
}

void vtt_class :: set_pitch(float newpitch)
{
	rel_pitch=newpitch;
	recalc_pitch();
}

void vtt_class :: recalc_pitch()
{
	res_pitch = rel_pitch * audiofile_pitch_correction;
	speed=res_pitch;
}

void vtt_class :: set_loop(int newstate)
{
	loop=newstate;
}

void vtt_class :: set_mute(int newstate)
{
	mute=newstate;
	calc_mute();
}

void vtt_class :: set_mix_mute(int newstate)
{
	mix_mute=newstate;
	calc_mute();
}

void vtt_class :: render()
{	
	if (do_scratch) {
		if (sense_cycles>0) {
			sense_cycles--;
			if (sense_cycles==0)
				speed = 0;
		}
	}
	render_scratch();
	
	for (int sample=0; sample<samples_in_outputbuffer; sample++) {				
		output_buffer2[sample]=output_buffer[sample]*res_volume_right;
		output_buffer[sample]*=res_volume_left;
	}
}

void vtt_class :: calc_speed()
{
	do_mute=0;
	fade_out=0;
	fade_in=0;

	if (speed != speed_target) {
		speed_target=speed;
		speed_step=speed_target-speed_real;
		speed_step/= VTT_INERTIA;
	}
			
	if (speed_target != speed_real) {
		speed_real+=speed_step;
		if ((speed_step<0) && (speed_real<speed_target)) speed_real=speed_target;
		else if ((speed_step>0) && (speed_real>speed_target)) speed_real=speed_target;			
	}
	
	if (fade) {
		if ((speed_last==0) && (speed_real !=0)) {
			fade_in=1;
			fade=NEED_FADE_OUT;
		}
	} else {
		if ((speed_last!=0) && (speed_real==0)) {
			fade_out=1;
			fade=NEED_FADE_IN;
		}
	}

	speed_last = speed_real;

	if (res_mute != res_mute_old) {
		if (res_mute) {
			fade_out=1; fade_in=0;
			fade=NEED_FADE_IN;
		} else {
			fade_in=1; fade_out=0;
			fade=NEED_FADE_OUT;
		}
		res_mute_old=res_mute;
	} else {
		if (res_mute) do_mute=1;
	}	
}

void vtt_class :: render_scratch()
{
	int16_t *ptr;
	
	int sample;
	
	double pos_a_f;
	
	float amount_a;
	float amount_b;

	float sample_a;
	float sample_b;
	
	float sample_res;
	
	float *out;
	float fade_vol;	

	calc_speed();
					
	for (sample =0,out=output_buffer, fade_vol=0.0; sample < samples_in_outputbuffer;sample++, out++, fade_vol+=inv_samples_in_outputbuffer)
	{
		if (((speed_real == 0) && !fade_out) || do_mute)
		{
			*out = 0.0;
			continue;
		}
		
		pos_f += speed_real;

		if (pos_f > maxpos)
			pos_f -= maxpos;
		else if (pos_f < 0)
			pos_f += maxpos;
			
		pos_a_f=floor(pos_f);
		pos_i=(unsigned int) pos_a_f;
							
		amount_b=pos_f-pos_a_f;				
		amount_a=1.0-amount_b;				
				
	
		ptr=&buffer[pos_i];
		sample_a=(float) *ptr;
	
		if (pos_i == pos_i_max)  {
			sample_b=*buffer;
		} else {
			ptr++;
			sample_b=(float) *ptr;
		}
		
		sample_res=(sample_a*amount_a)+(sample_b*amount_b);
		
		// scale to 0 db := 1.0f
		sample_res /= 32768.0;
						
		if (fade_in) {
			sample_res*=fade_vol;
		} else if (fade_out) {
			sample_res*=1.0-fade_vol;
		}

		*out=sample_res;
	}
}	

void vtt_class :: retrigger() 
{
	if (res_pitch>=0) pos_f=0;
	else pos_f=maxpos;
		
	fade=NEED_FADE_OUT;
	speed=res_pitch;
	speed_real=res_pitch;
	speed_target=res_pitch;
	want_stop=0;

	max_value=0;
	max_value2=0;
}

int vtt_class :: trigger(bool need_lock)
{
	if (!buffer) return 1;
	
	retrigger();
	
	if (!is_playing) {
		is_playing=1;
		cleanup_required=false;
	}

	return 0;
}

/* call this only when owning render_lock. */
int vtt_class :: stop_nolock()
{
	if (!is_playing) {
		return 1;
	}
	
	want_stop=0;
	is_playing=0;
	max_value=0;
	max_value2=0;

	cleanup_required=true;
	
	return 0;
}

int vtt_class :: stop()
{
	int res;
	
	res=stop_nolock();

	return res;
}

void vtt_class :: set_scratch(int newstate)
{
	if (newstate) {
		speed = 0;
		do_scratch=1;
		sense_cycles= SENSE_CYCLES;
	} else {
		speed = res_pitch;
		do_scratch=0;
	}
}

void vtt_class :: set_sample_rate(double samplerate) // written by willy
{
	last_sample_rate = (int) samplerate;
	
	if (audiofile)
		audiofile_pitch_correction = audiofile->get_sample_rate() / samplerate;
	else
		audiofile_pitch_correction = 1.0;
	
	recalc_pitch();	
}

