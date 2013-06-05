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


public class DefaultBinaryOperator {

    /*    
    public static void 
	defaultBinaryOperator(ArrayByte dest, Array op1, int op2, 
			      IntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setByteNext(func.apply(iteratorOp1.getIntNext(), op2));
	}
    }

    public static void 
	defaultBinaryOperator(ArrayByte dest, Array op1, Array op2, 
			      IntIntFunction func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setByteNext(func.apply(iteratorOp1.getIntNext(),
						iteratorOp2.getIntNext()));
	}
    }

    public static void 
	defaultBinaryOperator(ArrayShort dest, Array op1, int op2, 
			      IntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setShortNext(func.apply(iteratorOp1.getIntNext(), op2));
	}
    }

    public static void 
	defaultBinaryOperator(ArrayShort dest, Array op1, Array op2, 
			      IntIntFunction func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setShortNext(func.apply(iteratorOp1.getIntNext(),
						 iteratorOp2.getIntNext()));
	}
    }
    */

    public static void apply(ArrayInt dest, Array op1, int op2,  IntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setIntNext(func.apply(iteratorOp1.getIntNext(), op2));
	}
    }

    public static void apply(ArrayInt dest, Array op1, Array op2, IntIntFunction func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setIntNext(func.apply(iteratorOp1.getIntNext(),
						  iteratorOp2.getIntNext()));
	}
    }

    public static void apply(ArrayLong dest, Array op1, int op2, IntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setLongNext(func.apply(iteratorOp1.getIntNext(), op2));
	}
    }

    public static void apply(ArrayLong dest, Array op1, Array op2, IntIntFunction func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setLongNext(func.apply(iteratorOp1.getIntNext(),
						iteratorOp2.getIntNext()));
	}
    }

    public static void apply(ArrayFloat dest, Array op1, float op2, FloatFloatFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setFloatNext(func.apply(iteratorOp1.getFloatNext(), op2));
	}
    }

    public static void apply(ArrayFloat dest, Array op1, Array op2, FloatFloatFunction func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setFloatNext(func.apply(iteratorOp1.getFloatNext(),
						 iteratorOp2.getFloatNext()));
	}
    }

    public static void apply(ArrayDouble dest, Array op1, double op2, 
			     DoubleDoubleFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setDoubleNext(func.apply(iteratorOp1.getDoubleNext(), op2));
	}
    }

    public static void apply(ArrayDouble dest, Array op1, Array op2, 
			     DoubleDoubleFunction func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setDoubleNext(func.apply(iteratorOp1.getDoubleNext(),
						  iteratorOp2.getDoubleNext()));
	}
    }

}
