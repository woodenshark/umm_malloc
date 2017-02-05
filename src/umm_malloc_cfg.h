/*
 * Configuration for umm_malloc
 */

#ifndef _UMM_MALLOC_CFG_H
#define _UMM_MALLOC_CFG_H

/*
 * There are a number of defines you can set at compile time that affect how
 * the memory allocator will operate.
 *
 * You can set them in umm_malloc_cfg.h. In GNU C, you also can set these
 * compile time defines like this:
 *
 * Set this if you want to use a best-fit algorithm for allocating new
 * blocks
 *
 * -D UMM_BEST_FIT (defualt)
 *
 * Set this if you want to use a first-fit algorithm for allocating new
 * blocks
 *
 * -D UMM_FIRST_FIT
 *
 * Set n to a value from 0 to 6 depending on how verbose you want the debug
 * log to be
 *
 * -D UMM_DBG_LOG_LEVEL=n
 *
 * ----------------------------------------------------------------------------
 *
 * To use this library in a multitasking environment you MUST provide bodies
 * to the UMM_CRITICAL_ENTRY and UMM_CRITICAL_EXIT macros (see below)
 *
 * Without protection against multiple threads accessing the allocation
 * heap at the same time, you WILL end up with a corrupted heap!
 *
 * ----------------------------------------------------------------------------
 */

extern char test_umm_heap[];

/* Start addresses and the size of the heap */
#ifndef UMM_MALLOC_CFG_HEAP_ADDR
#  define UMM_MALLOC_CFG_HEAP_ADDR (test_umm_heap)
#endif

#ifndef UMM_MALLOC_CFG_HEAP_SIZE
#  define UMM_MALLOC_CFG_HEAP_SIZE 0x10000
#endif

/* A couple of macros to make packing structures less compiler dependent */

#ifdef __GNUC__
#  define UMM_H_ATTPACKPRE
#  define UMM_H_ATTPACKSUF __attribute__((__packed__))
#else
#  define UMM_H_ATTPACKPRE
#  define UMM_H_ATTPACKSUF
#endif

/*
 * Define the fit algorithm
 *
 * UMM_BEST_FIT  Scans the free list and stops when it finds an exact fit.
 *               If no exact fit, then it returns the SMALLEST block that
 *               satisfies the request.
 *
 * UMM_FIRST_FIT Returns the first block that will satisfy the request.
 *
 * In general, UMM_BEST_FIT will result in less fragmentation while 
 * UMM_FIRST_FIT will run a bit faster.
 *
 * There are many factors that affect fragmentation, so it's best to run
 * the allocator with UMM_INFO defined at the beginning so that you can
 * get an idea of the allocation patterns.
 *
 * Default: UMM_BEST_FIT
 */

#ifndef UMM_BEST_FIT
#  ifndef UMM_FIRST_FIT
#    define UMM_BEST_FIT
#  endif
#endif

/*
 * A couple of macros to make it easier to protect the memory allocator
 * in a multitasking system. You should set these macros up to use whatever
 * your system uses for this purpose. You can disable interrupts entirely, or
 * just disable task switching - it's up to you
 *
 * NOTE WELL that these macros MUST be allowed to nest, because umm_free() is
 * called from within umm_malloc()
 *
 * Default: Defined as macros that expand to nothing
 */

#ifndef UMM_CRITICAL_ENTRY
#  define UMM_CRITICAL_ENTRY()
#endif
#ifndef UMM_CRITICAL_EXIT
#  define UMM_CRITICAL_EXIT()
#endif

/*
 * -D UMM_INFO :
 *
 * Enables a dup of the heap contents and a function to return the total
 * heap size that is unallocated - note this is not the same as the largest
 * unallocated block on the heap!
 *
 * Default: Not defined
 */

#define UMM_INFO

/*
 * -D UMM_INTEGRITY :
 *
 * Enables heap integrity check before any heap operation. It affects
 * performance, but does NOT consume extra memory.
 *
 * If integrity violation is detected, the message is printed and user-provided
 * callback is called: `UMM_HEAP_CORRUPTION_CB()`
 *
 * Note that not all buffer overruns are detected: each buffer is aligned by
 * 4 bytes, so there might be some trailing "extra" bytes which are not checked
 * for corruption.
 *
 * Default: Not defined
 */

#define UMM_INTEGRITY

/*
 * -D UMM_POISON :
 *
 * Enables heap poisoning: add predefined value (poison) before and after each
 * allocation, and check before each heap operation that no poison is
 * corrupted.
 *
 * Other than the poison itself, we need to store exact user-requested length
 * for each buffer, so that overrun by just 1 byte will be always noticed.
 *
 * Customizations:
 *
 *    UMM_POISON_SIZE_BEFORE:
 *      Number of poison bytes before each block, e.g. 2
 *    UMM_POISON_SIZE_AFTER:
 *      Number of poison bytes after each block e.g. 2
 *    UMM_POISONED_BLOCK_LEN_TYPE
 *      Type of the exact buffer length, e.g. `short`
 *
 * NOTE: each allocated buffer is aligned by 4 bytes. But when poisoning is
 * enabled, actual pointer returned to user is shifted by
 * `(sizeof(UMM_POISONED_BLOCK_LEN_TYPE) + UMM_POISON_SIZE_BEFORE)`.
 * It's your responsibility to make resulting pointers aligned appropriately.
 *
 * If poison corruption is detected, the message is printed and user-provided
 * callback is called: `UMM_HEAP_CORRUPTION_CB()`
 *
 * Default: Not defined
 */

#define UMM_POISON

#endif /* _UMM_MALLOC_CFG_H */
