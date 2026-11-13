# Diccionario de datos y modelo EER: db_test_7b

## Fuente y alcance

El esquema y los conteos se extrajeron de `backups.sql/db_test_7b.sql` (mysqldump MySQL 8.0.42; servidor indicado 8.0.45). Los totales indican las filas presentes en las sentencias INSERT del archivo, no un COUNT(*) de la base activa. Los totales generales de filas corresponden al respaldo local. La población de `tb_products`, `tbc_categories` y `tbd_products_categories` también se contrastó con la base activa después de la recategorización: 7,007 productos, 100 categorías y 20,041 relaciones.

## Resumen

- Tablas físicas: **25**
- Columnas: **197**
- Claves foráneas declaradas: **34**
- Vistas: **25**
- Triggers: **72**
- Filas incluidas en los INSERT del respaldo: **88,129**

## Diccionario por tabla

### `tb_carts` — Carritos | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `user_ID` | `int unsigned` | No | FK tb_users.ID; UK | — |
| `status` | `bit(1)` | Sí | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_logs` — Auditoría | 40,970 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int` | No | PK | AUTO_INCREMENT |
| `table_name` | `varchar(80)` | No | — | — |
| `table_operation` | `enum('Create','Read','Update','Delete')` | Sí | — | DEFAULT NULL |
| `db_user` | `varchar(80)` | No | — | — |
| `operation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `operation_description` | `text` | No | — | — |
| `operation_status` | `bit(1)` | Sí | — | DEFAULT b'1' |

### `tb_order_cancellations` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `order_ID` | `int unsigned` | No | FK tb_orders.ID | — |
| `reason` | `text` | Sí | — | — |
| `cancelled_at` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_orders` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `seller_ID` | `int unsigned` | No | FK tb_users.ID | — |
| `subtotal` | `decimal(12,2)` | No | — | DEFAULT '0.00' |
| `shipping_cost` | `decimal(12,2)` | No | — | DEFAULT '0.00' |
| `fulfillment_status` | `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned')` | No | — | DEFAULT 'Pending' |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `tb_orders_chk_1`: `(`subtotal` >= 0)`

CHECK `tb_orders_chk_2`: `(`shipping_cost` >= 0)`

