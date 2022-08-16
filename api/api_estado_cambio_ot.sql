create or replace package api_estado_cambio_ot as
  type aat is table of estado_cambio_ot%rowtype index by binary_integer;
  type ntt is table of estado_cambio_ot%rowtype;

  procedure ins(
    p_rec in estado_cambio_ot%rowtype
  );

  procedure ins(
    p_coll aat
  );

  procedure upd(
    p_rec in estado_cambio_ot%rowtype
  );

  procedure upd(
    p_coll aat
  );

  procedure del(
    p_id_estado in estado_cambio_ot.id_estado%type
  );

  function onerow(
    p_id_estado in estado_cambio_ot.id_estado%type
  ) return estado_cambio_ot%rowtype result_cache;

  function allrows return aat;

  function exist(
    p_id_estado in estado_cambio_ot.id_estado%type
  ) return boolean;

  function estado_generado return estado_cambio_ot.id_estado%type;

  function estado_enviado return estado_cambio_ot.id_estado%type;

  function estado_aprobado return estado_cambio_ot.id_estado%type;

  function estado_rechazado return estado_cambio_ot.id_estado%type;

  function estado_anulado return estado_cambio_ot.id_estado%type;
end api_estado_cambio_ot;
/

create or replace package body api_estado_cambio_ot as
  gc_generado constant estado_cambio_ot.id_estado%type := 0;
  gc_enviado constant estado_cambio_ot.id_estado%type := 10;
  gc_aprobado constant estado_cambio_ot.id_estado%type := 40;
  gc_rechazado constant estado_cambio_ot.id_estado%type := 60;
  gc_anulado constant estado_cambio_ot.id_estado%type := 99;

  forall_err exception;
  pragma exception_init (forall_err, -24381);

  procedure ins(
    p_rec in estado_cambio_ot%rowtype
  ) is
  begin
    insert into estado_cambio_ot
    values p_rec;
  end;

  procedure ins(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      insert into estado_cambio_ot values p_coll(i);
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_estado ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));

      end loop;
      raise;
  end;

  procedure upd(
    p_rec in estado_cambio_ot%rowtype
  ) is
  begin
    update estado_cambio_ot t
       set row = p_rec
     where t.id_estado = p_rec.id_estado;
  end;

  procedure upd(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      update estado_cambio_ot
         set row = p_coll(i)
       where id_estado = p_coll(i).id_estado;
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_estado ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));
      end loop;
      raise;
  end;

  procedure del(
    p_id_estado in estado_cambio_ot.id_estado%type
  ) is
  begin
    delete
      from estado_cambio_ot t
     where t.id_estado = p_id_estado;
  end;

  function onerow(
    p_id_estado in estado_cambio_ot.id_estado%type
  ) return estado_cambio_ot%rowtype result_cache is
    rec estado_cambio_ot%rowtype;
  begin
    select *
      into rec
      from estado_cambio_ot t
     where t.id_estado = p_id_estado;

    return rec;
  exception
    when no_data_found then
      return null;
    when too_many_rows then
      raise;
  end;

  function allrows return aat is
    coll aat;
  begin
    select * bulk collect
      into coll
      from estado_cambio_ot;

    return coll;
  end;

  function exist(
    p_id_estado in estado_cambio_ot.id_estado%type
  ) return boolean is
    dummy pls_integer;
  begin
    select 1
      into dummy
      from estado_cambio_ot t
     where t.id_estado = p_id_estado;

    return true;
  exception
    when no_data_found then
      return false;
    when too_many_rows then
      return true;
  end;

  function estado_generado return estado_cambio_ot.id_estado%type is
  begin
    return gc_generado;
  end;

  function estado_enviado return estado_cambio_ot.id_estado%type is
  begin
    return gc_enviado;
  end;

  function estado_aprobado return estado_cambio_ot.id_estado%type is
  begin
    return gc_aprobado;
  end;

  function estado_rechazado return estado_cambio_ot.id_estado%type is
  begin
    return gc_rechazado;
  end;

  function estado_anulado return estado_cambio_ot.id_estado%type is
  begin
    return gc_anulado;
  end;
end api_estado_cambio_ot;

create or replace public synonym api_estado_cambio_ot for api_estado_cambio_ot;