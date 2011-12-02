Signal Delay
============

Prevents catchable signals from interrupting a block of code but *doesn't just ignore them*.

1. caches existing traps
2. runs block while caching any catchable signals
3. resets old traps from cache
4. re-emits signals to own PID
