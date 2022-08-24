create or replace package solicitacambio as
  procedure aprueba(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  );

  procedure rechaza(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  );

  function tiene_solicitud_activa(
    p_tpo solicita_cambio_ot.ot_tpo%type
  , p_ser solicita_cambio_ot.ot_ser%type
  , p_nro solicita_cambio_ot.ot_nro%type
  ) return boolean;
end solicitacambio;