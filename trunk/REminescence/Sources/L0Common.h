#if defined(LDEBUG)
#define L0Log(x, args...) NSLog(@"<DEBUG: %s> " x, __func__, ##args);
#else
#define L0Log(x, ...)
#endif
