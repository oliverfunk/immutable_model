
import 'dart:collection';

class CacheBuffer<T> {
  final int bufferSize;
  final Queue<T> _buffer;

  CacheBuffer(this.bufferSize) : _buffer = Queue();

  int numberOfItems() => _buffer.length;

  void cacheItem(T toCache){
    if(_buffer.length == bufferSize){
      _buffer.removeFirst();
    }
    _buffer.add(toCache);
  }

  T restoreTo(int point){
    if(point <= 0){
      throw Error();
    } else if (point > _buffer.length) {
      throw Exception('Cannot restore, point out of buffer range');
    }

    T val;
    for(int _ = 0; _ < point; _++){
      val = _buffer.removeLast();
    }
    return val;
  }

  T peekAt(int point){
    if(point <= 0){
      throw Error();
    } else if (point > _buffer.length) {
      throw Exception('Cannot peek, point out of buffer range');
    }

    return _buffer.elementAt(point-1);
  }

  void flush(){
    _buffer.clear();
  }

  @override
  String toString() => 'Cache Buffer [$bufferSize]: $_buffer';
}