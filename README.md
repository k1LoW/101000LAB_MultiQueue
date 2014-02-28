101000LAB MultiQueue
====================

Multi Queue Plugin for Quarz Composer Iterator

![sample](http://github.com/k1LoW/101000LAB_MultiQueue/raw/master/screenshot.png)


    function (__number Queue) main (
    __number Value,
    __number QueueIndex,
    __boolean Filling,
    __boolean ResetSignal,
    __number Iterations)
    {
      Object.Queue = (Object.Queue) ? Object.Queue : new Array(Iterations);
      Object.Queue[QueueIndex] = (Object.Queue[QueueIndex]) ? Object.Queue[QueueIndex] : 0;
      var result = new Object();
      if (Filling) {
        Object.Queue[QueueIndex] = Value;
      }
      if (ResetSignal) {
        Object.Queue[QueueIndex] = 0;
      }
      result.Queue = Object.Queue[QueueIndex];
      return result;
    }