### `tb_payment_methods` — Pagos | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `user_ID` | `int unsigned` | No | FK tb_users.ID | — |
| `type_ID` | `int unsigned` | No | FK tbc_payment_methods_types.ID | — |
| `alias` | `varchar(50)` | No | — | — |
| `details` | `varchar(255)` | Sí | — | DEFAULT NULL |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_payment_transaction` — Pagos | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `payment_ID` | `int unsigned` | No | FK tb_payments.ID | — |
| `transaction_status` | `enum('Pending','Approved','Declined','Error')` | No | — | DEFAULT 'Pending' |
| `gateway_response` | `text` | Sí | — | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_payments` — Pagos | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `order_ID` | `int unsigned` | No | FK tb_orders.ID | — |
| `payment_method_ID` | `int unsigned` | Sí | FK tb_payment_methods.ID | DEFAULT NULL |
| `amount` | `decimal(12,2)` | No | — | — |
| `payment_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `tb_payments_chk_1`: `(`amount` >= 0)`

### `tb_people` — Cuentas y personas | 10,002 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `person_ID` | `bigint unsigned` | No | PK | AUTO_INCREMENT |
| `user_ID` | `int unsigned` | Sí | FK tb_users.ID; UK | DEFAULT NULL |
| `courtesy_title` | `varchar(20)` | Sí | — | DEFAULT NULL |
| `given_names` | `varchar(150)` | No | — | — |
| `family_names` | `varchar(150)` | Sí | — | DEFAULT NULL |
| `birth_date` | `date` | Sí | — | DEFAULT NULL |
| `gender` | `enum('Hombre','Mujer','Prefiero no decirlo')` | No | — | DEFAULT 'Prefiero no decirlo' |
| `country_code` | `char(2)` | Sí | — | DEFAULT NULL |
| `phone` | `varchar(25)` | Sí | — | DEFAULT NULL |
| `status` | `bit(1)` | Sí | — | DEFAULT b'1' |
| `creation_date` | `datetime` | Sí | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_products` — Catálogo e inventario | 7,007 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `SKU` | `varchar(50)` | No | UK | — |
| `name` | `varchar(250)` | No | — | — |
| `description` | `text` | Sí | — | — |
| `current_price` | `decimal(10,2)` | No | — | DEFAULT '0.00' |
| `current_stock` | `int unsigned` | No | — | DEFAULT '0' |
| `status` | `bit(1)` | Sí | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_refunds` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `order_ID` | `int unsigned` | No | FK tb_orders.ID | — |
| `payment_ID` | `int unsigned` | Sí | FK tb_payments.ID | DEFAULT NULL |
| `amount` | `decimal(12,2)` | No | — | — |
| `reason` | `text` | Sí | — | — |
| `refunded_at` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `tb_refunds_chk_1`: `(`amount` >= 0)`

### `tb_returns` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `order_ID` | `int unsigned` | No | FK tb_orders.ID | — |
| `reason` | `text` | Sí | — | — |
| `returned_at` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_shipments` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `order_ID` | `int unsigned` | No | FK tb_orders.ID | — |
| `tracking_number` | `varchar(100)` | Sí | — | DEFAULT NULL |
| `carrier` | `varchar(50)` | Sí | — | DEFAULT NULL |
| `shipped_date` | `datetime` | Sí | — | DEFAULT NULL |
| `delivery_date` | `datetime` | Sí | — | DEFAULT NULL |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tb_user_addresses` — Direcciones | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `bigint unsigned` | No | PK | AUTO_INCREMENT |
| `user_ID` | `int unsigned` | No | FK tb_users.ID | — |
| `address_label` | `varchar(100)` | No | — | — |
| `recipient_name` | `varchar(150)` | Sí | — | DEFAULT NULL |
| `recipient_phone` | `varchar(25)` | Sí | — | DEFAULT NULL |
| `delivery_instructions` | `varchar(500)` | Sí | — | DEFAULT NULL |
| `latitude` | `decimal(10,7)` | Sí | — | DEFAULT NULL |
| `longitude` | `decimal(10,7)` | Sí | — | DEFAULT NULL |
| `is_default` | `tinyint(1)` | No | — | DEFAULT '0' |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `chk_coordinates`: `(((`latitude` is null) and (`longitude` is null)) or ((`latitude` is not null) and (`longitude` is not null)))`

CHECK `chk_latitude`: `(`latitude` between -(90) and 90)`

CHECK `chk_longitude`: `(`longitude` between -(180) and 180)`

### `tb_users` — Cuentas y personas | 10,009 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `email` | `varchar(100)` | No | UK | — |
| `nick` | `varchar(50)` | No | UK | — |
| `password` | `varchar(255)` | No | — | — |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |
| `last_login` | `datetime` | Sí | — | DEFAULT NULL |
| `status` | `bit(1)` | Sí | — | DEFAULT b'1' |

### `tbc_categories` — Catálogo e inventario | 100 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `name` | `varchar(120)` | No | UK | — |
| `description` | `text` | Sí | — | — |
| `sup_id_category` | `int unsigned` | Sí | — | DEFAULT NULL |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |


**Propósito y reglas de uso**

- Una fila representa una categoría del catálogo. `ID` es su identificador y `name` es único en toda la tabla.
- `description` describe qué productos se agrupan en la categoría.
- `sup_id_category` guarda el `ID` de la categoría padre; `NULL` identifica una categoría raíz. Esta columna organiza la jerarquía pero no tiene FK declarada en el DDL.
- `status` es un bit de habilitación. `creation_date` registra la creación y `last_update` se actualiza al modificar la fila.
- La base activa contiene 100 categorías. Cada una está asociada al menos con un producto mediante `tbd_products_categories`.

### `tbc_payment_methods_types` — Pagos | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `code` | `varchar(30)` | No | UK | — |
| `description` | `text` | No | — | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tbd_address_components` — Direcciones | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `bigint unsigned` | No | PK; UK | AUTO_INCREMENT |
| `address_ID` | `bigint unsigned` | No | FK tb_user_addresses.ID; FK tbd_address_components.address_ID; UK | — |
| `value` | `varchar(255)` | No | — | — |
| `component_type` | `varchar(50)` | No | — | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `address_sup_ID` | `bigint unsigned` | Sí | FK tbd_address_components.ID | DEFAULT NULL |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tbd_cancellation_items` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `cancellation_ID` | `int unsigned` | No | FK tb_order_cancellations.ID | — |
| `product_ID` | `int unsigned` | No | FK tb_products.ID | — |
| `quantity` | `int unsigned` | No | — | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `tbd_cancellation_items_chk_1`: `(`quantity` > 0)`

### `tbd_cart_items` — Carritos | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `cart_ID` | `int unsigned` | No | PK; FK tb_carts.ID | — |
| `provider_ID` | `int unsigned` | No | PK; FK tbd_products_users_providers.user_ID | — |
| `product_ID` | `int unsigned` | No | PK; FK tbd_products_users_providers.product_ID | — |
| `quantity` | `int unsigned` | No | — | DEFAULT '1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `chk_cart_quantity`: `(`quantity` > 0)`

### `tbd_order_items` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `seller_order_ID` | `int unsigned` | No | FK tb_orders.ID | — |
| `product_ID` | `int unsigned` | No | FK tbd_products_users_providers.product_ID | — |
| `provider_ID` | `int unsigned` | No | FK tbd_products_users_providers.user_ID | — |
| `product_name` | `varchar(255)` | No | — | — |
| `quantity` | `int unsigned` | No | — | — |
| `unit_price` | `decimal(12,2)` | No | — | — |
| `subtotal` | `decimal(12,2)` | Sí | — | GENERATED (`quantity` * `unit_price`) |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `tbd_order_items_chk_1`: `(`quantity` > 0)`

CHECK `tbd_order_items_chk_2`: `(`unit_price` >= 0)`

### `tbd_products_categories` — Catálogo e inventario | 20,041 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `product_ID` | `int unsigned` | No | PK; FK tb_products.ID | — |
| `category_ID` | `int unsigned` | No | PK; FK tbc_categories.ID | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |


**Propósito y reglas de uso**

- Es la tabla puente de la relación muchos-a-muchos entre `tb_products` y `tbc_categories`.
- La clave primaria compuesta (`product_ID`, `category_ID`) permite que un producto aparezca en varias categorías y evita repetir la misma pareja.
- Ambas columnas son obligatorias y tienen FK: `product_ID` apunta a `tb_products.ID`; `category_ID` apunta a `tbc_categories.ID`.
- `status` habilita o deshabilita la relación. Las fechas registran su creación y última modificación.
- La base activa verificada tiene 20,041 relaciones para 7,007 productos distintos y 100 categorías. Las relaciones incluyen la categoría específica y sus categorías padre.

### `tbd_products_users_providers` — Catálogo e inventario | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `user_ID` | `int unsigned` | No | PK; FK tb_users.ID | — |
| `product_ID` | `int unsigned` | No | PK; FK tb_products.ID | — |
| `type_ownership` | `enum('Owner','Reseller','Distributor')` | Sí | — | DEFAULT NULL |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `avalaible_date` | `datetime` | No | — | — |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tbd_return_items` — Pedidos y cumplimiento | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `return_ID` | `int unsigned` | No | FK tb_returns.ID | — |
| `product_ID` | `int unsigned` | No | FK tb_products.ID | — |
| `quantity` | `int unsigned` | No | — | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

