import 'dart:collection';

class CacheBuffer<T> {
  final int bufferSize;
  final Queue<T> _buffer;

  CacheBuffer(this.bufferSize) : _buffer = Queue() {
    if (bufferSize < 0) {
      throw Error();
    }
  }

  int numberOfItems() => _buffer.length;

  void cacheItem(T toCache) {
    if (bufferSize == 0 || toCache == null) {
      return;
    }

    // if the buffer is full, remove the FIFO first and add the new item
    if (numberOfItems() == bufferSize) {
      _buffer.removeFirst();
    }
    _buffer.add(toCache);
  }

  T restoreTo(int point) {
    if (point <= 0) {
      throw Error();
    } else if (bufferSize == 0) {
      throw Exception('Cannot restore, buffer is size 0');
    } else if (point > numberOfItems()) {
      throw Exception(
          'Cannot restore, point $point out of buffer range $numberOfItems()');
    }

    T val;
    for (int _ = 0; _ < point; _++) {
      val = _buffer.removeLast();
    }
    return val;
  }

  T peekAt(int point) {
    if (point <= 0) {
      throw Error();
    } else if (bufferSize == 0) {
      throw Exception('Cannot peek, buffer is size 0');
    } else if (point > numberOfItems()) {
      throw Exception(
          'Cannot peek, point $point out of buffer range $numberOfItems()');
    }

    return _buffer.elementAt(point - 1);
  }

  void flush() {
    _buffer.clear();
  }

  @override
  String toString() => 'Cache Buffer [$numberOfItems()/$bufferSize]: $_buffer';
}
