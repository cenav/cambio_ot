select * from pr_ot;

select * from pr_ot_det;

select * from motivo_cambio_ot;

select * from estado_cambio_ot;

select *
  from solicita_cambio_ot
 order by id_solicitud desc;


select *
  from solicita_cambio_ot_det
 where id_solicitud = 73;

select * from solicita_emision;

select * from vw_solicita_cambio_ot;

select dsc_motivo, id_motivo
  from motivo_cambio_ot
 order by id_motivo;

select o.nuot_tipoot_codigo, o.numero, o.formu_art_cod_art, to_char(o.fecha, 'dd/mm/yyyy') as fecha
     , o.cant_prog, e.descripcion as estado
  from pr_ot o
       join pr_estadopr e on o.estado = e.estado
 where o.estado in ('2', '3', '4')
   and o.nuot_tipoot_codigo = 'PR'
 order by o.fecha desc;

select *
  from pr_ot_det
 where ot_nuot_tipoot_codigo = 'PR'
   and ot_numero = 469625;

select * from induccion;

-- ordenes 4

select cod_art, descripcion, cod_lin
  from articul
 where cod_lin != 'ZZ';

select *
  from caja_chica_d
 where serie = 7
   and numero = 22042;

select dsc_estado, id_estado from estado_cambio_ot;

select *
  from solicita_cambio_ot
 where ot_nro = 471957
   and id_estado < api_estado_cambio_ot.estado_aprobado();

call solicitacambio.envia_correo(216);

select *
  from pevisa.usuario_modulo
 where modulo = 'CAMBIO_OT';

select *
  from usuarios
 where usuario = 'PEVISA';

select * from pevisa.solicita_cambio_ot;