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
import rb.mdarray.functions.tboolean.*;
import rb.mdarray.functions.tbyte.*;
import rb.mdarray.functions.tchar.*;
import rb.mdarray.functions.tdouble.*;
import rb.mdarray.functions.tfloat.*;
import rb.mdarray.functions.tint.*;
import rb.mdarray.functions.tlong.*;
import rb.mdarray.functions.tobject.*;
import rb.mdarray.functions.tshort.*;

public class DefaultUnaryOperator {
    
    public static void apply(ArrayBoolean dest, Array orig, BlBl func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setBooleanNext(func.apply(iteratorOrig.getBooleanNext()));
	}
    }

    public static void apply(ArrayChar dest, Array orig, CC func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setCharNext(func.apply(iteratorOrig.getCharNext()));
	}
    }

    public static void apply(ArrayByte dest, Array orig, BB func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setByteNext(func.apply(iteratorOrig.getByteNext()));
	}
    }

    public static void apply(ArrayShort dest, Array orig, SS func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setShortNext(func.apply(iteratorOrig.getShortNext()));
	}
    }

    public static void apply(ArrayInt dest, Array orig, II func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setIntNext(func.apply(iteratorOrig.getIntNext()));
	}
    }

    public static void apply(ArrayLong dest, Array orig, LL func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setLongNext(func.apply(iteratorOrig.getLongNext()));
	}
    }

    public static void apply(ArrayFloat dest, Array orig, FF func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setFloatNext(func.apply(iteratorOrig.getFloatNext()));
	}
    }

    public static void apply(ArrayDouble dest, Array orig, DD func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setDoubleNext(func.apply(iteratorOrig.getDoubleNext()));
	}
    }

    public static void apply(ArrayObject dest, Array orig, OO func) {
	IndexIterator iteratorOrig = orig.getIndexIterator();
	IndexIterator iteratorDest = dest.getIndexIterator();
	while (iteratorOrig.hasNext()) {
	    iteratorDest.setObjectNext(func.apply(iteratorOrig.getObjectNext()));
	}
    }

}