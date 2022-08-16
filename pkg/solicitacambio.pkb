create or replace package body solicitacambio as
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
end solicitacambio;
