/**
 * ADOBE SYSTEMS INCORPORATED
 * Copyright 2009-2013 Adobe Systems Incorporated
 * All Rights Reserved.
 * <p>
 * NOTICE: Adobe permits you to use, modify, and distribute
 * this file in accordance with the terms of the MIT license,
 * a copy of which can be found in the LICENSE.txt file or at
 * http://opensource.org/licenses/MIT.
 */
package compile.term;

import compile.Loc;
import compile.term.visit.TermVisitor;

import java.util.ArrayList;
import java.util.LinkedHashMap;

/**
 * Term representing a record literal expression.
 *
 * @author Basil Hosmer
 */
public final class RecordTerm extends KeyedTerm
{
    // cached
    protected ArrayList<SimpleLiteralTerm> keyList = null;

    public RecordTerm(final Loc loc, final LinkedHashMap<Term, Term> items)
    {
        super(loc, items);
    }

    public ArrayList<SimpleLiteralTerm> getKeyList()
    {
        if (keyList == null)
        {
            keyList = new ArrayList<>();

            for (final Term key : getItems().keySet())
                keyList.add((SimpleLiteralTerm) key);
        }

        return keyList;
    }


    // Term

    public <T> T accept(final TermVisitor<T> visitor)
    {
        return visitor.visit(this);
    }

    // Term

}