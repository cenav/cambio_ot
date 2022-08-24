create or replace package body solicitacambio as
  subtype string_t is varchar2(32767);
  g_ot pr_ot%rowtype;

  procedure update_master(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  ) is
    l_sol solicita_cambio_ot%rowtype;
  begin
    l_sol := api_solicita_cambio_ot.onerow(p_solicitud_id);
    g_ot := api_pr_ot.onerow(l_sol.ot_nro, l_sol.ot_ser, l_sol.ot_tpo);

    if l_sol.cant_programada_new is not null then
      g_ot.cant_prog := l_sol.cant_programada_new;
    end if;

    if l_sol.cant_habilitado_new is not null then
      g_ot.cant_resul := l_sol.cant_habilitado_new;
    end if;

    if l_sol.cant_ingresado_new is not null then
      g_ot.cant_ingresado := l_sol.cant_ingresado_new;
    end if;

    api_pr_ot.upd(g_ot);
  end;

  procedure update_detail(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  ) is
    l_det pr_ot_det%rowtype;
  begin
    for r in (
      select m.id_solicitud, m.ot_tpo, m.ot_ser, m.ot_nro, d.cod_art_new, d.cod_art_old
           , d.rendimiento_new, d.anula
        from solicita_cambio_ot m
             join solicita_cambio_ot_det d on m.id_solicitud = d.id_solicitud
       where m.id_solicitud = p_solicitud_id
         and d.nuevo = 0
      )
    loop
      l_det := api_pr_ot_det.onerow(r.ot_nro, r.ot_ser, r.ot_tpo, r.cod_art_old);
      if r.rendimiento_new is not null then
        l_det.rendimiento := r.rendimiento_new;
        l_det.cant_formula := l_det.rendimiento * g_ot.cant_prog;
        api_pr_ot_det.upd(l_det);
      end if;
      if r.anula = 1 then
        api_pr_ot_det.del(r.ot_nro, r.ot_ser, r.ot_tpo, r.cod_art_old);
      end if;
      if r.cod_art_new is not null then
        l_det.art_cod_art := r.cod_art_new;

        update pr_ot_det
           set art_cod_art = r.cod_art_new
         where ot_nuot_tipoot_codigo = r.ot_tpo
           and ot_nuot_serie = r.ot_ser
           and ot_numero = r.ot_nro
           and art_cod_art = r.cod_art_old;
      end if;
    end loop;
  end;

  procedure insert_detail(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  ) is
    l_art articul%rowtype;
    l_ot  pr_ot%rowtype;
  begin
    for r in (
      select m.id_solicitud, m.ot_tpo, m.ot_ser, m.ot_nro, m.cant_programada_old
           , d.cod_art_old, d.rendimiento_old
        from solicita_cambio_ot m
             join solicita_cambio_ot_det d on m.id_solicitud = d.id_solicitud
       where m.id_solicitud = p_solicitud_id
         and d.nuevo = 1
      )
    loop
      l_art := api_articul.onerow(r.cod_art_old);
      l_ot := api_pr_ot.onerow(r.ot_nro, r.ot_ser, r.ot_tpo);

      insert into pr_ot_det
      values ( r.cant_programada_old * r.rendimiento_old, 0, 0, 0, '03'
             , r.ot_nro, r.ot_ser, r.ot_tpo, r.cod_art_old
             , 0, r.rendimiento_old, l_art.cod_lin, 0, 'N', 1, null
             , l_ot.fecha, 0, 0);
    end loop;
  end;

  procedure change_status(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  ) is
  begin
    update solicita_cambio_ot
       set id_estado = api_estado_cambio_ot.estado_aprobado()
     where id_solicitud = p_solicitud_id;
  end;

  procedure aprueba(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  ) is
  begin
    update_master(p_solicitud_id);
    update_detail(p_solicitud_id);
    insert_detail(p_solicitud_id);
    change_status(p_solicitud_id);
  end;

  procedure rechaza(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  ) is
  begin
    update solicita_cambio_ot
       set id_estado = api_estado_cambio_ot.estado_rechazado()
     where id_solicitud = p_solicitud_id;
  end;

  function tiene_solicitud_activa(
    p_tpo solicita_cambio_ot.ot_tpo%type
  , p_ser solicita_cambio_ot.ot_ser%type
  , p_nro solicita_cambio_ot.ot_nro%type
  ) return boolean is
    l_activos pls_integer;
  begin
    select count(*)
      into l_activos
      from solicita_cambio_ot
     where ot_tpo = p_tpo
       and ot_ser = p_ser
       and ot_nro = p_nro
       and id_estado < api_estado_cambio_ot.estado_aprobado();

    return l_activos > 0;
  end;

  procedure envia_correo(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  ) is
    l_html      clob;
    l_vars      teplsql.t_assoc_array;
    l_correos   string_t;
    l_solicitud solicita_cambio_ot%rowtype;
  begin
    l_html := solicitacambio_tmpl.cambio_estado();

    l_solicitud := api_solicita_cambio_ot.onerow(p_solicitud_id);
    l_vars('id') := l_solicitud.id_solicitud;
    l_vars('ot_nro') := l_solicitud.ot_nro;
    l_vars('formula') :=
        api_pr_ot.onerow(l_solicitud.ot_nro, l_solicitud.ot_ser, l_solicitud.ot_tpo).formu_art_cod_art;
    l_vars('estado') := api_estado_cambio_ot.onerow(l_solicitud.id_estado).dsc_estado;
    l_vars('usuario') := user;

    l_html := teplsql.render(l_vars, l_html);

--     l_correos := c_sistemas || '; asonteuoasu@pevisa.com.pe';
    l_correos := 'cnavarro@pevisa.com.pe';

    mail.send_html(
        p_to => l_correos,
--         p_bcc => c_sistemas,
        p_from => 'avisos_produccion@pevisa.com.pe',
        p_subject => 'SOLICITA CAMBIO OT',
        p_html_msg => l_html
      );
  end ;
end solicitacambio;
