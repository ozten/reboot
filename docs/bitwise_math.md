# Bitwise Math

Although specialized chips can do advanced math,
CPUs have very primitive math capabilities in the simplest case.

CPUs natively work with numbers encoded in binary and
are capable of efficiently doing logical shift operations.

For special cases, this can produce multiplication and division.

The special case is that shifting a number left by 4 has the effect of multiplying it by 16,
which is 2 to the power of 4.

Conversly shifting a number to the right by 4 has the effect of dividing it by 16 and rounding down to zero.

The special case works well if you have multiples of 2, such as trying to turn 1600 into 100.
You can accomplish this very efficiently with a single operation.


## Logical Shift Examples

### JavaScript

The following is a JavaScript expression, say `23 << 1`.
To the right is `23` in binary.
Below is the result of evaluating the JavaScript.
To the right of that is the result in binary.

    23 << 1       10111
    46           101110

    23 >> 1       10111
    11             1011

    23 << 2       10111
    92          1011100

    23 >> 2       10111
    5               101

    23 << 3		  10111
    184		   10111000

    23 >> 3		  10111
    23               10