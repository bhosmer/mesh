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
package runtime.intrinsic.demo.processing;

import runtime.intrinsic.IntrinsicLambda;
import runtime.rep.Tuple;

/**
 * Demo support, Processing hook
 */
public final class _prvertex3d extends IntrinsicLambda
{
    public static final _prvertex3d INSTANCE = new _prvertex3d(); 
    public static final String NAME = "prvertex3d";

    public String getName()
    {
        return NAME;
    }

    public Object apply(final Object arg)
    {
        final Tuple args = (Tuple)arg;
        return invoke((Double)args.get(0), (Double)args.get(1), (Double)args.get(2));
    }

    /**
     * CAUTION not thread safe when called outside of setup/draw func
     */
    public static Tuple invoke(final double x, final double y, final double z)
    {
        if (Processing.INSTANCE != null)
        {
            Processing.INSTANCE.vertex((float)x, (float)y, (float)z);
        }

        return Tuple.UNIT;
    }
}
