CREATE or replace FUNCTION data_po_polsku(a date)
RETURNS varchar AS $$
declare
    d varchar default '';
    y varchar default '';
    m integer default 1;
    mons varchar[] default  '{"Sty","Lut","Mar","Kwi","Maj","Cze","Lip","Sie","Wrz","Paź","Lis","Gru"}';
BEGIN
    d := to_char($1, 'd') ;
    y := to_char($1, 'YY');
    m :=date_part('month', $1);
    return d || ' ' || mons[m] || ' ''' || y;
END; $$
LANGUAGE plpgsql;