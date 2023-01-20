# BASS (Build Audio Stream Services)

# Preface
```
We often build complex audio networks using liquidsoap services. For example, in
the radio studio, there is a service that takes the audio signal from the mixing
console, adjusts the volume, and streams the signal to the radio station.
At the radio station, there is a service that switches between different input
streams and plays one of them on the radio station. Most of the time, these
audio chains use the same flow: some input, some processing, and some output.
```

# Description
```
`bass` tries to facilitate the compilation of such audio
chains by by providing a reduced set of processing steps. Based on these
configured  steps, a systemd service and a liquidsoap script are created.
```

# Usage
```
bass reads flows from etc/stream-services/services/*.conf
and creates for each of it:
* the liquidsoap script,
* a systemd service configuration and
* icecast configuration

The generated files can be copied to /etc and used directly to start the service.
```

```
bin/bass

process etc/stream-services/services/stream-player.conf
save instances/etc/stream-services/stream-player.liq
save instances/etc/systemd/system/stream-player.service

process etc/stream-services/services/studio.conf
save instances/etc/icecast/studio.conf
save instances/etc/stream-services/studio.liq
save instances/etc/systemd/system/studio.service
```

# Example configuration
```
Record audio from an alsa device, archive it to disk, and send the
stream to Icecast using the Vorbis codec:
```

```
liquidsoap :
    flow :
        - init: { telnet-port: 1234 }
        - input-alsa: { device: default }
        - output-file-wav: { path: /mnt/archive/ }
        - output-icecast-vorbis: { url: ssh://user1:pass1@localhost:8001/mount1 }
    service :
        name: studio
        user: audiostream
        group: www-data

icecast:
    mount: /radio
```

# Supported Steps
```
The following process steps are supported and can be used to compose a flow:

- init
- input-alsa
- input-current-http
- telnet
- silence-detection
- sound-processing
- output-alsa
- output-file-vorbis
- output-file-wav
- output-port-vorbis
- output-icecast-flac
- output-icecast-mp3
- output-icecast-opus
- output-icecast-vorbis
- output-pulse-audio
```

# Templates
```
The source templates for the steps are stored in `etc/stream-services/templates/liquidsoap/`.
```

# Variables
```
The template `output-file-wav.conf` uses a variable `<output-file-wav.path>`.
The flow step `output-file-wav` sets the value `/mnt/archive/` for the variable `path`
by `- output-file-wav: { path: /mnt/archive/}`.
The default values for variables are defined in `etc/stream-services/templates/liquidsoap/defaults.conf`.
Credentials are specified in the form `ssh://user:password@host:port/mount`
and converted to the correct liquidsoap or icecast syntax.
```
