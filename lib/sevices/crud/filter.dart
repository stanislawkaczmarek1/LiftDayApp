extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}

extension Sort<T> on Stream<List<T>> {
  Stream<List<T>> sort(Comparable Function(T) getKey, [bool ascending = true]) {
    return map((items) {
      final sortedItems = List<T>.from(items);
      sortedItems.sort((a, b) {
        final keyA = getKey(a);
        final keyB = getKey(b);
        int comparison = keyA.compareTo(keyB);
        return ascending ? comparison : -comparison;
      });
      return sortedItems;
    });
  }
}
