int scoped_sum(int n) {
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        int n = i + 2;
        for (int i = 0; i < n; ++i) {
            sum += i;
        }
    }
    return sum + n;
}