CHECK `tbd_return_items_chk_1`: `(`quantity` > 0)`

### `tbd_user_payment_methods` — Pagos | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `ID` | `int unsigned` | No | PK | AUTO_INCREMENT |
| `user_ID` | `int unsigned` | No | FK tb_users.ID | — |
| `payment_method_type_ID` | `int unsigned` | No | FK tbc_payment_methods_types.ID | — |
| `provider` | `varchar(100)` | No | — | — |
| `provider_method_ref` | `varchar(255)` | Sí | — | DEFAULT NULL |
| `label` | `varchar(100)` | Sí | — | DEFAULT NULL |
| `last_four` | `varchar(4)` | Sí | — | DEFAULT NULL |
| `is_default` | `bit(1)` | No | — | DEFAULT b'0' |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

### `tbd_users_wishlist_products` — Catálogo e inventario | 0 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `user_ID` | `int unsigned` | No | PK; FK tb_users.ID | — |
| `product_ID` | `int unsigned` | No | PK; FK tb_products.ID | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

<!-- CATEGORY-POPULATION-START -->
## Población y catálogo de categorías verificados

La base activa fue verificada después de aplicar la recategorización: contiene **100 categorías** (12 raíces, 9 agrupaciones intermedias y 79 categorías específicas), **20,041 relaciones producto-categoría** y **7,007 productos distintos clasificados**. Las 100 categorías tienen productos asociados y no quedan productos sin categoría. La tabla puente contiene relaciones, por eso su total es mayor al número de productos.

