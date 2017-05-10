#include "DigitalPin.h"
#include "Arduino.h"

// Cpp

DigitalPin::DigitalPin(int pin)
{
  _pin = pin;
}

void DigitalPin::begin()
{
  pinMode(_pin, OUTPUT);
}

void DigitalPin::on()
{
  _status = true;
  digitalWrite(_pin, HIGH);
}

void DigitalPin::off()
{
  _status = false;
  digitalWrite(_pin, LOW);
}

bool DigitalPin::status()
{
  return _status;
}