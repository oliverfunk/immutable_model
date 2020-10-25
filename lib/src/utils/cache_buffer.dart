import 'dart:collection';

class CacheBuffer<T> {
  final int bufferSize;
  final Queue<T> _buffer;

  CacheBuffer(this.bufferSize)
      : assert(bufferSize >= 0, "The buffer's size can't be negative"),
        _buffer = Queue();

  int get numberOfCachedItems => _buffer.length;

  void cacheItem(T toCache) {
    if (bufferSize == 0 || toCache == null) {
      return;
    }

    // if the buffer is full, remove the FIFO first and add the new item
    if (numberOfCachedItems == bufferSize) {
      _buffer.removeFirst();
    }
    _buffer.add(toCache);
  }

  T restoreBy(int point) {
    if (point <= 0) {
      throw RangeError.index(point, _buffer);
    } else if (bufferSize == 0) {
      throw Exception('Cannot restore, buffer is size 0');
    } else if (point > numberOfCachedItems) {
      throw Exception(
          'Cannot restore to point $point, exceeds number of cached items: $numberOfCachedItems');
    }

    T val;
    for (var _ = 0; _ < point; _++) {
      val = _buffer.removeLast();
    }
    return val;
  }

  T peekAt(int point) {
    if (point <= 0) {
      throw Error();
    } else if (bufferSize == 0) {
      throw Exception('Cannot peek, buffer is size 0');
    } else if (point > numberOfCachedItems) {
      throw Exception(
          'Cannot peek at point $point, exceeds number of cached items: $numberOfCachedItems');
    }

    return _buffer.elementAt(point - 1);
  }

  void purge() {
    _buffer.clear();
  }

  @override
  String toString() =>
      'Cache Buffer [$numberOfCachedItems/$bufferSize]:\n$_buffer';
}
