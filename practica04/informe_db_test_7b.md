# Diccionario de datos: db_test_7b

## Fuente y alcance

El esquema se tomo de `backups.sql/db_test_7b.sql`. Los conteos se consultaron con `SELECT COUNT(*)` en las 25 tablas de la base activa `db_test_7b`, servidor `127.0.0.1:40065`, el 2026-11-19.

## Resumen

- Tablas fisicas: **25**
- Columnas: **197**
- Claves foraneas declaradas: **34**
- Vistas: **25**
- Triggers: **72**
- Filas actuales en las tablas: **131,425**

## Guia rapida

- **Columna:** nombre tecnico almacenado en la base.
- **Descripcion:** explica en palabras sencillas para que sirve el dato.
- **Tipo SQL:** formato del dato, por ejemplo `int` para numeros enteros, `varchar` para texto y `datetime` para fecha y hora.
- **Acepta nulos:** `Si` significa que puede estar vacio; `No` significa que se requiere un valor.
- **PK:** identifica de forma unica una fila.
- **FK:** conecta una fila con otra tabla.
- **UK:** evita que el valor se repita.
- **AUTO_INCREMENT:** la base genera el identificador automaticamente.
- **DEFAULT:** valor que se usa cuando no se envia uno.
- **BIT(1):** guarda un indicador, normalmente `1` para si y `0` para no.
- **Filas actuales:** resultado de `COUNT(*)` al momento de la consulta; puede cambiar si se agregan o eliminan datos.

## Diccionario por tabla

### `tb_carts` - Carritos | 5 filas actuales

Guarda el carrito activo o cerrado de una cuenta.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este carrito de compras. |
| `user_ID` | `int unsigned` | No | FK -> tb_users.ID, UK | Sin valor predeterminado | Cuenta propietaria del carrito. |
| `status` | `bit(1)` | Si | Sin clave | DEFAULT b'1' | Indica si el carrito esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_logs` - Auditoria | 77,198 filas actuales

Guarda eventos de operaciones realizadas en las tablas.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int` | No | PK | AUTO_INCREMENT | Identificador unico de este registro de auditoria. |
| `table_name` | `varchar(80)` | No | Sin clave | Sin valor predeterminado | Nombre de la tabla donde ocurrio la operacion. |
| `table_operation` | `enum('Create','Read','Update','Delete')` | Si | Sin clave | DEFAULT NULL | Tipo de accion registrada: crear, leer, actualizar o eliminar. |
| `db_user` | `varchar(80)` | No | Sin clave | Sin valor predeterminado | Cuenta de base de datos que realizo la operacion. |
| `operation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que ocurrio la operacion. |
| `operation_description` | `text` | No | Sin clave | Sin valor predeterminado | Texto con detalles del cambio o evento registrado. |
| `operation_status` | `bit(1)` | Si | Sin clave | DEFAULT b'1' | Indica si la operacion se marco como correcta (1) o fallida (0). |

### `tb_order_cancellations` - Pedidos y cumplimiento | 2 filas actuales

Registra la cancelacion de un pedido y su motivo.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este cancelacion de pedido. |
| `order_ID` | `int unsigned` | No | FK -> tb_orders.ID | Sin valor predeterminado | Pedido que fue cancelado. |
| `reason` | `text` | Si | Sin clave | Sin valor predeterminado | Motivo informado para cancelar el pedido. |
| `cancelled_at` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se registro la cancelacion. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_orders` - Pedidos y cumplimiento | 5 filas actuales

Guarda la informacion general de una compra y su cumplimiento.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este pedido. |
| `seller_ID` | `int unsigned` | No | FK -> tb_users.ID | Sin valor predeterminado | Usuario vendedor relacionado con el pedido. |
| `subtotal` | `decimal(12,2)` | No | Sin clave | DEFAULT '0.00' | Suma de los productos del pedido antes del envio. |
| `shipping_cost` | `decimal(12,2)` | No | Sin clave | DEFAULT '0.00' | Costo del envio del pedido. |
| `fulfillment_status` | `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned')` | No | Sin clave | DEFAULT 'Pending' | Etapa del pedido: Pending, Accepted, Preparing, Sent, Delivered, Canceled o Returned. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `tb_orders_chk_1`: `(`subtotal` >= 0)`
- `tb_orders_chk_2`: `(`shipping_cost` >= 0)`

### `tb_payment_methods` - Pagos | 5 filas actuales

