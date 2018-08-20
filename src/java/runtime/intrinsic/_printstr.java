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
package runtime.intrinsic;

import runtime.rep.Tuple;

/**
 * print string to System.out.
 */
public final class _printstr extends IntrinsicLambda
{
    public static final _printstr INSTANCE = new _printstr(); 
    public static String NAME = "printstr";

    public String getName()
    {
        return NAME;
    }

    public Object apply(final Object arg)
    {
        return invoke((String)arg);
    }

    public static Tuple invoke(final String obj)
    {
        if (obj != null)
            System.out.println(obj);

        return Tuple.UNIT;
    }
}
