function FIX = fix16( x, comma_pos, type )
    if nargin < 3
        type = 'int32';
    end
    FIX = cast(x*2^comma_pos, type);
end