Guarda metodos de pago asociados a una cuenta.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este metodo de pago. |
| `user_ID` | `int unsigned` | No | FK -> tb_users.ID | Sin valor predeterminado | Cuenta propietaria del metodo de pago. |
| `type_ID` | `int unsigned` | No | FK -> tbc_payment_methods_types.ID | Sin valor predeterminado | Tipo de metodo de pago elegido. |
| `alias` | `varchar(50)` | No | Sin clave | Sin valor predeterminado | Nombre corto que ayuda al usuario a reconocer el metodo. |
| `details` | `varchar(255)` | Si | Sin clave | DEFAULT NULL | Datos adicionales del metodo de pago. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_payment_transaction` - Pagos | 10 filas actuales

Registra el resultado y la respuesta de una transaccion.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este transaccion de pago. |
| `payment_ID` | `int unsigned` | No | FK -> tb_payments.ID | Sin valor predeterminado | Pago al que pertenece esta transaccion. |
| `transaction_status` | `enum('Pending','Approved','Declined','Error')` | No | Sin clave | DEFAULT 'Pending' | Resultado de la transaccion: Pending, Approved, Declined o Error. |
| `gateway_response` | `text` | Si | Sin clave | Sin valor predeterminado | Respuesta recibida del servicio que proceso el pago. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_payments` - Pagos | 10 filas actuales

Guarda el importe y la fecha de un pago de pedido.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este pago. |
| `order_ID` | `int unsigned` | No | FK -> tb_orders.ID | Sin valor predeterminado | Pedido que se esta pagando. |
| `payment_method_ID` | `int unsigned` | Si | FK -> tb_payment_methods.ID | DEFAULT NULL | Metodo usado para pagar; puede quedar vacio si no se asigno uno. |
| `amount` | `decimal(12,2)` | No | Sin clave | Sin valor predeterminado | Cantidad de dinero recibida o cobrada. |
| `payment_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se registro el pago. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `tb_payments_chk_1`: `(`amount` >= 0)`

### `tb_people` - Cuentas y personas | 10,003 filas actuales

Guarda los datos personales relacionados con una cuenta.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `person_ID` | `bigint unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de los datos personales. |
| `user_ID` | `int unsigned` | Si | FK -> tb_users.ID, UK | DEFAULT NULL | Cuenta asociada; puede quedar vacio si la persona aun no tiene cuenta. |
| `courtesy_title` | `varchar(20)` | Si | Sin clave | DEFAULT NULL | Tratamiento o titulo de cortesia de la persona. |
| `given_names` | `varchar(150)` | No | Sin clave | Sin valor predeterminado | Nombre o nombres de la persona. |
| `family_names` | `varchar(150)` | Si | Sin clave | DEFAULT NULL | Apellidos de la persona. |
| `birth_date` | `date` | Si | Sin clave | DEFAULT NULL | Fecha de nacimiento. |
| `gender` | `enum('Hombre','Mujer','Prefiero no decirlo')` | No | Sin clave | DEFAULT 'Prefiero no decirlo' | Genero seleccionado por la persona. |
| `country_code` | `char(2)` | Si | Sin clave | DEFAULT NULL | Codigo de dos letras del pais. |
| `phone` | `varchar(25)` | Si | Sin clave | DEFAULT NULL | Numero telefonico de contacto. |
| `status` | `bit(1)` | Si | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | Si | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_products` - Catalogo e inventario | 7,007 filas actuales

Guarda los datos del catalogo, precio y existencias.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este producto. |
| `SKU` | `varchar(50)` | No | UK | Sin valor predeterminado | Codigo unico usado para identificar el producto en el catalogo. |
| `name` | `varchar(250)` | No | Sin clave | Sin valor predeterminado | Nombre visible del producto. |
| `description` | `text` | Si | Sin clave | Sin valor predeterminado | Caracteristicas o informacion adicional del producto. |
| `current_price` | `decimal(10,2)` | No | Sin clave | DEFAULT '0.00' | Precio actual del producto. |
| `current_stock` | `int unsigned` | No | Sin clave | DEFAULT '0' | Unidades disponibles actualmente. |
| `status` | `bit(1)` | Si | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_refunds` - Pedidos y cumplimiento | 2 filas actuales

