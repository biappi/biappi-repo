/*
    (kind of) CoreMIDI to Jack Midi Bridge.

    "greatly inspired" by CoreMIDI Echo example, the jackd jack_midiseq example and larsl alsa-jack bridge

    compile with: g++ corejackmidi.cpp -o echo -framework CoreMIDI -framework CoreServices -I/usr/local/include/jack/ -ljack
*/


#include <CoreMIDI/MIDIServices.h>
#include <CoreFoundation/CFRunLoop.h>

#include <jack/jack.h>
#include <jack/midiport.h>
#include <jack/ringbuffer.h>

#include <stdio.h>

#define kProgramName    "Core-Jack-Midi Bridge"
#define kRingbufferSize 512

jack_port_t       * jack_out   = NULL;
jack_ringbuffer_t * ringbuffer = NULL;

static void core_process (const MIDIPacketList *pktlist, void *refCon, void *connRefCon)
{
	MIDIPacket * packet = (MIDIPacket *)pktlist->packet;

	for (unsigned int j = 0; j < pktlist->numPackets; j++)
	{
		for (int i = 0; i < packet->length; ++i)
			jack_ringbuffer_write(ringbuffer, (char *) (packet->data + i), 1);

		packet = MIDIPacketNext(packet);
	}
}

static int jack_process(jack_nframes_t nframes, void *arg)
{
	size_t   to_read;
	char     temp_buffer[kRingbufferSize];
	void   * port_buffer;

	to_read = jack_ringbuffer_read_space(ringbuffer);
	jack_ringbuffer_read(ringbuffer, temp_buffer, to_read);
	
	port_buffer = jack_port_get_buffer(jack_out, nframes);

	jack_midi_clear_buffer(port_buffer, nframes);
	jack_midi_event_write(port_buffer, 0, (jack_midi_data_t *) temp_buffer, to_read, nframes);

	return 0;
}

int main(int argc, char *argv[])
{
	jack_client_t  * jack_client = NULL;
	jack_nframes_t   nframes     = NULL;

	MIDIClientRef    core_client = NULL;
	MIDIPortRef      core_in     = NULL;

	int i, n;

	if ((jack_client = jack_client_new(kProgramName)) == 0)
	{
		fprintf(stderr, "Cant create jack client");
		return 1;
	}

	nframes  = jack_get_buffer_size (jack_client);
	jack_out = jack_port_register   (jack_client, "Midi Out", JACK_DEFAULT_MIDI_TYPE, JackPortIsOutput, 0);

	jack_midi_reset_new_port  (jack_port_get_buffer(jack_out, nframes), nframes);
	jack_set_process_callback (jack_client, jack_process, 0);

	MIDIClientCreate(CFSTR(kProgramName), NULL, NULL, &core_client);
	MIDIInputPortCreate(core_client, CFSTR("Input port"), core_process, NULL, &core_in);

	ringbuffer = jack_ringbuffer_create(kRingbufferSize);
	
	jack_activate(jack_client);

	n = MIDIGetNumberOfSources();
	printf("%d sources\n", n);

	for (i = 0; i < n; ++i)
		MIDIPortConnectSource(core_in, MIDIGetSource(i), NULL);
	
	CFRunLoopRun();

	return 0;
}

