create or replace package body solicitacambio_tmpl as
  function cambio_estado return clob is
  begin
    return q'[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <meta name="viewport" content="width=device-width"/>
      <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
      <title>PEVISA</title>
      <style type="text/css">
                    body {
                        margin: 0;
                        padding: 0;
                        min-width: 100%;
                        font-family: sans-serif;
                        background-color: #FFFFFF;
                    }

                    table {
                        margin: 0 auto;
                        padding: 0;
                        width: 100%;
                    }

                    div {
                        margin: 0;
                        padding: 0;
                    }

                    .header {
                        height: 150px;
                    }

                    .title {
                        height: 40px;
                        text-align: center;
                        font-size: 20px;
                        font-weight: bold;
                        color: #808080;
                    }

                    .content {
                        font-size: 14px;
                        line-height: 30px;
                        color: #888888
                    }

                    .footer {
                        height: 80px;
                        text-align: center;
                        font-size: 12px;
                        color: #D8DEE9;
                    }

                    .line {
                        content: "";
                        position: absolute;
                        left: 0;
                        bottom: 0;
                        display: inline-block;
                        width: 30px;
                        height: 3px;
                        background: #004899;
                    }

                    li {
                      margin: 0;
                    }

      </style>
    </head>
    <body bgcolor="#FFFFFF">
    <div>
      <table bgcolor="#FFFFFF" align="center" width="100%" border="0" cellspacing="0" cellpadding="0"
             style="max-width:500px; border:1px solid #D3D3D3;">
        <tr class="header">
          <td align="center" style="background-color: #eee;">
            <img src="https://drive.google.com/uc?id=1MBaDH_v72vVoaI-o9Ghbk18foq9wTQpt"
                 alt="logo pevisa">
          </td>
        </tr>
        <tr class="title">
          <td style="padding: 1px 0 0 0;">
            Solicitud de Cambio de OT <br/>
            ${estado}
          </td>
        </tr>
        <tr>
          <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="width: 45%"></td>
              <td style="background: #004899; height: 3px; width: 10%;"></td>
              <td style="width: 45%"></td>
            </tr>
          </table>
        </tr>
        <tr class="content">
          <td align="center" style="padding: 10px 15px 25px 15px;">
            <p>
              Solicitud con numero de OT <strong>${ot_nro}</strong> formula <strong>${formula}</strong>
              enviado a estado <strong>${estado}</strong>
            </p>

            <p style="font-size: 11px; line-height: 15px;">
              Nro. Registro: ${id} <br/>
              Usuario: ${usuario}
            </p>
          </td>
        </tr>
        <tr class="footer">
          <td align="center" style="background-color: #004899;">
            Av Separadora Industrial #2187 Urb. Vulcano ATE, LIMA PERÚ<br>
            (511) 612-7900 | Fax: (511) 612-7910
          </td>
        </tr>
      </table>
    </div>
    </body>
    </html>]';
  end;
end solicitacambio_tmpl;