Registra devoluciones de dinero asociadas a un pedido.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este reembolso. |
| `order_ID` | `int unsigned` | No | FK -> tb_orders.ID | Sin valor predeterminado | Pedido al que corresponde el reembolso. |
| `payment_ID` | `int unsigned` | Si | FK -> tb_payments.ID | DEFAULT NULL | Pago que origino el reembolso; puede quedar vacio. |
| `amount` | `decimal(12,2)` | No | Sin clave | Sin valor predeterminado | Cantidad de dinero que se devuelve. |
| `reason` | `text` | Si | Sin clave | Sin valor predeterminado | Motivo del reembolso. |
| `refunded_at` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se registro el reembolso. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `tb_refunds_chk_1`: `(`amount` >= 0)`

### `tb_returns` - Pedidos y cumplimiento | 1 filas actuales

Registra la solicitud o proceso de devolucion de un pedido.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este devolucion. |
| `order_ID` | `int unsigned` | No | FK -> tb_orders.ID | Sin valor predeterminado | Pedido que contiene los productos devueltos. |
| `reason` | `text` | Si | Sin clave | Sin valor predeterminado | Motivo de la devolucion. |
| `returned_at` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se registro la devolucion. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_shipments` - Pedidos y cumplimiento | 5 filas actuales

Guarda el seguimiento y las fechas de envio de un pedido.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este envio. |
| `order_ID` | `int unsigned` | No | FK -> tb_orders.ID | Sin valor predeterminado | Pedido que se envio. |
| `tracking_number` | `varchar(100)` | Si | Sin clave | DEFAULT NULL | Codigo para consultar el seguimiento del envio. |
| `carrier` | `varchar(50)` | Si | Sin clave | DEFAULT NULL | Empresa que transporta el paquete. |
| `shipped_date` | `datetime` | Si | Sin clave | DEFAULT NULL | Fecha y hora en que el paquete salio. |
| `delivery_date` | `datetime` | Si | Sin clave | DEFAULT NULL | Fecha y hora en que se registro la entrega. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tb_user_addresses` - Direcciones | 5 filas actuales

Guarda direcciones de entrega asociadas a una cuenta.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `bigint unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este direccion de usuario. |
| `user_ID` | `int unsigned` | No | FK -> tb_users.ID | Sin valor predeterminado | Cuenta propietaria de la direccion. |
| `address_label` | `varchar(100)` | No | Sin clave | Sin valor predeterminado | Nombre corto para reconocer la direccion, por ejemplo Casa. |
| `recipient_name` | `varchar(150)` | Si | Sin clave | DEFAULT NULL | Nombre de la persona que recibira el pedido. |
| `recipient_phone` | `varchar(25)` | Si | Sin clave | DEFAULT NULL | Telefono de contacto de quien recibira el pedido. |
| `delivery_instructions` | `varchar(500)` | Si | Sin clave | DEFAULT NULL | Indicaciones para encontrar o entregar el paquete. |
| `latitude` | `decimal(10,7)` | Si | Sin clave | DEFAULT NULL | Coordenada norte-sur de la direccion. |
| `longitude` | `decimal(10,7)` | Si | Sin clave | DEFAULT NULL | Coordenada este-oeste de la direccion. |
| `is_default` | `tinyint(1)` | No | Sin clave | DEFAULT '0' | Indica si esta es la direccion principal (1) o no (0). |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `chk_coordinates`: `(((`latitude` is null) and (`longitude` is null)) or ((`latitude` is not null) and (`longitude` is not null)))`
- `chk_latitude`: `(`latitude` between -(90) and 90)`
- `chk_longitude`: `(`longitude` between -(180) and 180)`

### `tb_users` - Cuentas y personas | 10,010 filas actuales

Guarda los datos para identificar y administrar una cuenta.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este cuenta de usuario. |
| `email` | `varchar(100)` | No | UK | Sin valor predeterminado | Correo usado para identificar o contactar la cuenta. |
| `nick` | `varchar(50)` | No | UK | Sin valor predeterminado | Apodo publico o nombre corto de la cuenta. |
| `password` | `varchar(255)` | No | Sin clave | Sin valor predeterminado | Dato confidencial utilizado para autenticar la cuenta. |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |
| `last_login` | `datetime` | Si | Sin clave | DEFAULT NULL | Fecha y hora del ultimo inicio de sesion. |
| `status` | `bit(1)` | Si | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |

### `tbc_categories` - Catalogo e inventario | 100 filas actuales

Organiza productos en categorias y subcategorias.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este categoria. |
| `name` | `varchar(120)` | No | UK | Sin valor predeterminado | Nombre de la categoria. |
| `description` | `text` | Si | Sin clave | Sin valor predeterminado | Explicacion o detalle de la categoria. |
| `sup_id_category` | `int unsigned` | Si | Sin clave | DEFAULT NULL | Categoria superior de esta subcategoria; vacio si es una categoria principal. El DDL no declara una clave foranea para este campo. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tbc_payment_methods_types` - Pagos | 6 filas actuales

