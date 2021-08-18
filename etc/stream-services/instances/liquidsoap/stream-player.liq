
# pipe stdout to log file to fetch external errors
set("log.stdout", true)
set("log.file", false)

# write pid file
system("ps -p $$ -o ppid= > /var/run/stream-services/stream-player.pid")
radio=mksafe(input.http("http://source-streams.org/source1.mp3"));
radio = fallback(
    id = "fallback",
    track_sensitive = false,
    [
        fail(),
        strip_blank(id="silence", max_blank=180., threshold=-50., radio ) ,
        mksafe(single(id="jingle", "/media/sound/fallback.mp3"))
    ]
)
output.alsa(device="default", mksafe(radio));

