create or replace package api_motivo_cambio_ot as
  type aat is table of motivo_cambio_ot%rowtype index by binary_integer;
  type ntt is table of motivo_cambio_ot%rowtype;

  procedure ins(
    p_rec in motivo_cambio_ot%rowtype
  );

  procedure ins(
    p_coll aat
  );

  procedure upd(
    p_rec in motivo_cambio_ot%rowtype
  );

  procedure upd(
    p_coll aat
  );

  procedure del(
    p_id_motivo in motivo_cambio_ot.id_motivo%type
  );

  function onerow(
    p_id_motivo in motivo_cambio_ot.id_motivo%type
  ) return motivo_cambio_ot%rowtype result_cache;

  function allrows return aat;

  function exist(
    p_id_motivo in motivo_cambio_ot.id_motivo%type
  ) return boolean;
end api_motivo_cambio_ot;
/

create or replace package body api_motivo_cambio_ot as
  forall_err exception;
  pragma exception_init (forall_err, -24381);

  procedure ins(
    p_rec in motivo_cambio_ot%rowtype
  ) is
  begin
    insert into motivo_cambio_ot
    values p_rec;
  end;

  procedure ins(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      insert into motivo_cambio_ot values p_coll(i);
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_motivo ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));

      end loop;
      raise;
  end;

  procedure upd(
    p_rec in motivo_cambio_ot%rowtype
  ) is
  begin
    update motivo_cambio_ot t
       set row = p_rec
     where t.id_motivo = p_rec.id_motivo;
  end;

  procedure upd(
    p_coll in aat
  ) is
  begin
    forall i in 1 .. p_coll.count save exceptions
      update motivo_cambio_ot
         set row = p_coll(i)
       where id_motivo = p_coll(i).id_motivo;
  exception
    when forall_err then
      for i in 1 .. sql%bulk_exceptions.COUNT loop
        logger.log('PK: ' || p_coll(sql%bulk_exceptions(i).error_index).id_motivo ||
                   ' Err: ' || sqlerrm(sql%bulk_exceptions(i).error_code * -1));
      end loop;
      raise;
  end;

  procedure del(
    p_id_motivo in motivo_cambio_ot.id_motivo%type
  ) is
  begin
    delete
      from motivo_cambio_ot t
     where t.id_motivo = p_id_motivo;
  end;

  function onerow(
    p_id_motivo in motivo_cambio_ot.id_motivo%type
  ) return motivo_cambio_ot%rowtype result_cache is
    rec motivo_cambio_ot%rowtype;
  begin
    select *
      into rec
      from motivo_cambio_ot t
     where t.id_motivo = p_id_motivo;

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
      from motivo_cambio_ot;

    return coll;
  end;

  function exist(
    p_id_motivo in motivo_cambio_ot.id_motivo%type
  ) return boolean is
    dummy pls_integer;
  begin
    select 1
      into dummy
      from motivo_cambio_ot t
     where t.id_motivo = p_id_motivo;

    return true;
  exception
    when no_data_found then
      return false;
    when too_many_rows then
      return true;
  end;
end api_motivo_cambio_ot;

create or replace public synonym api_motivo_cambio_ot for api_motivo_cambio_ot;