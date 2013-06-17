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


public class SetAll {

    public static void apply1(ArrayBoolean array, Bl1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setBooleanCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayChar array, C1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setCharCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayByte array, B1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setByteCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayShort array, S1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setShortCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayInt array, I1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setIntCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayLong array, L1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setLongCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayFloat array, F1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setFloatCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayDouble array, D1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setDoubleCurrent(func.apply(counter[0]));
	}
    }

    public static void apply1(ArrayObject array, O1 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setObjectCurrent(func.apply(counter[0]));
	}
    }

    //------------------------------------------------------------------------------------
    // Set all values of an 2 dimensional array
    //------------------------------------------------------------------------------------

    public static void apply2(ArrayByte array, B2 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setByteCurrent(func.apply(counter[0], counter[1]));
	}
    }

    public static void apply2(ArrayShort array, S2 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setShortCurrent(func.apply(counter[0], counter[1]));
	}
    }

    public static void apply2(ArrayInt array, I2 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setIntCurrent(func.apply(counter[0], counter[1]));
	}
    }

    public static void apply2(ArrayLong array, L2 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setLongCurrent(func.apply(counter[0], counter[1]));
	}
    }

    public static void apply2(ArrayFloat array, F2 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setFloatCurrent(func.apply(counter[0], counter[1]));
	}
    }

    public static void apply2(ArrayDouble array, D2 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setDoubleCurrent(func.apply(counter[0], counter[1]));
	}
    }

    //------------------------------------------------------------------------------------
    // Set all values of an 3 dimensional array
    //------------------------------------------------------------------------------------

    public static void apply3(ArrayByte array, B3 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setByteCurrent(func.apply(counter[0], counter[1], counter[2]));
	}
    }

    public static void apply3(ArrayShort array, S3 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setShortCurrent(func.apply(counter[0], counter[1], counter[2]));
	}
    }

    public static void apply3(ArrayInt array, I3 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setIntCurrent(func.apply(counter[0], counter[1], counter[2]));
	}
    }

    public static void apply3(ArrayLong array, L3 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setLongCurrent(func.apply(counter[0], counter[1], counter[2]));
	}
    }

    public static void apply3(ArrayFloat array, F3 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setFloatCurrent(func.apply(counter[0], counter[1], counter[2]));
	}
    }

    public static void apply3(ArrayDouble array, D3 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setDoubleCurrent(func.apply(counter[0], counter[1], counter[2]));
	}
    }

    //------------------------------------------------------------------------------------
    // Set all values of an 4 dimensional array
    //------------------------------------------------------------------------------------

    public static void apply4(ArrayByte array, B4 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setByteCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3]));
	}
    }

    public static void apply4(ArrayShort array, S4 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setShortCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3]));
	}
    }

    public static void apply4(ArrayInt array, I4 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setIntCurrent(func.apply(counter[0], counter[1], counter[2],
					      counter[3]));
	}
    }

    public static void apply4(ArrayLong array, L4 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setLongCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3]));
	}
    }

    public static void apply4(ArrayFloat array, F4 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setFloatCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3]));
	}
    }

    public static void apply4(ArrayDouble array, D4 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setDoubleCurrent(func.apply(counter[0], counter[1], counter[2],
						 counter[3]));
	}
    }

    //------------------------------------------------------------------------------------
    // Set all values of an 5 dimensional array
    //------------------------------------------------------------------------------------

    public static void apply5(ArrayByte array, B5 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setByteCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3], counter[4]));
	}
    }

    public static void apply5(ArrayShort array, S5 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setShortCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3], counter[4]));
	}
    }

    public static void apply5(ArrayInt array, I5 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setIntCurrent(func.apply(counter[0], counter[1], counter[2],
					      counter[3], counter[4]));
	}
    }

    public static void apply5(ArrayLong array, L5 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setLongCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3], counter[4]));
	}
    }

    public static void apply5(ArrayFloat array, F5 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setFloatCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3], counter[4]));
	}
    }

    public static void apply5(ArrayDouble array, D5 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setDoubleCurrent(func.apply(counter[0], counter[1], counter[2],
						 counter[3], counter[4]));
	}
    }

    //------------------------------------------------------------------------------------
    // Set all values of an 6 dimensional array
    //------------------------------------------------------------------------------------

    public static void apply6(ArrayByte array, B6 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setByteCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3], counter[4], counter[5]));
	}
    }

    public static void apply6(ArrayShort array, S6 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setShortCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3], counter[4], counter[5]));
	}
    }

    public static void apply6(ArrayInt array, I6 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setIntCurrent(func.apply(counter[0], counter[1], counter[2],
					      counter[3], counter[4], counter[5]));
	}
    }

    public static void apply6(ArrayLong array, L6 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setLongCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3], counter[4], counter[5]));
	}
    }

    public static void apply6(ArrayFloat array, F6 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setFloatCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3], counter[4], counter[5]));
	}
    }

    public static void apply6(ArrayDouble array, D6 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setDoubleCurrent(func.apply(counter[0], counter[1], counter[2],
						 counter[3], counter[4], counter[5]));
	}
    }

    //------------------------------------------------------------------------------------
    // Set all values of an 7 dimensional array
    //------------------------------------------------------------------------------------

    public static void apply7(ArrayByte array, B7 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setByteCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3], counter[4], counter[5],
					       counter[6]));
	}
    }

    public static void apply7(ArrayShort array, S7 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setShortCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3], counter[4], counter[5],
						counter[6]));
	}
    }

    public static void apply7(ArrayInt array, I7 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setIntCurrent(func.apply(counter[0], counter[1], counter[2],
					      counter[3], counter[4], counter[5],
					      counter[6]));
	}
    }

    public static void apply7(ArrayLong array, L7 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setLongCurrent(func.apply(counter[0], counter[1], counter[2],
					       counter[3], counter[4], counter[5],
					       counter[6]));
	}
    }

    public static void apply7(ArrayFloat array, F7 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setFloatCurrent(func.apply(counter[0], counter[1], counter[2],
						counter[3], counter[4], counter[5],
						counter[6]));
	}
    }

    public static void apply7(ArrayDouble array, D7 func) {
	IndexIterator iterator = array.getIndexIterator();
	int[] counter;
	while (iterator.hasNext()) {
	    iterator.next();
	    counter = iterator.getCurrentCounter();
	    iterator.setDoubleCurrent(func.apply(counter[0], counter[1], counter[2],
						 counter[3], counter[4], counter[5],
						 counter[6]));
	}
    }

    //------------------------------------------------------------------------------------
    // Set all values of an array of size larger than 7
    //------------------------------------------------------------------------------------

    public static void apply(ArrayByte array, B func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.next();
	    iterator.setByteCurrent(func.apply(iterator.getCurrentCounter()));
	}
    }

    public static void apply(ArrayShort array, S func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.next();
	    iterator.setShortCurrent(func.apply(iterator.getCurrentCounter()));
	}
    }

    public static void apply(ArrayInt array, I func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.next();
	    iterator.setIntCurrent(func.apply(iterator.getCurrentCounter()));
	}
    }

    public static void apply(ArrayLong array, L func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.next();
	    iterator.setLongCurrent(func.apply(iterator.getCurrentCounter()));
	}
    }

    public static void apply(ArrayFloat array, F func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.next();
	    iterator.setFloatCurrent(func.apply(iterator.getCurrentCounter()));
	}
    }

    public static void apply(ArrayDouble array, D func) {
	IndexIterator iterator = array.getIndexIterator();
	while (iterator.hasNext()) {
	    iterator.next();
	    iterator.setDoubleCurrent(func.apply(iterator.getCurrentCounter()));
	}
    }
    
}