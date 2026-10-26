int nested_flow(int n, int *a) {
    int s = 0;
    for (int i=0; i<n; ++i) {
        if (i%3 == 0) continue;
        int j=0;
        while (j<4) {
            ++j;
            switch ((a[i]+j)&3) {
                case 0: s+=j; break;
                case 1: if (j==2) continue; s-=i;
                case 2: s+=3; break;
                default: s+=a[i];
            }
            if (s>200) break;
        }
        do { --s; if (s%5==0) break; } while(s>100);
        if (s < -100) return s;
    }
    return s;
}