Catalogo de tipos disponibles para registrar metodos de pago.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este tipo de metodo de pago. |
| `code` | `varchar(30)` | No | UK | Sin valor predeterminado | Codigo corto que identifica el tipo de metodo de pago. |
| `description` | `text` | No | Sin clave | Sin valor predeterminado | Nombre o detalle del tipo de metodo de pago. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tbd_address_components` - Direcciones | 36 filas actuales

Guarda partes de una direccion y su jerarquia.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `bigint unsigned` | No | PK, UK | AUTO_INCREMENT | Identificador unico de este componente de direccion. |
| `address_ID` | `bigint unsigned` | No | FK -> tb_user_addresses.ID, FK -> tbd_address_components.address_ID, UK | Sin valor predeterminado | Direccion a la que pertenece este componente. |
| `value` | `varchar(255)` | No | Sin clave | Sin valor predeterminado | Texto guardado para esta parte de la direccion. |
| `component_type` | `varchar(50)` | No | Sin clave | Sin valor predeterminado | Tipo de parte, por ejemplo calle, ciudad o codigo postal. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `address_sup_ID` | `bigint unsigned` | Si | FK -> tbd_address_components.ID | DEFAULT NULL | Componente superior dentro de la misma direccion; vacio si no tiene componente superior. |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tbd_cancellation_items` - Pedidos y cumplimiento | 2 filas actuales

Indica que productos y cantidades se cancelaron.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este producto cancelado. |
| `cancellation_ID` | `int unsigned` | No | FK -> tb_order_cancellations.ID | Sin valor predeterminado | Registro de cancelacion al que pertenece el producto. |
| `product_ID` | `int unsigned` | No | FK -> tb_products.ID | Sin valor predeterminado | Producto que se cancelo. |
| `quantity` | `int unsigned` | No | Sin clave | Sin valor predeterminado | Unidades de este producto que se cancelaron. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `tbd_cancellation_items_chk_1`: `(`quantity` > 0)`

### `tbd_cart_items` - Carritos | 22 filas actuales

Relaciona productos y proveedores con un carrito y su cantidad.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `cart_ID` | `int unsigned` | No | PK, FK -> tb_carts.ID | Sin valor predeterminado | Carrito que contiene el producto. |
| `provider_ID` | `int unsigned` | No | PK, FK -> tbd_products_users_providers.user_ID | Sin valor predeterminado | Usuario que ofrece el producto dentro del carrito. |
| `product_ID` | `int unsigned` | No | PK, FK -> tbd_products_users_providers.product_ID | Sin valor predeterminado | Producto agregado al carrito. |
| `quantity` | `int unsigned` | No | Sin clave | DEFAULT '1' | Unidades del producto agregadas al carrito. |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `chk_cart_quantity`: `(`quantity` > 0)`

### `tbd_order_items` - Pedidos y cumplimiento | 22 filas actuales

Guarda cada producto incluido en un pedido y su precio al comprarlo.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este producto de pedido. |
| `seller_order_ID` | `int unsigned` | No | FK -> tb_orders.ID | Sin valor predeterminado | Pedido al que pertenece esta linea de producto. |
| `product_ID` | `int unsigned` | No | FK -> tbd_products_users_providers.product_ID | Sin valor predeterminado | Producto incluido en el pedido. |
| `provider_ID` | `int unsigned` | No | FK -> tbd_products_users_providers.user_ID | Sin valor predeterminado | Usuario que ofrecio el producto vendido. |
| `product_name` | `varchar(255)` | No | Sin clave | Sin valor predeterminado | Nombre del producto guardado como estaba al momento de la compra. |
| `quantity` | `int unsigned` | No | Sin clave | Sin valor predeterminado | Unidades compradas. |
| `unit_price` | `decimal(12,2)` | No | Sin clave | Sin valor predeterminado | Precio de una unidad al momento de la compra. |
| `subtotal` | `decimal(12,2)` | Si | Sin clave | GENERATED (`quantity` * `unit_price`) | Importe de esta linea; se calcula como cantidad por precio unitario. |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `tbd_order_items_chk_1`: `(`quantity` > 0)`
- `tbd_order_items_chk_2`: `(`unit_price` >= 0)`

