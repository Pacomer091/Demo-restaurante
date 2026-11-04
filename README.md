# Demo Restaurante (Software del Restaurante - Fogonazo)

Software independiente y motor de pedidos para restaurantes.

## Módulos Incluidos
- **Carta Digital y Pedidos (`index.html` / `demo.html`)**:
  - Catálogo interactivo de platos con variantes, extras y modificadores.
  - Carrito persistente y cálculo exacto de importes en céntimos enteros.
  - Confirmación y generación de enlace de seguimiento en vivo con token criptográfico.
- **Panel de Cocina / KDS (`control.html`)**:
  - Recepción de comandas en tiempo real (SSE / Supabase Realtime).
  - Alertas sonoras automáticas al entrar nuevos pedidos.
  - Cambio de estados (`recibido` ➔ `cocina` ➔ `listo` ➔ `entregado`) y pausa de platos sin stock.
- **Seguimiento para Clientes (`seguimiento.html`)**:
  - Pantalla en vivo para el cliente que muestra el estado de su pedido y chat directo con el restaurante.
- **Acceso / Login (`login.html`)**:
  - Inicio de sesión seguro con Supabase Auth para dueños del local y administradores.
- **Servidor Backend (`server.js`)**:
  - Servidor Node.js con API REST, eventos Server-Sent Events (SSE) y resolución multi-inquilino.
  - Base de datos local SQLite (`node:sqlite`) con modo WAL y adaptador preparado para Supabase/PostgreSQL.

## Puesta en Marcha

### 1. Iniciar el servidor local
```bash
node server.js
```
O con variables de entorno cargadas:
```bash
node --env-file=.env server.js
```

### 2. URLs de acceso
- **Carta / Menú del Restaurante**: `http://localhost:8080/`
- **Panel de Cocina (KDS)**: `http://localhost:8080/control`
- **Acceso de Dueños**: `http://localhost:8080/login`

### 3. Base de Datos
- Reiniciar o sembrar datos de prueba:
  ```bash
  node db/seed.js --reset
  ```