Cada producto se asocia a su categoría específica y también a los niveles padre correspondientes. El conteo de la tabla siguiente es por categoría e incluye esas relaciones heredadas; un mismo producto aparece en la categoría específica, su grupo intermedio y su categoría raíz cuando aplica.

`sup_id_category` indica el padre lógico. El DDL no declara una clave foránea para esa columna; por ello el diagrama distingue esta jerarquía lógica de las relaciones físicas declaradas por claves foráneas.

| ID | Categoría | ID padre | Productos relacionados | Ejemplo de producto |
|---:|---|---:|---:|---|
| 1 | Electrónica y Computación | — | 5402 | Teclado |
| 2 | Ropa | — | 251 | Leggings Deportivos Skechers Rosa Talla M |
| 3 | Calzado | — | 153 | Sandalias Infantiles Crocs Café Talla 15 MX |
| 4 | Accesorios Personales | — | 161 | Cartera de Piel Fossil Negro |
| 5 | Hogar y Cocina | — | 236 | Silla de Oficina Ergonómica Ikea Rosa |
| 6 | Belleza y Cuidado Personal | — | 194 | Labial Líquido Mate Revlon Tono Rojo Clásico |
| 7 | Deportes y Fitness | — | 135 | Cinturón de Hidratación Salomon Azul Cielo |
| 8 | Libros y Papelería | — | 133 | Manual de Bases de Datos SQL Pearson |
| 9 | Automotriz | — | 112 | Cubreasientos Universal Michelin Verde Olivo |
| 10 | Mascotas | — | 77 | Rascador para Gato Royal Canin Poste |
| 11 | Juguetes y Videojuegos | — | 123 | ROBOT |
| 12 | Aire Libre y Camping | — | 30 | Bolsa de Dormir Naturehike Beige |
| 13 | Computación y Almacenamiento | 1 | 1349 | Monitor |
| 14 | Periféricos y Conectividad | 1 | 1717 | Teclado |
| 15 | Audio y Video | 1 | 1124 | Bocina Bluetooth Xiaomi Air |
| 16 | Prendas de Vestir | 2 | 220 | Jeans Slim Fit Levi's Mezclilla Blanco Talla 30 |
| 17 | Telefonía y Accesorios Móviles | 1 | 868 | Cargador |
| 18 | Tipos de Calzado | 3 | 153 | Sandalias Infantiles Crocs Café Talla 15 MX |
| 19 | Belleza y Cosmética | 6 | 194 | Labial Líquido Mate Revlon Tono Rojo Clásico |
| 20 | Artículos para el Hogar | 5 | 236 | Silla de Oficina Ergonómica Ikea Rosa |
| 21 | Deportes y Entrenamiento | 7 | 166 | Leggings Deportivos Skechers Rosa Talla M |
| 22 | Laptops | 13 | 303 | Laptop Adata Plus |
| 23 | Tablets | 13 | 244 | Tablet Lenovo Air |
| 24 | Monitores | 13 | 350 | Monitor |
| 25 | Teclados | 14 | 260 | Teclado |
| 26 | Mouse y Ratones | 14 | 244 | Mouse |
| 27 | Cámaras Web | 14 | 276 | Cámara Web HD Acer V2 |
| 28 | Smartwatches | 17 | 267 | Smartwatch Huawei V2 |
| 29 | Proyectores | 15 | 265 | Proyector Portátil Corsair Gamer Edition |
| 30 | Micrófonos | 15 | 263 | Micrófono Condensador LG Air |
| 31 | Sillas Gamer | 1 | 258 | Silla Gamer Asus Gaming |
| 32 | Audífonos Bluetooth | 15 | 287 | Audífonos Bluetooth Acer Lite |
| 33 | Cargadores USB-C | 17 | 254 | Cargador |
| 34 | Cables HDMI | 14 | 252 | Cable HDMI Samsung Plus |
| 35 | Baterías Externas | 17 | 250 | Power Bank Logitech Max |
| 36 | Bocinas Bluetooth | 15 | 276 | Bocina Bluetooth Xiaomi Air |
| 37 | Soportes para Laptop | 14 | 241 | Soporte Laptop Samsung Gaming |
| 38 | Memorias USB | 13 | 234 | Kingston |
| 39 | Hubs USB-C | 14 | 227 | Hub USB-C Huawei Plus |
| 40 | Routers Wi-Fi | 14 | 217 | Router Wi-Fi Huawei Pro |
| 41 | Discos Duros Externos | 13 | 217 | Disco Duro Externo Xiaomi V2 |
| 42 | Computadoras de Escritorio | 13 | 1 | PC |
| 43 | Robots y Juguetes Electrónicos | 11 | 1 | ROBOT |
| 44 | Cubreasientos para Auto | 9 | 43 | Cubreasientos Universal Michelin Verde Olivo |
| 45 | Ropa Deportiva | 21 | 31 | Leggings Deportivos Skechers Rosa Talla M |
| 46 | Labiales | 19 | 36 | Labial Líquido Mate Revlon Tono Rojo Clásico |
| 47 | Pantalones y Jeans | 16 | 38 | Jeans Slim Fit Levi's Mezclilla Blanco Talla 30 |
| 48 | Libros de Tecnología y Programación | 8 | 33 | Manual de Bases de Datos SQL Pearson |
| 49 | Playeras | 16 | 68 | Playera Deportiva Dry-Fit Hering Azul Marino Talla G |
| 50 | Sudaderas | 16 | 41 | Sudadera Cuello Redondo Nike Verde Olivo Talla XG |
| 51 | Aceites y Mantenimiento Automotriz | 9 | 35 | Aceite de Motor Castrol 5W-40 4 L |
| 52 | Juguetes Educativos | 11 | 33 | Bloques de Construcción Educa 100 Piezas |
| 53 | Cuidado del Cabello | 19 | 32 | Acondicionador Pantene 750 ml |
| 54 | Vestidos | 16 | 39 | Vestido Midi Stradivarius Vino Talla M |
| 55 | Papelería y Escritura | 8 | 48 | Estuche de Colores Norma 36 Piezas |
| 56 | Carteras y Billeteras | 4 | 14 | Cartera de Piel Fossil Negro |
| 57 | Joyería | 4 | 23 | Collar de Plata 925 Pandora Estrella |
| 58 | Productos para Gatos | 10 | 30 | Rascador para Gato Royal Canin Poste |
| 59 | Maquillaje para Rostro | 19 | 30 | Base de Maquillaje Covergirl Tono Claro |
| 60 | Figuras Coleccionables | 11 | 23 | Figura Coleccionable Mattel Serie Edición Limitada FG-2712 |
| 61 | Relojes | 4 | 25 | Reloj Digital Seiko XB-4491 Mostaza |
| 62 | Sandalias | 18 | 18 | Sandalias Infantiles Crocs Café Talla 15 MX |
| 63 | Muebles | 20 | 30 | Silla de Oficina Ergonómica Ikea Rosa |
| 64 | Componentes y Almacenamiento de Cómputo | 1 | 54 | Unidad SSD Crucial 240GB SATA |
| 65 | Libros | 8 | 34 | Libro de Cocina Mexicana Fácil y Rápida Penguin Random House PD-2959 |
| 66 | Utensilios de Cocina | 20 | 36 | Juego de Sartenes Antiadherentes Oster 5 Piezas |
| 67 | Cafeteras | 20 | 30 | Cafetera Hamilton Beach 10 Tazas Café |
| 68 | Smartphones | 17 | 64 | Smartphone Realme CJ-8619 256GB |
| 69 | Cinturones | 4 | 14 | Cinturón de Piel Tommy Hilfiger Gris |
| 70 | Accesorios Gaming | 11 | 33 | Headset Gamer Logitech ZL-5578 Rojo |
| 71 | Cuidado e Hidratación de la Piel | 19 | 39 | Crema Hidratante Facial CeraVe 200 ml |
| 72 | Calzado Casual | 18 | 19 | Botín Casual Dr. Martens Beige Talla 27 MX |
| 73 | Tacones y Plataformas | 18 | 23 | Zapatilla de Tacón Andrea Azul Cielo Talla 25 MX |
| 74 | Bolsas y Mochilas | 4 | 38 | Mochila Urbana Totto 25L Vino |
| 75 | Gorras y Sombreros | 4 | 22 | Gorra Ajustable New Era Gris |
| 76 | Productos para Perros | 10 | 47 | Croquetas para Perro Adulto Hills 2 kg |
| 77 | Zapatos Formales | 18 | 30 | Zapato Derby de Piel Calvin Klein Beige Talla 26 MX |
| 78 | Camping y Sacos de Dormir | 12 | 30 | Bolsa de Dormir Naturehike Beige |
| 79 | Blancos y Ropa de Cama | 20 | 34 | Juego de Sábanas Ikea Queen Size Verde Olivo |
| 80 | Protección Solar | 19 | 21 | Protector Solar La Roche-Posay FPS 50+ |
| 81 | Accesorios para Running | 21 | 10 | Cinturón de Hidratación Salomon Azul Cielo |
| 82 | Refacciones Automotrices | 9 | 34 | Balatas Delanteras Bosch EE-9376 |
| 83 | Fútbol | 21 | 28 | Balón de Fútbol Voit No. 4 |
| 84 | Oficina e Impresión | 8 | 18 | Impresora Multifuncional Brother CR-7831 |
| 85 | Perfumes | 19 | 36 | Perfume para Hombre 50 ml Hugo Boss DV-2379 |
| 86 | Juegos de Mesa | 11 | 20 | Juego de Mesa Aventura Devir |
| 87 | Ciclismo | 21 | 36 | Casco para Ciclismo Benotto Talla Unitalla Blanco |
| 88 | Tenis | 18 | 63 | Tenis para Dama Nike ZG-7131 Rojo Talla 24 MX |
| 89 | Pesas y Mancuernas | 21 | 34 | Mancuernas Hexagonales Rogue 15 kg HK-9838 |
| 90 | Licuadoras | 20 | 24 | Licuadora Hamilton Beach Alto Rendimiento 1200W Azul Cielo |
| 91 | Blusas | 16 | 34 | Blusa Manga Larga Vero Moda Rosa Talla G |
| 92 | Decoración | 20 | 21 | Jarrón Decorativo Liverpool Hogar Rojo |
| 93 | Consolas de Videojuegos | 11 | 13 | Consola Nintendo Edición Digital 1TB |
| 94 | Sofás y Sillones | 20 | 21 | Sofá de 2 Plazas Beige Muebles Dico |
| 95 | Yoga | 21 | 27 | Tapete de Yoga Manduka Blanco |
| 96 | Iluminación | 20 | 40 | Foco LED Inteligente Philips Pieza |
| 97 | Smart TV | 1 | 32 | Smart TV TCL 65 pulgadas 4K |
| 98 | Fundas y Protectores para Smartphone | 17 | 33 | Mica de Cristal Templado Mous |
| 99 | Lentes de Sol | 4 | 25 | Lentes de Sol Armani Exchange JX-5313 Rojo |
| 100 | Audífonos con Cable | 15 | 33 | Audífonos con Cable Bose Rosa |
<!-- CATEGORY-POPULATION-END -->

