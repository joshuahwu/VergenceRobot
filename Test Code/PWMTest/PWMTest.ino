void setup()
{
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  TCCR2A = _BV(COM2A0) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20);
  TCCR2B = _BV(WGM22) | _BV(CS22);
  OCR2A = 180;
  OCR2B = 50;
}

void loop() {
  // put your main code here, to run repeatedly:

}
