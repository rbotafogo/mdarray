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

package rb.mdarray.loops.unops;

import ucar.ma2.*;
/* Functions from cern.colt */
import cern.colt.function.tdouble.*;
import cern.colt.function.tfloat.*;
import cern.colt.function.tlong.*;
import cern.colt.function.tint.*;
import cern.colt.function.tshort.*;
import cern.colt.function.tbyte.*;

/* Functions not defined in cern.colt */
import rb.mdarray.functions.tshort.*;
import rb.mdarray.functions.tbyte.*;

/* Non-numeric functions */
import rb.mdarray.functions.tboolean.*;
import rb.mdarray.functions.tchar.*;
import rb.mdarray.functions.tobject.*;


public class DefaultUnaryOperator {

    public static void apply(ArrayByte dest, Array op, ByteFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    iteratorDest.setByteNext(func.apply(iteratorOp.getByteNext()));
	}
    }

    public static void apply(ArrayShort dest, Array op, ShortFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    iteratorDest.setShortNext(func.apply(iteratorOp.getShortNext()));
	}
    }

    public static void apply(ArrayInt dest, Array op, IntFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    iteratorDest.setIntNext(func.apply(iteratorOp.getIntNext()));
	}
    }

    public static void apply(ArrayLong dest, Array op, LongFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    iteratorDest.setLongNext(func.apply(iteratorOp.getLongNext()));
	}
    }

    public static void apply(ArrayFloat dest, Array op, FloatFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    iteratorDest.setFloatNext(func.apply(iteratorOp.getFloatNext()));
	}
    }

    public static void apply(ArrayDouble dest, Array op, DoubleFunction func) {
	IndexIterator iteratorOp = op.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOp.hasNext()) {
	    iteratorDest.setDoubleNext(func.apply(iteratorOp.getDoubleNext()));
	}
    }

    //------------------------------------------------------------------------------------
    // Default unary for boolean operators
    //------------------------------------------------------------------------------------

    public static void apply(ArrayBoolean dest, ArrayBoolean op1, 
					   BooleanFunction func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    iteratorDest.setBooleanNext(func.apply(iteratorOp1.getBooleanNext()));
	}
    }

}
