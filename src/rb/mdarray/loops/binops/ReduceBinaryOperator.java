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

public class ReduceBinaryOperator {

    public static double apply(double calc, Array op1, double op2, DDDD func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getDoubleNext(), op2));
	}
	return calc;
    }

    public static double apply(double calc, Array op1, Array op2, DDDD func) {
	IndexIterator iteratorOp1 = op1.getIndexIterator();
	IndexIterator iteratorOp2 = op2.getIndexIterator();
	while (iteratorOp1.hasNext()) {
	    calc = (func.apply(calc, iteratorOp1.getDoubleNext(),
			      iteratorOp2.getDoubleNext()));
	}
	return calc;
    }    

}