### `tbd_products_categories` - Catalogo e inventario | 20,041 filas actuales

Relaciona productos con sus categorias.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `product_ID` | `int unsigned` | No | PK, FK -> tb_products.ID | Sin valor predeterminado | Producto relacionado con la categoria. |
| `category_ID` | `int unsigned` | No | PK, FK -> tbc_categories.ID | Sin valor predeterminado | Categoria asignada al producto. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tbd_products_users_providers` - Catalogo e inventario | 6,917 filas actuales

Relaciona un producto con el usuario que lo ofrece.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `user_ID` | `int unsigned` | No | PK, FK -> tb_users.ID | Sin valor predeterminado | Usuario que ofrece o provee el producto. |
| `product_ID` | `int unsigned` | No | PK, FK -> tb_products.ID | Sin valor predeterminado | Producto que ofrece el usuario. |
| `type_ownership` | `enum('Owner','Reseller','Distributor')` | Si | Sin clave | DEFAULT NULL | Relacion del usuario con el producto: Owner, Reseller o Distributor. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `avalaible_date` | `datetime` | No | Sin clave | Sin valor predeterminado | Fecha y hora desde la que el producto esta disponible para este usuario. |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tbd_return_items` - Pedidos y cumplimiento | 1 filas actuales

Indica que productos y cantidades se devolvieron.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este producto devuelto. |
| `return_ID` | `int unsigned` | No | FK -> tb_returns.ID | Sin valor predeterminado | Devolucion a la que pertenece el producto. |
| `product_ID` | `int unsigned` | No | FK -> tb_products.ID | Sin valor predeterminado | Producto incluido en la devolucion. |
| `quantity` | `int unsigned` | No | Sin clave | Sin valor predeterminado | Unidades de este producto que se devolvieron. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

**Reglas de validacion:**

- `tbd_return_items_chk_1`: `(`quantity` > 0)`

### `tbd_user_payment_methods` - Pagos | 5 filas actuales

Guarda las referencias de pago asociadas a una cuenta.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT | Identificador unico de este metodo de pago de usuario. |
| `user_ID` | `int unsigned` | No | FK -> tb_users.ID | Sin valor predeterminado | Cuenta propietaria de la referencia de pago. |
| `payment_method_type_ID` | `int unsigned` | No | FK -> tbc_payment_methods_types.ID | Sin valor predeterminado | Tipo de metodo de pago usado. |
| `provider` | `varchar(100)` | No | Sin clave | Sin valor predeterminado | Empresa o servicio que procesa el metodo de pago. |
| `provider_method_ref` | `varchar(255)` | Si | Sin clave | DEFAULT NULL | Referencia del metodo guardada por el proveedor. |
| `label` | `varchar(100)` | Si | Sin clave | DEFAULT NULL | Nombre corto para reconocer el metodo de pago. |
| `last_four` | `varchar(4)` | Si | Sin clave | DEFAULT NULL | Ultimos cuatro caracteres del numero asociado, si aplica. |
| `is_default` | `bit(1)` | No | Sin clave | DEFAULT b'0' | Indica si es el metodo principal (1) o no (0). |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

### `tbd_users_wishlist_products` - Catalogo e inventario | 5 filas actuales

Relaciona productos guardados por cada usuario.

| Columna | Tipo SQL | Acepta nulos | Clave | Valor predeterminado o regla | Descripcion |
|---|---|---:|---|---|---|
| `user_ID` | `int unsigned` | No | PK, FK -> tb_users.ID | Sin valor predeterminado | Usuario que guardo el producto. |
| `product_ID` | `int unsigned` | No | PK, FK -> tb_products.ID | Sin valor predeterminado | Producto guardado en la lista de deseos. |
| `status` | `bit(1)` | No | Sin clave | DEFAULT b'1' | Indica si el registro esta habilitado (1) o deshabilitado (0). |
| `creation_date` | `datetime` | No | Sin clave | DEFAULT CURRENT_TIMESTAMP | Fecha y hora en que se creo este registro. |
| `last_update` | `datetime` | Si | Sin clave | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP | Fecha y hora de la ultima modificacion del registro. Se actualiza al cambiar la fila. |

## Relaciones declaradas

