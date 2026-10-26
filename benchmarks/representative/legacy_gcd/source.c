
int gcd(int a,int b) {
    int r;

    if(a<0) {
        a=-a;
    }
    if(b<0) {
        b=-b;
    }

    if(b>a) {
        int tmp=a;
        a=b;
        b=tmp;
    }
    while (b != 0) {
        r = a % b;
        a = b;
        b = r;
    }
    return a;
}