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

package rb.mdarray.loops.binops;

import ucar.ma2.*;
/* Functions from cern.colt */
import cern.colt.function.tdouble.*;
import cern.colt.function.tfloat.*;
import cern.colt.function.tlong.*;
import cern.colt.function.tint.*;

/* Functions not defined in cern.colt */
import rb.mdarray.functions.tdouble.*;
import rb.mdarray.functions.tfloat.*;
import rb.mdarray.functions.tlong.*;
import rb.mdarray.functions.tint.*;
import rb.mdarray.functions.tshort.*;
import rb.mdarray.functions.tbyte.*;

/* Non-numeric functions */
import rb.mdarray.functions.tboolean.*;
import rb.mdarray.functions.tchar.*;
import rb.mdarray.functions.tobject.*;

public class ReduceBinaryOperator {


    /*
    // Reduce binary operators should all be done with double method.
     
    public static byte apply(byte calc, ArrayByte op1, byte op2, 
			     ByteByteByteFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getByteNext(), op2));
	}
	return calc;
    }

    public static byte apply(byte calc, ArrayByte op1, Array op2, 
			     ByteByteByteFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getByteNext(),
			       iteratorOp2.getByteNext()));
	}
	return calc;
    }    

    public static short apply(short calc, ArrayShort op1, short op2, 
			       ShortShortShortFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getShortNext(), op2));
	}
	return calc;
    }

    public static short apply(short calc, ArrayShort op1, Array op2, 
			      ShortShortShortFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getShortNext(),
			       iteratorOp2.getShortNext()));
	}
	return calc;
    }    

    public static int apply(int calc, ArrayInt op1, int op2, 
			    IntIntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getIntNext(), op2));
	}
	return calc;
    }

    public static int apply(int calc, ArrayInt op1, Array op2, 
			    IntIntIntFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getIntNext(),
			       iteratorOp2.getIntNext()));
	}
	return calc;
    }    

    public static long apply(long calc, ArrayLong op1, long op2, 
			     LongLongLongFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getLongNext(), op2));
	}
	return calc;
    }

    public static long apply(long calc, ArrayLong op1, Array op2, 
			     LongLongLongFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getLongNext(),
			       iteratorOp2.getLongNext()));
	}
	return calc;
    }

    public static float apply(float calc, ArrayFloat op1, float op2, 
			      FloatFloatFloatFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getFloatNext(), op2));
	}
	return calc;
    }

    public static float apply(float calc, ArrayFloat op1, Array op2, 
			      FloatFloatFloatFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getFloatNext(),
			       iteratorOp2.getFloatNext()));
	}
	return calc;
    }    
    */

    public static double apply(double calc, Array op1, double op2, 
			       DoubleDoubleDoubleFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	for (long i = op1.getSize(); --i >= 0; ) {
	    calc = (func.apply(calc, iteratorOp1.getDoubleNext(), op2));
	}
	return calc;
    }

    public static double apply(double calc, Array op1, Array op2, 
			       DoubleDoubleDoubleFunction func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	for (long i = op1.getSize(); --i >= 0; ) {
	    calc = (func.apply(calc, iteratorOp1.getDoubleNext(),
			      iteratorOp2.getDoubleNext()));
	}
	return calc;
    }

}