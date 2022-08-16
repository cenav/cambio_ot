create or replace package solicitacambio as
  procedure aprueba(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  );

  procedure rechaza(
    p_solicitud_id solicita_cambio_ot.id_solicitud%type
  );
end solicitacambio;