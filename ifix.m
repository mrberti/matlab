function IFIX = ifix( x, comma_pos )
  IFIX = cast(x,"double")/2^comma_pos;
endfunction