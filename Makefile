CONFIG = --config-file "./arduino-cli.yaml"
FQBN = --fqbn "arduino:avr:micro"
SKETCH = "macropad"
LIBRARIES = "Keypad" "HID-Project"
PORT = --port "/dev/ttyACM0"

setup:
	arduino-cli $(CONFIG) lib install $(LIBRARIES)

compile:
	arduino-cli $(CONFIG) compile $(SKETCH) $(FQBN)

upload:
	arduino-cli $(CONFIG) upload $(SKETCH) $(FQBN) $(PORT)
