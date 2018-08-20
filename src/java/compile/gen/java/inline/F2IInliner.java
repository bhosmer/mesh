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
package compile.gen.java.inline;

import compile.gen.java.StatementFormatter;
import compile.term.ApplyTerm;

/**
 * Try inlining calls to {@link runtime.intrinsic.F2I}.
 */
public class F2IInliner implements Inliner
{
    public String tryInlining(
        final ApplyTerm apply, final StatementFormatter fmt,
        final boolean stmtsOkay)
    {
        final String expr = "((int)Math.floor(" +
            fmt.formatTermAs(apply.getArg(), double.class) + "))";

        if (stmtsOkay)
            return expr;

        return fmt.fixup(apply.getLoc(), expr, int.class);
    }
}
