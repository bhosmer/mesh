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
package compile.type.visit;

import compile.term.Term;
import compile.term.visit.TermVisitor;
import compile.term.TypeDef;
import compile.type.*;
import compile.type.constraint.Constraint;

import java.util.*;

/**
 * Base class for type visitors, implements traversal only.
 */
public abstract class TypeVisitorBase<T> implements TypeVisitor<T>
{
    /**
     * helper - process individual term.
     * subclasses can override to do pre/post processing
     */
    protected T visitType(final Type type)
    {
        if (type == null)
            assert false;

        return type.accept(this);
    }

    /**
     * helper - visit a collection of type terms, return a list of results
     */
    protected List<T> visitEach(final Collection<? extends Type> typeList)
    {
        final List<T> visitedList = new ArrayList<T>();

        for (final Type type : typeList)
            visitedList.add(visitType(type));

        return visitedList;
    }

    /**
     * helper - visit type param map
     * note: not called by default on param-carrying types
     */
    protected List<T> visitParams(final Map<String, TypeParam> params)
    {
        final List<T> visited = new ArrayList<T>();
        for (final TypeParam param : params.values())
        {
            visited.add(visitType(param));
        }
        return visited;
    }

    /**
     * Need this for visiting terms held by types, e.g. record key values, etc.
     * Subs override to visit terms attached to types.
     */
    protected TermVisitor<?> getTermVisitor()
    {
        return null;
    }

    /**
     * Internal helper - guards against null term visitor.
     */
    private void visitTerm(final Term term)
    {
        final TermVisitor<?> termVisitor = getTermVisitor();

        if (termVisitor != null)
            term.accept(termVisitor);
    }

    // TypeVisitor

    public T visit(final WildcardType wildcard)
    {
        return null;
    }

    /**
     * Note: enum base type will be null until type
     * is preprocessed/checked
     */
    public T visit(final EnumType enumType)
    {
        if (enumType.getBaseType() != null)
            visitType(enumType.getBaseType());

        return null;
    }

    public T visit(final TypeVar var)
    {
        return null;
    }

    public T visit(final TypeParam param)
    {
        final Constraint constraint = param.getConstraint();
        if (constraint != null)
        {
            final Type constraintType = constraint.getType();
            if (constraintType != null)
                visitType(constraintType);
        }

        return null;
    }

    public T visit(final TypeRef ref)
    {
        return null;
    }

    public T visit(final TypeDef def)
    {
        visitType(def.getValue());
        return null;
    }

    // --------------------------------------------------------

    public T visit(final TypeCons cons)
    {
        final Type body = cons.getBody();

        if (body != null)
            visitType(body);

        return null;
    }

    public T visit(final TypeApp app)
    {
        visitType(app.getBase());
        visitType(app.getArg());
        return null;
    }

    public T visit(final TypeTuple tuple)
    {
        for (final Type member : tuple.getMembers())
            visitType(member);

        return null;
    }

    public T visit(final TypeList list)
    {
        for (final Type item : list.getItems())
            visitType(item);

        return null;
    }

    public T visit(final TypeMap map)
    {
        visitType(map.getKeyType());

        for (final Map.Entry<Term, Type> entry : map.getMembers().entrySet())
        {
            visitTerm(entry.getKey());
            visitType(entry.getValue());
        }

        return null;
    }
}
