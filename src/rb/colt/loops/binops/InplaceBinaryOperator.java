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

package rb.colt.loops.binops;

import ucar.ma2.*;
import cern.colt.function.tdouble.*;
import cern.colt.function.tfloat.*;
import cern.colt.function.tint.*;


public class InplaceBinaryOperator {

    public static void apply(Array op1, int op2, IntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorOp1.setIntCurrent(func.apply(iteratorOp1.getIntNext(), op2));
	}
    }

    public static void apply(Array op1, Array op2, IntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorOp1.setIntCurrent(func.apply(iteratorOp1.getIntNext(),
						 iteratorOp2.getIntNext()));
	}
    }

    public static void apply(Array op1, float op2, FloatFloatFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorOp1.setFloatCurrent(func.apply(iteratorOp1.getFloatNext(), op2));
	}
    }

    public static void apply(Array op1, Array op2, FloatFloatFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorOp1.setFloatCurrent(func.apply(iteratorOp1.getFloatNext(),
						   iteratorOp2.getFloatNext()));
	}
    }

    public static void apply(Array op1, double op2, DoubleDoubleFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorOp1.setDoubleCurrent(func.apply(iteratorOp1.getDoubleNext(), op2));
	}
    }
    
    public static void apply(Array op1, Array op2, DoubleDoubleFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorOp1.setDoubleCurrent(func.apply(iteratorOp1.getDoubleNext(),
						    iteratorOp2.getDoubleNext()));
	}
    }

}