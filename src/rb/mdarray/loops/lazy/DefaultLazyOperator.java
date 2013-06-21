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

package rb.mdarray.loops.lazy;

import ucar.ma2.*;
/* Functions from cern.colt */
import cern.colt.function.tdouble.*;
import cern.colt.function.tfloat.*;
import cern.colt.function.tlong.*;
import cern.colt.function.tint.*;

/* Functions not defined in cern.colt */
import rb.mdarray.functions.tshort.*;
import rb.mdarray.functions.tbyte.*;
import rb.mdarray.functions.tdouble.*;
import rb.mdarray.functions.tfloat.*;
import rb.mdarray.functions.tlong.*;
import rb.mdarray.functions.tint.*;

/* Non-numeric functions */
import rb.mdarray.functions.tboolean.*;
import rb.mdarray.functions.tchar.*;
import rb.mdarray.functions.tobject.*;


public class DefaultLazyOperator {
    
    //------------------------------------------------------------------------------------
    // Default binary for lazy operators
    //------------------------------------------------------------------------------------

    public static void apply(ArrayByte dest, ByteMethod func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	for (long i = dest.getSize(); --i >= 0; ) {
	    iteratorDest.setByteNext(func.apply());
	}
    }

    public static void apply(ArrayShort dest, ShortMethod func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	for (long i = dest.getSize(); --i >= 0; ) {
	    iteratorDest.setShortNext(func.apply());
	}
    }

    public static void apply(ArrayInt dest, IntMethod func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	for (long i = dest.getSize(); --i >= 0; ) {
	    iteratorDest.setIntNext(func.apply());
	}
    }

    public static void apply(ArrayLong dest, LongMethod func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	for (long i = dest.getSize(); --i >= 0; ) {
	    iteratorDest.setLongNext(func.apply());
	}
    }

    public static void apply(ArrayFloat dest, FloatMethod func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	for (long i = dest.getSize(); --i >= 0; ) {
	    iteratorDest.setFloatNext(func.apply());
	}
    }

    public static void apply(ArrayDouble dest, DoubleMethod func) {
	IndexIterator iteratorDest = dest.getIndexIterator();
	for (long i = dest.getSize(); --i >= 0; ) {
	    iteratorDest.setDoubleNext(func.apply());
	}
    }

}
