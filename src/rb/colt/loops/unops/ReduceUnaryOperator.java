/*****************************************************************************************
 * @author Rodrigo Botafogo
 *
 * Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, 
 * modify, and distribute this software and its documentation, without fee and without a 
 * signed licensing agreement, is hereby granted, provided that the above copyright notice, 
 * this paragraph and the following two paragraphs appear in all copies, modifications, and 
 * distributions.
 *
 * IN NO EVENT SHALL RODRIGO BOTAFOGO BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
 * INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF 
 * THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF RODRIGO BOTAFOGO HAS BEEN ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * RODRIGO BOTAFOGO SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
 * SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". 
 * RODRIGO BOTAFOGO HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, 
 * ENHANCEMENTS, OR MODIFICATIONS.
 *****************************************************************************************/

package rb.colt.loops.unops;

import ucar.ma2.*;
import cern.colt.function.tdouble.*;
import cern.colt.function.tfloat.*;
import cern.colt.function.tint.*;


public class ReduceUnaryOperator {

    public static int apply(int calc, Array op, IntIntFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    calc = (func.apply(calc, iteratorOp.getIntNext()));
	}
	return calc;
    }

    public static float apply(float calc, Array op, FloatFloatFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    calc = (func.apply(calc, iteratorOp.getFloatNext()));
	}
	return calc;
    }

    public static double apply(double calc, Array op, DoubleDoubleFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    calc = (func.apply(calc, iteratorOp.getDoubleNext()));
	}
	return calc;
    }

}