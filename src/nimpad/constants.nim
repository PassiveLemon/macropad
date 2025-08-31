import tables

import libevdev

type
  EvdevKey* = int
  MacropadKeyActionType* = enum
    KEY_ACTION, SHELL_ACTION
  MacropadKeyAction* = string

  MacropadKey* = tuple[actionType: MacropadKeyActionType, action: MacropadKeyAction]
  MacropadKeySeq* = seq[MacropadKey]

const
  RELEASE_VERSION*: string = "0.2.0"

  EVDEV_LOOKUP*: Table[MacropadKeyAction, EvdevKey] = {
    "VOLUMEUP": KEY_VOLUMEUP,
    "VOLUMEDOWN": KEY_VOLUMEDOWN,
    "VOLUMEMUTE": KEY_MUTE,
    "SCROLLLOCK": KEY_SCROLLLOCK,
    "NEXTSONG": KEY_NEXTSONG,
    "PREVIOUSSONG": KEY_PREVIOUSSONG,
    "PLAYPAUSE": KEY_PLAYPAUSE
  }.toTable
