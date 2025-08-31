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
  RELEASE_VERSION*: string = "0.1.0"

  EVDEV_LOOKUP*: Table[MacropadKeyAction, EvdevKey] = {
    "VOLUMEUP": KEY_VOLUMEUP,
    "VOLUMEDOWN": KEY_VOLUMEDOWN,
    "VOLUMEMUTE": KEY_MUTE,
    "SCROLLLOCK": KEY_SCROLLLOCK,
    "NEXTSONG": KEY_NEXTSONG,
    "PREVIOUSSONG": KEY_PREVIOUSSONG,
    "PLAYPAUSE": KEY_PLAYPAUSE
  }.toTable

  MACROPAD_KEYS*: MacropadKeySeq = @[
    # 0-9
    # KEY_ACTION string must be a string in EVDEV_LOOKUP
    (KEY_ACTION, "VOLUMEDOWN"),
    (KEY_ACTION, "VOLUMEUP"),
    (KEY_ACTION, "VOLUMEMUTE"),
    (KEY_ACTION, "SCROLLLOCK"),
    (KEY_ACTION, "PREVIOUSSONG"),
    (KEY_ACTION, "NEXTSONG"),
    (KEY_ACTION, "PLAYPAUSE"),
    (KEY_ACTION, ""),
    (KEY_ACTION, ""),
    (KEY_ACTION, "")
    # Example SHELL_ACTION
    # (SHELL_ACTION, "firefox")
  ]
