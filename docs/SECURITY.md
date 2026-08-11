# Documento de Seguridad - SpicyCrust Game API

## 1. Principios de Seguridad

1. **Nunca confiar en el cliente:** Todo input proveniente de JavaScript o clientes HTTP debe ser saneado y validado sintáctica y semánticamente.
2. **Autenticación mediante Hash:** Las credenciales/API Keys de los juegos se validan contra un hash guardado (`password_verify` o equivalentes seguros).
3. **No exponer secretos:** No se incluyen llaves de API, credenciales de DB ni rutas internas en las respuestas JSON o en el control de versiones.
4. **Protección contra Payloads Abusivos:** Límite estricto de tamaño del body JSON (máx. 2KB de metadata) para evitar ataques de denegación de servicio por almacenamiento masivo.
