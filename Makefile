# Used to keep Arduino stuff contained in this repository
CONFIG = --config-file ./arduino-cli.yaml

SKETCH = macropad
LIBRARIES = Keypad HID-Project

FQBN = --fqbn arduino:avr:micro
PORT = --port /dev/ttyACM0

setup:
	arduino-cli lib install $(LIBRARIES) $(CONFIG)

compile:
	arduino-cli compile $(SKETCH) $(CONFIG) $(FQBN)

upload:
	arduino-cli upload $(SKETCH) $(CONFIG) $(FQBN) $(PORT)
