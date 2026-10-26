struct Item {
    char tag;
    int value;
    long weight;
};
long score_items(const struct Item *items, int n) {
    long total = 0;
    for (int i = 0; i < n; ++i) {
        if (items[i].tag) {
            total += items[i].value * items[i].weight;
        }
    }
    return total;
}
