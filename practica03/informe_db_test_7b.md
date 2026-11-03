# Diccionario de datos y modelo EER: db_test_7b

## Fuente y alcance

El esquema y los conteos se extrajeron de `backups.sql/db_test_7b.sql` (mysqldump MySQL 8.0.42; servidor indicado 8.0.45). Los totales indican las filas presentes en las sentencias INSERT del archivo, no un COUNT(*) de la base activa.

## Resumen

- Tablas físicas: **25**
- Columnas: **197**
- Claves foráneas declaradas: **34**
- Vistas: **25**
- Triggers: **72**
- Filas incluidas en los INSERT del respaldo: **76,930**

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

### `tbd_products_categories` — Catálogo e inventario | 8,842 filas en respaldo

| Columna | Tipo SQL | Acepta nulo | Clave | Predeterminado / regla |
|---|---|---:|---|---|
| `product_ID` | `int unsigned` | No | PK; FK tb_products.ID | — |
| `category_ID` | `int unsigned` | No | PK; FK tbc_categories.ID | — |
| `status` | `bit(1)` | No | — | DEFAULT b'1' |
| `creation_date` | `datetime` | No | — | DEFAULT CURRENT_TIMESTAMP |
| `last_update` | `datetime` | Sí | — | DEFAULT NULL; ON UPDATE CURRENT_TIMESTAMP |

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

`tbc_categories.sup_id_category` no tiene FK declarada en el DDL y no se presenta como relación confirmada.
