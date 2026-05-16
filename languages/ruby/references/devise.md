# Devise Reference

## Leer Primero

- Devise: https://github.com/heartcombo/devise
- Devise docs: https://www.rubydoc.info/github/heartcombo/devise
- Warden: https://github.com/wardencommunity/warden

## Conceptos Clave

- Devise resuelve autenticacion, no autorizacion completa.
- Warden opera en la capa Rack.
- Modulos como `confirmable` y `lockable` requieren migraciones correctas.
- Customizar controllers requiere entender scopes y rutas.

## Riesgos Comunes

- Confundir login con permisos.
- Agregar campos al registro sin sanitizarlos.
- No testear acceso anonimo.
- No revisar flujos de recovery y confirmation.
