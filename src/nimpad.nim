import
  std / [
    os,
    strformat,
    streams
  ]

import
  constants,
  input,
  logging

import serial


block macropad:
  initLogger("info", false)

  let
    portName: string = "/dev/ttyACM0"
    serialPort = newSerialStream(portName, 9600, Parity.None, 8, StopBits.One, Handshake.None, buffered=false)
  defer: close(serialPort)

  initDevice()
  defer: cleanupDevice()

  sleep(500)
  info(fmt"Opened serial port '{portName}', receiving...")

  var buf = newString(2)

  while true:
    let n = serialPort.readData(buf.cstring, buf.len)
    if n > 0:
      let chunk = buf[0..<n]
      keyHandler(chunk, MACROPAD_KEYS)
