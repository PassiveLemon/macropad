import
  std / [
    os,
    osproc,
    strformat,
    tables
  ]

import
  constants,
  logging

import libevdev


var macropadDevice: ptr libevdev_uinput


proc createDevice(): ptr libevdev_uinput =
  var
    evdev = libevdev_new()
    uinput: ptr libevdev_uinput

  libevdev_set_name(evdev, "Macropad Input");
  discard libevdev_enable_event_type(evdev, EV_KEY);
  # Allow all capabilities from EVDEV_LOOKUP
  for k, v in EVDEV_LOOKUP.pairs:
    discard libevdev_enable_event_code(evdev, EV_KEY, v.cuint, nil);

  let libevdevUinputRet = libevdev_uinput_create_from_device(evdev, LIBEVDEV_UINPUT_OPEN_MANAGED, addr uinput)
  if libevdevUinputRet < 0:
    fatal(fmt"Could not create libevdev uinput device: code {libevdevUinputRet}")
    quit(1)

  return uinput

proc initDevice*(): void =
  macropadDevice = createDevice()

proc cleanupDevice*(): void =
  libevdev_uinput_destroy(macropadDevice)

proc cleanup() {.noconv.} =
  cleanupDevice()
  quit(0)

setControlCHook(cleanup)

proc manageKey(key: int, state: int): void =
  libevdev_uinput_write_event(macropadDevice, EV_KEY, key, state)
  sleep(10) # Buffer time so listeners can see events more consistently
  libevdev_uinput_write_event(macropadDevice, EV_SYN, SYN_REPORT, 0)
  sleep(10)

proc runShellCmd(action: string): void =
  discard startProcess(action, options = {poDaemon, poUsePath})

var lastShellActionState: seq[int] = newSeq[int](10)

proc keyHandler*(input: string, macropadKeys: MacropadKeySeq): void =
  try:
    let
      pressedKey: int = (input[0].ord - '0'.ord)
      pressedKeyState: int = (input[1].ord - '0'.ord)
      (keyActionType, keyAction) = macropadKeys[pressedKey]

    case keyActionType
    of KEY_ACTION:
      if EVDEV_LOOKUP.hasKey(keyAction):
        info(fmt"{keyAction} {pressedKeyState}")
        manageKey(EVDEV_LOOKUP[keyAction], pressedKeyState)
        return
      else:
        warn(fmt"Unknown keyAction '{keyAction}'. Ignoring...")
    of SHELL_ACTION:
      # Only spawn on key press and ensure it can't be spawned multiple times on one key press
      if pressedKeyState == 1:
        if lastShellActionState[pressedKey] == 0:
          lastShellActionState[pressedKey] = 1
          info(fmt"Executing '{keyAction}'")
          runShellCmd(keyAction)
          return
      else:
        lastShellActionState[pressedKey] = 0
    # Keeping this for when we allow the key actions to be configurable
    else:
      fatal(fmt"Unknown keyActionType '{keyActionType}'")
      quit(1)
  except:
    warn(fmt"WARN: Unknown input '{input}'. Ignoring...")
