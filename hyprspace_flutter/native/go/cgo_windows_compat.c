// cgo_windows_compat.c
//
// Go 1.17's CGO runtime (gcc_libinit_windows.c, gcc_util.c,
// gcc_windows_amd64.c) references __iob_func / __imp___iob_func which was
// part of the old MSVCRT ABI and has been removed from newer MinGW (GCC 15+).
//
// By providing a local definition of __iob_func here, GNU ld will
// auto-create the __imp___iob_func import thunk when linking the shared
// library, satisfying those dangling references.
//
// __acrt_iob_func(n) is the UCRT replacement that returns &_iob[n];
// indexing it as an array (as the Go CGO bootstrap does) is safe because
// _iob is a contiguous FILE array in UCRT.

#if defined(_WIN32) && defined(__MINGW32__)
#include <stdio.h>

FILE * __cdecl __iob_func(void) {
    return __acrt_iob_func(0);
}

#endif
