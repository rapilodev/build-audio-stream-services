
# pipe stdout to log file to fetch external errors
set("log.stdout", true)
set("log.file", false)

# write pid file
system("ps -p $$ -o ppid= > /var/run/stream-services/studio.pid")
radio   = mksafe(input.alsa(id="alsa_in", device="default"))
radio = fallback(
    id = "fallback",
    track_sensitive = false,
    [
        fail(),
        strip_blank(id="silence", max_blank=180., threshold=-50., radio ) ,
        mksafe(single(id="jingle", "/media/sound/fallback.mp3"))
    ]
)
clock.assign_new( id="icecast", [
    output.icecast(
        %vorbis.cbr(samplerate=44100, channels=2, bitrate=256),
        host="localhost", mount="/mount", pass="pass", port="8000", user="user"
        mksafe(buffer(radio))
    )
])
output.file(
    %wav(stereo=true),
    "/mnt/archive//%Y-%m-%d/%Y-%m-%d-%H_%M_%S.wav",
    on_close=fun(s)->system("qwavheaderdump -F #{s}"),
    reopen_when={0m0s},
    mksafe(radio)
)
output.alsa(device="default", mksafe(radio));

