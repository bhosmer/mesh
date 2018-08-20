/**
 * ADOBE SYSTEMS INCORPORATED
 * Copyright 2009-2013 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE: Adobe permits you to use, modify, and distribute
 * this file in accordance with the terms of the MIT license,
 * a copy of which can be found in the LICENSE.txt file or at
 * http://opensource.org/licenses/MIT.
 */
package runtime.sys;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Concurrency manager, currently just a very thin
 * wrapper over a cached thread pool.
 * TODO lots of things to try here.
 */
public class ConcurrencyManager
{
    private static final ExecutorService EXECUTOR = Executors.newCachedThreadPool();

    /**
     * execute a task concurrently
     */
    public static void execute(final Runnable runnable)
    {
        EXECUTOR.execute(runnable);
    }
}
