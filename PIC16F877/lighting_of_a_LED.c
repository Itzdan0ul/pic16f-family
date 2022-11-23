void main() {
  TRISD = 0;

  for (;;) {
    PORTD = 0x80;
    delay_ms(1000);
    PORTD = 0;
    delay_ms(300);
  }
}
