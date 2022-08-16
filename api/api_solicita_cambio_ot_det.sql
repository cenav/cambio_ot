create or replace package pevisa.api_solicita_cambio_ot_det as
  type aat is table of solicita_cambio_ot_det%rowtype index by binary_integer;
  type ntt is table of solicita_cambio_ot_det%rowtype;

  procedure ins(
    p_rec in solicita_cambio_ot_det%rowtype
  );

  procedure ins(
    p_coll aat
  );

  procedure upd(
    p_rec in solicita_cambio_ot_det%rowtype
  );

  procedure upd(
    p_coll aat
  );

  procedure del(
    p_id_solicitud in solicita_cambio_ot_det.id_solicitud%type
  , p_id_item in      solicita_cambio_ot_det.id_item%type
  );

  function onerow(
    p_id_solicitud in solicita_cambio_ot_det.id_solicitud%type
  , p_id_item in      solicita_cambio_ot_det.id_item%type
  ) return solicita_cambio_ot_det%rowtype result_cache;

  function allrows return aat;

  function exist(
    p_id_solicitud in solicita_cambio_ot_det.id_solicitud%type
  , p_id_item in      solicita_cambio_ot_det.id_item%type
  ) return boolean;
end api_solicita_cambio_ot_det;
/

create or replace package body pevisa.api_solicita_cambio_ot_det as
  forall_err exception;
  pragma exception_init (forall_err, -24381);

  procedure ins(
    p_rec in solicita_cambio_ot_det%rowtype
  ) is
  begin
    insert into solicita_cambio_ot_det
    values p_rec;
  end;

  procedure ins(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      insert into solicita_cambio_ot_det values p_coll(i);
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_solicitud ||
                   ' ^ ' || p_coll(sql%bulk_exceptions(i).error_index).id_item ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));

      end loop;
      raise;
  end;

  procedure upd(
    p_rec in solicita_cambio_ot_det%rowtype
  ) is
  begin
    update solicita_cambio_ot_det t
       set row = p_rec
     where t.id_solicitud = p_rec.id_solicitud and t.id_item = p_rec.id_item;
  end;

  procedure upd(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      update solicita_cambio_ot_det
         set row = p_coll(i)
       where id_solicitud = p_coll(i).id_solicitud and id_item = p_coll(i).id_item;
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_solicitud ||
                   ' ^ ' || p_coll(sql%bulk_exceptions(i).error_index).id_item ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));
      end loop;
      raise;
  end;

  procedure del(
    p_id_solicitud in solicita_cambio_ot_det.id_solicitud%type
  , p_id_item in      solicita_cambio_ot_det.id_item%type
  ) is
  begin
    delete
      from solicita_cambio_ot_det t
     where t.id_solicitud = p_id_solicitud and t.id_item = p_id_item;
  end;

  function onerow(
    p_id_solicitud in solicita_cambio_ot_det.id_solicitud%type
  , p_id_item in      solicita_cambio_ot_det.id_item%type
  ) return solicita_cambio_ot_det%rowtype result_cache is
    rec solicita_cambio_ot_det%rowtype;
  begin
    select *
      into rec
      from solicita_cambio_ot_det t
     where t.id_solicitud = p_id_solicitud and t.id_item = p_id_item;

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
      from solicita_cambio_ot_det;

    return coll;
  end;

  function exist(
    p_id_solicitud in solicita_cambio_ot_det.id_solicitud%type
  , p_id_item in      solicita_cambio_ot_det.id_item%type
  ) return boolean is
    dummy pls_integer;
  begin
    select 1
      into dummy
      from solicita_cambio_ot_det t
     where t.id_solicitud = p_id_solicitud and t.id_item = p_id_item;

    return true;
  exception
    when no_data_found then
      return false;
    when too_many_rows then
      return true;
  end;
end api_solicita_cambio_ot_det;
