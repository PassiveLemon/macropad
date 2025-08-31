# nimpad

A WIP Nim based client for a WIP DIY macropad.

By communicating with an Arduino in the macropad, nimpad can send keyboard inputs or run shell commands.

# Dependencies
- Linux, other platforms are not supported.
- A user in the "input" and "dialout" group. You can use sudo privileges but if you want to use this as a daemon to run shell commands, sudo is not recommended.
- Nimble packages: `serial` and [`libevdev`](https://github.com/PassiveLemon/libevdev-nim)

# 3D Model
https://www.printables.com/model/1400774-macropad

# Usage
### Nix:
- You can get the package in my [flake repository](https://github.com/PassiveLemon/lemonake).
### Source:
- Clone the repo, cd to src
- Run `nim c -r nimpad`

# Configuration (config.json)
Currently external configuration is not possible, but is planned. For now, you must clone the repository and edit the MACROPAD_KEYS in constants.nim.
This is the currently configured matrix:
```
{ 0, 1 } 0: Volume down | 1: Volume up
{ 2, 3 } 2: Mute system | 3: Press to mute for Discord/push to talk for games
{ 4, 5 } 4: Media previous | 5: Media next
{ 6, 7 } 6: Media play/pause | 7: Unused
{ 8, 9 } 8: Unused | 9: Unused
```
