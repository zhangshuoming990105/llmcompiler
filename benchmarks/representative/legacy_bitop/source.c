
int apply_binary_operation_on_byte(int tbit, int kbit, int operation)
{
 if (operation == 0x00) {
  return ((tbit == '1') || (kbit == '1')) ? '1' : '0';
 }
 else
 if (operation == 0x01) {
  return ((tbit == '1') && (kbit == '1')) ? '1' : '0';
 }
 else
 if (operation == 0x02) {
  return (((tbit == '0') && (kbit == '1'))
    || ((tbit == '1') && (kbit == '0'))) ? '1' : '0';
 }

 return '?';
}