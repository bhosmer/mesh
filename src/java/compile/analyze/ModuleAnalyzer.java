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
package compile.analyze;

import compile.module.Module;

/**
 * Module analysis pipeline. Incoming module is as-parsed,
 * outgoing module is ready for CG.
 *
 * @author Basil Hosmer
 */
public final class ModuleAnalyzer
{
    /**
     * Push a new module through analysis steps. On successful completion,
     * module is ready for codegen, e.g. by {@link compile.gen.java.JavaUnitBuilder} for JVM.
     *
     * @param module module to be analyzed
     * @return success
     */
    public static boolean analyze(final Module module)
    {
        return
            // setup namespaces and import symbols and types
            new ImportResolver(module).resolve() &&

            // collect value bindings, type bindings, module imports
            new BindingCollector(module).collect() &&

            // setup export list
            new ExportProcessor(module).resolve() &&

            // resolve names
            new RefResolver(module).resolve() &&

            // check forward references
            new RefChecker(module).check() &&

            // infer and check types
            new TypeChecker(module).check() &&

            //
            // post-typecheck optimizations
            //

            // constant folding/propagation
            new ConstantReducer(module).reduce();
    }
}
