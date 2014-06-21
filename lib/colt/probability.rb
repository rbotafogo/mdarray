Returns the area from zero to x under the beta density function.
                          x
            -             -
           | (a+b)       | |  a-1      b-1
 P(x)  =  ----------     |   t    (1-t)    dt
           -     -     | |
          | (a) | (b)   -
                         0
 
This function is identical to the incomplete beta integral function 
Gamma.incompleteBeta(a, b, x). The complemented function is 1 - P(1-x) = 
Gamma.incompleteBeta( b, a, x );
