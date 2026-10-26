int update_stride(int *a, int n, int stride, int bias) {
    int total = 0;
    for (int i = 0; i < n; ++i) {
        if (a[i * stride] < 0) {
            continue;
        }
        a[i * stride] += bias;
        total += a[i * stride] * (i + 1);
    }
    return total;
}
