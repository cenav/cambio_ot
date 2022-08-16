create or replace package api_solicita_cambio_ot as
  type aat is table of solicita_cambio_ot%rowtype index by binary_integer;
  type ntt is table of solicita_cambio_ot%rowtype;

  procedure ins(
    p_rec in solicita_cambio_ot%rowtype
  );

  procedure ins(
    p_coll aat
  );

  procedure upd(
    p_rec in solicita_cambio_ot%rowtype
  );

  procedure upd(
    p_coll aat
  );

  procedure del(
    p_id_solicitud in solicita_cambio_ot.id_solicitud%type
  );

  function onerow(
    p_id_solicitud in solicita_cambio_ot.id_solicitud%type
  ) return solicita_cambio_ot%rowtype result_cache;

  function allrows return aat;

  function exist(
    p_id_solicitud in solicita_cambio_ot.id_solicitud%type
  ) return boolean;

  function next_key return solicita_cambio_ot.id_solicitud%type;
end api_solicita_cambio_ot;
/

create or replace package body api_solicita_cambio_ot as
  forall_err exception;
  pragma exception_init (forall_err, -24381);

  procedure ins(
    p_rec in solicita_cambio_ot%rowtype
  ) is
  begin
    insert into solicita_cambio_ot
    values p_rec;
  end;

  procedure ins(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      insert into solicita_cambio_ot values p_coll(i);
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_solicitud ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));

      end loop;
      raise;
  end;

  procedure upd(
    p_rec in solicita_cambio_ot%rowtype
  ) is
  begin
    update solicita_cambio_ot t
       set row = p_rec
     where t.id_solicitud = p_rec.id_solicitud;
  end;

  procedure upd(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      update solicita_cambio_ot
         set row = p_coll(i)
       where id_solicitud = p_coll(i).id_solicitud;
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_solicitud ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));
      end loop;
      raise;
  end;

  procedure del(
    p_id_solicitud in solicita_cambio_ot.id_solicitud%type
  ) is
  begin
    delete
      from solicita_cambio_ot t
     where t.id_solicitud = p_id_solicitud;
  end;

  function onerow(
    p_id_solicitud in solicita_cambio_ot.id_solicitud%type
  ) return solicita_cambio_ot%rowtype result_cache is
    rec solicita_cambio_ot%rowtype;
  begin
    select *
      into rec
      from solicita_cambio_ot t
     where t.id_solicitud = p_id_solicitud;

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
      from solicita_cambio_ot;

    return coll;
  end;

  function exist(
    p_id_solicitud in solicita_cambio_ot.id_solicitud%type
  ) return boolean is
    dummy pls_integer;
  begin
    select 1
      into dummy
      from solicita_cambio_ot t
     where t.id_solicitud = p_id_solicitud;

    return true;
  exception
    when no_data_found then
      return false;
    when too_many_rows then
      return true;
  end;

  function next_key return solicita_cambio_ot.id_solicitud%type is
    l_key solicita_cambio_ot.id_solicitud%type;
  begin
    select nvl(max(t.id_solicitud), 0) + 1
      into l_key
      from solicita_cambio_ot t;

    return l_key;
  end;
end api_solicita_cambio_ot;

create or replace public synonym api_solicita_cambio_ot for api_solicita_cambio_ot;