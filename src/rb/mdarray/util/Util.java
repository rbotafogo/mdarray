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

package rb.mdarray.util;

import ucar.ma2.*;

import cern.colt.function.tdouble.*;
import rb.mdarray.functions.tdouble.*;
import rb.mdarray.util.tdouble.*;

import cern.colt.function.tint.*;
import rb.mdarray.functions.tint.*;
import rb.mdarray.util.tint.*;



public class Util {

    public static IntMethod getIterator(ArrayInt arr) {
	return new IteratorIntNext(arr.getIndexIterator());
    }

    public static IntMethod compose(IntFunction f, IntMethod x) {
	return new IntIntCompose(f, x);
    }

    public static IntMethod compose(IntIntFunction f, IntMethod x, IntMethod y) {
	return new IntIntIntCompose(f, x, y);
    }

    public static DoubleMethod getIterator(ArrayDouble arr) {
	return new IteratorDoubleNext(arr.getIndexIterator());
    }

    public static DoubleMethod compose(DoubleFunction f, DoubleMethod x) {
	return new DoubleDoubleCompose(f, x);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, DoubleMethod x,
				       DoubleMethod y) {
	return new DoubleDoubleDoubleCompose(f, x, y);
    }

}
