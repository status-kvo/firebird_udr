SET TERM ^ ;

CREATE OR ALTER package regexp
as
begin

  procedure match(pattern d_str_8100, subject d_str_8100)
    returns (matches d_str_8100);

  function is_match(pattern d_str_8100, subject d_str_8100)
    returns d_bool not null;

  function replace(pattern d_str_8100, replacement d_str_8100, subject d_str_8100)
    returns d_str_8100;

  procedure split(pattern d_str_8100, subject d_str_8100)
    returns (lines d_str_8100);

  function quote(str d_str_8100, delimiter char(10))
    returns d_str_8100;

end^

RECREATE package body regexp
as
begin

  procedure match(pattern d_str_8100, subject d_str_8100)
    returns (matches d_str_8100)
    external name 'mbulak.udr!RegExp.Match'
    engine   udr;

  function is_match(pattern d_str_8100, subject d_str_8100)
    returns d_bool not null
  as
  begin
    return iif(exists(select * from match(:pattern, :subject)), 1, 0);
  end

  function replace(pattern d_str_8100, replacement d_str_8100, subject d_str_8100)
    returns d_str_8100
    external name 'mbulak.udr!RegExp.Replace'
    engine   udr;

  procedure split(pattern d_str_8100, subject d_str_8100)
    returns (lines d_str_8100)
    external name 'mbulak.udr!RegExp.Split'
    engine   udr;

  function quote(str d_str_8100, delimiter char(10))
    returns d_str_8100
    external name 'mbulak.udr!RegExp.Quote'
    engine   udr;

end
^

SET TERM ; ^

/* Существующие привилегии на этот пакет */