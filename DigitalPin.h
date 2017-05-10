#ifndef DigitalPin_h
#define DigtialPin_h

class DigitalPin
{
  public:
    DigitalPin(int pin);
    void begin();
    void on();
    void off();
    bool status();
  private:
    int _pin;
    bool _status; 
};

#endif
