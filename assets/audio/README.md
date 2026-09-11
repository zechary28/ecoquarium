# Ecoquarium audio

Suggested folders:

- `music/` — the looping aquarium track and any menu music
- `ambience/` — water, bubbles, filter hum, and room tone
- `sfx/` — fish placement, plant placement, feeding, warnings, and fish death
- `ui/` — hover, click, purchase, and error sounds

Import music and ambience as OGG Vorbis and enable looping in Godot's Import dock.
Short effects can be WAV for low-latency playback. Keep a little headroom in every
source file and avoid baking ambience into the music so players can mix them
independently.
