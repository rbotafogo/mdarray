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

import cern.colt.function.tfloat.*;
import rb.mdarray.functions.tfloat.*;
import rb.mdarray.util.tfloat.*;

import cern.colt.function.tlong.*;
import rb.mdarray.functions.tlong.*;
import rb.mdarray.util.tlong.*;

import cern.colt.function.tint.*;
import rb.mdarray.functions.tint.*;
import rb.mdarray.util.tint.*;

import cern.colt.function.tshort.*;
import rb.mdarray.functions.tshort.*;
import rb.mdarray.util.tshort.*;

import cern.colt.function.tbyte.*;
import rb.mdarray.functions.tbyte.*;
import rb.mdarray.util.tbyte.*;


public class Util {

    // Byte methods

    public static ByteMethod getIterator(ArrayByte arr) {
	return new IteratorByteNext(arr.getIndexIterator());
    }

    public static ByteMethod compose(ByteFunction f, ByteMethod x) {
	return new ByteByteCompose(f, x);
    }

    public static ByteMethod compose(ByteByteFunction f, ByteMethod x, 
				     ByteMethod y) {
	return new ByteByteByteCompose(f, x, y);
    }

    // Short methods

    public static ShortMethod getIterator(ArrayShort arr) {
	return new IteratorShortNext(arr.getIndexIterator());
    }

    public static ShortMethod compose(ShortFunction f, ShortMethod x) {
	return new ShortShortCompose(f, x);
    }

    public static ShortMethod compose(ShortShortFunction f, ShortMethod x, 
				      ShortMethod y) {
	return new ShortShortShortCompose(f, x, y);
    }

    public static ShortMethod compose(ShortShortFunction f, ShortMethod x, 
				      ByteMethod y) {
	return new ShortShortByteCompose(f, x, y);
    }

    public static ShortMethod compose(ShortShortFunction f, ByteMethod x, 
				      ShortMethod y) {
	return new ShortByteShortCompose(f, x, y);
    }

    // Int methods

    public static IntMethod getIterator(ArrayInt arr) {
	return new IteratorIntNext(arr.getIndexIterator());
    }

    public static IntMethod compose(IntFunction f, IntMethod x) {
	return new IntIntCompose(f, x);
    }

    public static IntMethod compose(IntIntFunction f, IntMethod x, IntMethod y) {
	return new IntIntIntCompose(f, x, y);
    }

    public static IntMethod compose(IntIntFunction f, IntMethod x, ShortMethod y) {
	return new IntIntShortCompose(f, x, y);
    }

    public static IntMethod compose(IntIntFunction f, ShortMethod x, IntMethod y) {
	return new IntShortIntCompose(f, x, y);
    }

    public static IntMethod compose(IntIntFunction f, IntMethod x, ByteMethod y) {
	return new IntIntByteCompose(f, x, y);
    }

    public static IntMethod compose(IntIntFunction f, ByteMethod x, IntMethod y) {
	return new IntByteIntCompose(f, x, y);
    }

    // Long methods

    public static LongMethod getIterator(ArrayLong arr) {
	return new IteratorLongNext(arr.getIndexIterator());
    }

    public static LongMethod compose(LongFunction f, LongMethod x) {
	return new LongLongCompose(f, x);
    }

    public static LongMethod compose(LongLongFunction f, LongMethod x,
				     LongMethod y) {
	return new LongLongLongCompose(f, x, y);
    }

    public static LongMethod compose(LongLongFunction f, LongMethod x,
				     IntMethod y) {
	return new LongLongIntCompose(f, x, y);
    }

    public static LongMethod compose(LongLongFunction f, IntMethod x, 
				     LongMethod y) {
	return new LongIntLongCompose(f, x, y);
    }

    public static LongMethod compose(LongLongFunction f, LongMethod x,
				     ShortMethod y) {
	return new LongLongShortCompose(f, x, y);
    }

    public static LongMethod compose(LongLongFunction f, ShortMethod x, 
				     LongMethod y) {
	return new LongShortLongCompose(f, x, y);
    }

    public static LongMethod compose(LongLongFunction f, LongMethod x,
				     ByteMethod y) {
	return new LongLongByteCompose(f, x, y);
    }

    public static LongMethod compose(LongLongFunction f, ByteMethod x, 
				     LongMethod y) {
	return new LongByteLongCompose(f, x, y);
    }

    // Float methods

    public static FloatMethod getIterator(ArrayFloat arr) {
	return new IteratorFloatNext(arr.getIndexIterator());
    }

    public static FloatMethod compose(FloatFunction f, FloatMethod x) {
	return new FloatFloatCompose(f, x);
    }

    public static FloatMethod compose(FloatFloatFunction f, FloatMethod x,
				      FloatMethod y) {
	return new FloatFloatFloatCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, FloatMethod x,
				      LongMethod y) {
	return new FloatFloatLongCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, LongMethod x, 
				      FloatMethod y) {
	return new FloatLongFloatCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, FloatMethod x,
				      IntMethod y) {
	return new FloatFloatIntCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, IntMethod x, 
				      FloatMethod y) {
	return new FloatIntFloatCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, FloatMethod x,
				      ShortMethod y) {
	return new FloatFloatShortCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, ShortMethod x, 
				      FloatMethod y) {
	return new FloatShortFloatCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, FloatMethod x,
				      ByteMethod y) {
	return new FloatFloatByteCompose(f, x, y);
    }

    public static FloatMethod compose(FloatFloatFunction f, ByteMethod x, 
				      FloatMethod y) {
	return new FloatByteFloatCompose(f, x, y);
    }

    // Double methods

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

    public static DoubleMethod compose(DoubleDoubleFunction f, DoubleMethod x,
				       FloatMethod y) {
	return new DoubleDoubleFloatCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, FloatMethod x, 
				       DoubleMethod y) {
	return new DoubleFloatDoubleCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, DoubleMethod x,
				       LongMethod y) {
	return new DoubleDoubleLongCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, LongMethod x, 
				       DoubleMethod y) {
	return new DoubleLongDoubleCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, DoubleMethod x,
				       IntMethod y) {
	return new DoubleDoubleIntCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, IntMethod x, 
				       DoubleMethod y) {
	return new DoubleIntDoubleCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, DoubleMethod x,
				       ShortMethod y) {
	return new DoubleDoubleShortCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, ShortMethod x, 
				       DoubleMethod y) {
	return new DoubleShortDoubleCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, DoubleMethod x,
				       ByteMethod y) {
	return new DoubleDoubleByteCompose(f, x, y);
    }

    public static DoubleMethod compose(DoubleDoubleFunction f, ByteMethod x, 
				       DoubleMethod y) {
	return new DoubleByteDoubleCompose(f, x, y);
    }

}
