import
  std / [
    strformat,
    streams
  ]

import
  nimpad / [
    config,
    input,
    logging
  ]

import serial


block macropad:
  initConfig()

  # Test all serial ports and somehow receive a special string or something from the macropad to verify?
  var serialPort: SerialStream
  try:
    serialPort = newSerialStream(globalConfig.config.port, 9600, Parity.None, 8, StopBits.One, Handshake.None, buffered=false)
  except InvalidSerialPortError:
    fatal(fmt"Port {globalConfig.config.port} is not a valid serial port.")
    quit(1)
  defer: close(serialPort)

  initDevice()
  defer: cleanupDevice()

  notice(fmt"Opened serial port '{globalConfig.config.port}', receiving...")

  var buf = newString(2)

  while true:
    let n = serialPort.readData(buf.cstring, buf.len)
    if n > 0:
      let chunk = buf[0..<n]
      keyHandler(chunk, globalConfig.macropad)