- `tb_carts` (`user_ID`) -> `tb_users` (`ID`) [tb_carts_ibfk_1].
- `tb_order_cancellations` (`order_ID`) -> `tb_orders` (`ID`) [tb_order_cancellations_ibfk_1].
- `tb_orders` (`seller_ID`) -> `tb_users` (`ID`) [tb_orders_ibfk_1].
- `tb_payment_methods` (`user_ID`) -> `tb_users` (`ID`) [tb_payment_methods_ibfk_1].
- `tb_payment_methods` (`type_ID`) -> `tbc_payment_methods_types` (`ID`) [tb_payment_methods_ibfk_2].
- `tb_payment_transaction` (`payment_ID`) -> `tb_payments` (`ID`) [tb_payment_transaction_ibfk_1].
- `tb_payments` (`order_ID`) -> `tb_orders` (`ID`) [tb_payments_ibfk_1].
- `tb_payments` (`payment_method_ID`) -> `tb_payment_methods` (`ID`) [tb_payments_ibfk_2].
- `tb_people` (`user_ID`) -> `tb_users` (`ID`) [fk_people_users].
- `tb_refunds` (`order_ID`) -> `tb_orders` (`ID`) [tb_refunds_ibfk_1].
- `tb_refunds` (`payment_ID`) -> `tb_payments` (`ID`) [tb_refunds_ibfk_2].
- `tb_returns` (`order_ID`) -> `tb_orders` (`ID`) [tb_returns_ibfk_1].
- `tb_shipments` (`order_ID`) -> `tb_orders` (`ID`) [tb_shipments_ibfk_1].
- `tb_user_addresses` (`user_ID`) -> `tb_users` (`ID`) [fk_addresses_users].
- `tbd_address_components` (`address_ID`) -> `tb_user_addresses` (`ID`) [fk_component_address].
- `tbd_address_components` (`address_ID, address_sup_ID`) -> `tbd_address_components` (`address_ID, ID`) [fk_component_parent].
- `tbd_cancellation_items` (`cancellation_ID`) -> `tb_order_cancellations` (`ID`) [tbd_cancellation_items_ibfk_1].
- `tbd_cancellation_items` (`product_ID`) -> `tb_products` (`ID`) [tbd_cancellation_items_ibfk_2].
- `tbd_cart_items` (`cart_ID`) -> `tb_carts` (`ID`) [tbd_cart_items_ibfk_1].
- `tbd_cart_items` (`provider_ID`) -> `tbd_products_users_providers` (`user_ID`) [tbd_cart_items_ibfk_2].
- `tbd_cart_items` (`product_ID`) -> `tbd_products_users_providers` (`product_ID`) [tbd_cart_items_ibfk_3].
- `tbd_order_items` (`seller_order_ID`) -> `tb_orders` (`ID`) [tbd_order_items_ibfk_1].
- `tbd_order_items` (`product_ID`) -> `tbd_products_users_providers` (`product_ID`) [tbd_order_items_ibfk_2].
- `tbd_order_items` (`provider_ID`) -> `tbd_products_users_providers` (`user_ID`) [tbd_order_items_ibfk_3].
- `tbd_products_categories` (`category_ID`) -> `tbc_categories` (`ID`) [fk_category_1].
- `tbd_products_categories` (`product_ID`) -> `tb_products` (`ID`) [fk_product_1].
- `tbd_products_users_providers` (`product_ID`) -> `tb_products` (`ID`) [fk_products2].
- `tbd_products_users_providers` (`user_ID`) -> `tb_users` (`ID`) [fk_user1].
- `tbd_return_items` (`return_ID`) -> `tb_returns` (`ID`) [tbd_return_items_ibfk_1].
- `tbd_return_items` (`product_ID`) -> `tb_products` (`ID`) [tbd_return_items_ibfk_2].
- `tbd_user_payment_methods` (`user_ID`) -> `tb_users` (`ID`) [tbd_user_payment_methods_ibfk_1].
- `tbd_user_payment_methods` (`payment_method_type_ID`) -> `tbc_payment_methods_types` (`ID`) [tbd_user_payment_methods_ibfk_2].
- `tbd_users_wishlist_products` (`product_ID`) -> `tb_products` (`ID`) [fk_products3].
- `tbd_users_wishlist_products` (`user_ID`) -> `tb_users` (`ID`) [fk_users2].

La clave foranea de `tbd_address_components` que relaciona un componente con su componente superior es compuesta: `(address_ID, address_sup_ID)` referencia `(address_ID, ID)`. `address_sup_ID` puede quedar vacio.

`tbc_categories.sup_id_category` no tiene una clave foranea declarada en el DDL.
