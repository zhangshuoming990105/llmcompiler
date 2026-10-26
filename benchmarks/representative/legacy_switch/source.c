
int color_char_to_attr(char c)
{
 switch (c)
 {
 case 'd':
  return (0);
 case 'w':
  return (1);
 case 's':
  return (2);
 case 'o':
  return (3);
 case 'r':
  return (4);
 case 'g':
  return (5);
 case 'b':
  return (6);
 case 'u':
  return (7);

 case 'D':
  return (8);
 case 'W':
  return (9);
 case 'v':
  return (10);
 case 'y':
  return (11);
 case 'R':
  return (12);
 case 'G':
  return (13);
 case 'B':
  return (14);
 case 'U':
  return (15);
 }

 return ( -1);
}