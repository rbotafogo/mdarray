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
import rb.mdarray.functions.tboolean.*;
import rb.mdarray.functions.tbyte.*;
import rb.mdarray.functions.tchar.*;
import rb.mdarray.functions.tdouble.*;
import rb.mdarray.functions.tfloat.*;
import rb.mdarray.functions.tint.*;
import rb.mdarray.functions.tlong.*;
import rb.mdarray.functions.tobject.*;
import rb.mdarray.functions.tshort.*;

public class DefaultBinaryOperator {
    
    
    public static void apply(ArrayByte dest, Array op1, byte op2, BBB func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setByteNext(func.apply(iteratorOp1.getByteNext(), op2));
	}
    }

    public static void apply(ArrayByte dest, Array op1, Array op2, BBB func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setByteNext(func.apply(iteratorOp1.getByteNext(),
						iteratorOp2.getByteNext()));
	}
    }

    public static void apply(ArrayShort dest, Array op1, short op2, SSS func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setShortNext(func.apply(iteratorOp1.getShortNext(), op2));
	}
    }

    public static void apply(ArrayShort dest, Array op1, Array op2, SSS func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setShortNext(func.apply(iteratorOp1.getShortNext(),
						iteratorOp2.getShortNext()));
	}
    }

    public static void apply(ArrayInt dest, Array op1, int op2, III func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setIntNext(func.apply(iteratorOp1.getIntNext(), op2));
	}
    }

    public static void apply(ArrayInt dest, Array op1, Array op2, III func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setIntNext(func.apply(iteratorOp1.getIntNext(),
					      iteratorOp2.getIntNext()));
	}
    }

    public static void apply(ArrayLong dest, Array op1, long op2, LLL func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setLongNext(func.apply(iteratorOp1.getLongNext(), op2));
	}
    }

    public static void apply(ArrayLong dest, Array op1, Array op2, LLL func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setLongNext(func.apply(iteratorOp1.getLongNext(),
					       iteratorOp2.getLongNext()));
	}
    }

    public static void apply(ArrayFloat dest, Array op1, float op2, FFF func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setFloatNext(func.apply(iteratorOp1.getFloatNext(), op2));
	}
    }

    public static void apply(ArrayFloat dest, Array op1, Array op2, FFF func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setFloatNext(func.apply(iteratorOp1.getFloatNext(),
						iteratorOp2.getFloatNext()));
	}
    }

    public static void apply(ArrayDouble dest, Array op1, double op2, DDD func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setDoubleNext(func.apply(iteratorOp1.getDoubleNext(), op2));
	}
    }

    public static void apply(ArrayDouble dest, Array op1, Array op2, DDD func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setDoubleNext(func.apply(iteratorOp1.getDoubleNext(),
						 iteratorOp2.getDoubleNext()));
	}
    }

    //------------------------------------------------------------------------------------
    // Default binary for comparison operators
    //------------------------------------------------------------------------------------

    public static void apply(ArrayBoolean dest, Array op1, double op2, BlDD func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setBooleanNext(func.apply(iteratorOp1.getDoubleNext(), op2));
	}
    }

    public static void apply(ArrayBoolean dest, Array op1, Array op2, BlDD func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setBooleanNext(func.apply(iteratorOp1.getDoubleNext(),
						   iteratorOp2.getDoubleNext()));
	}
    }

    //------------------------------------------------------------------------------------
    // Default binary for boolean operators
    //------------------------------------------------------------------------------------

    public static void applyBooleanMDArray(ArrayBoolean dest, ArrayBoolean op1, 
					   ArrayBoolean op2, BlBlBl func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setBooleanNext(func.apply(iteratorOp1.getBooleanNext(),
						   iteratorOp2.getBooleanNext()));
	}
    }

}
