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

public class InplaceUnaryOperator {

    public static void apply(ArrayBoolean array, BlBl func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setBooleanCurrent(func.apply(iterator.getBooleanNext()));
	}
    }

    public static void apply(ArrayChar array, CC func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setCharCurrent(func.apply(iterator.getCharNext()));
	}
    }

    public static void apply(ArrayByte array, BB func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setByteCurrent(func.apply(iterator.getByteNext()));
	}
    }

    public static void apply(ArrayShort array, SS func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setShortCurrent(func.apply(iterator.getShortNext()));
	}
    }

    public static void apply(ArrayInt array, II func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setIntCurrent(func.apply(iterator.getIntNext()));
	}
    }

    public static void apply(ArrayLong array, LL func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setLongCurrent(func.apply(iterator.getLongNext()));
	}
    }

    public static void apply(ArrayFloat array, FF func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setFloatCurrent(func.apply(iterator.getFloatNext()));
	}
    }

    public static void apply(ArrayDouble array, DD func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setDoubleCurrent(func.apply(iterator.getDoubleNext()));
	}
    }

    public static void apply(ArrayObject array, OO func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.setObjectCurrent(func.apply(iterator.getObjectNext()));
	}
    }

}