## Relaciones declaradas

- `tb_carts.user_ID` -> `tb_users.ID` (`tb_carts_ibfk_1`).
- `tb_order_cancellations.order_ID` -> `tb_orders.ID` (`tb_order_cancellations_ibfk_1`).
- `tb_orders.seller_ID` -> `tb_users.ID` (`tb_orders_ibfk_1`).
- `tb_payment_methods.user_ID` -> `tb_users.ID` (`tb_payment_methods_ibfk_1`).
- `tb_payment_methods.type_ID` -> `tbc_payment_methods_types.ID` (`tb_payment_methods_ibfk_2`).
- `tb_payment_transaction.payment_ID` -> `tb_payments.ID` (`tb_payment_transaction_ibfk_1`).
- `tb_payments.order_ID` -> `tb_orders.ID` (`tb_payments_ibfk_1`).
- `tb_payments.payment_method_ID` -> `tb_payment_methods.ID` (`tb_payments_ibfk_2`).
- `tb_people.user_ID` -> `tb_users.ID` (`fk_people_users`).
- `tb_refunds.order_ID` -> `tb_orders.ID` (`tb_refunds_ibfk_1`).
- `tb_refunds.payment_ID` -> `tb_payments.ID` (`tb_refunds_ibfk_2`).
- `tb_returns.order_ID` -> `tb_orders.ID` (`tb_returns_ibfk_1`).
- `tb_shipments.order_ID` -> `tb_orders.ID` (`tb_shipments_ibfk_1`).
- `tb_user_addresses.user_ID` -> `tb_users.ID` (`fk_addresses_users`).
- `tbd_address_components.address_ID` -> `tb_user_addresses.ID` (`fk_component_address`).
- `tbd_address_components.address_ID,address_sup_ID` -> `tbd_address_components.address_ID,ID` (`fk_component_parent`).
- `tbd_cancellation_items.cancellation_ID` -> `tb_order_cancellations.ID` (`tbd_cancellation_items_ibfk_1`).
- `tbd_cancellation_items.product_ID` -> `tb_products.ID` (`tbd_cancellation_items_ibfk_2`).
- `tbd_cart_items.cart_ID` -> `tb_carts.ID` (`tbd_cart_items_ibfk_1`).
- `tbd_cart_items.provider_ID` -> `tbd_products_users_providers.user_ID` (`tbd_cart_items_ibfk_2`).
- `tbd_cart_items.product_ID` -> `tbd_products_users_providers.product_ID` (`tbd_cart_items_ibfk_3`).
- `tbd_order_items.seller_order_ID` -> `tb_orders.ID` (`tbd_order_items_ibfk_1`).
- `tbd_order_items.product_ID` -> `tbd_products_users_providers.product_ID` (`tbd_order_items_ibfk_2`).
- `tbd_order_items.provider_ID` -> `tbd_products_users_providers.user_ID` (`tbd_order_items_ibfk_3`).
- `tbd_products_categories.category_ID` -> `tbc_categories.ID` (`fk_category_1`).
- `tbd_products_categories.product_ID` -> `tb_products.ID` (`fk_product_1`).
- `tbd_products_users_providers.product_ID` -> `tb_products.ID` (`fk_products2`).
- `tbd_products_users_providers.user_ID` -> `tb_users.ID` (`fk_user1`).
- `tbd_return_items.return_ID` -> `tb_returns.ID` (`tbd_return_items_ibfk_1`).
- `tbd_return_items.product_ID` -> `tb_products.ID` (`tbd_return_items_ibfk_2`).
- `tbd_user_payment_methods.user_ID` -> `tb_users.ID` (`tbd_user_payment_methods_ibfk_1`).
- `tbd_user_payment_methods.payment_method_type_ID` -> `tbc_payment_methods_types.ID` (`tbd_user_payment_methods_ibfk_2`).
- `tbd_users_wishlist_products.product_ID` -> `tb_products.ID` (`fk_products3`).
- `tbd_users_wishlist_products.user_ID` -> `tb_users.ID` (`fk_users2`).

La FK autorreferencial de `tbd_address_components` se muestra en el diccionario; el diagrama la documenta en la columna porque no se dibuja como una relación entre tablas distintas.

`tbc_categories.sup_id_category` modela la jerarquía lógica de categorías, pero no se muestra como FK porque el DDL no la declara.
