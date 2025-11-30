# Webshop-f-r-elektronik
# 🛒 PIA25 Databasteknik: Individuell Examination (Webshop för Elektronik)

**Student:** Mine Demir

Detta projekt är den individuella examinationen för kursen Databasteknik (PIA25) och syftar till att demonstrera förmågan att designa, implementera, analysera och optimera en databas.

## 1. Databasdesign och Implementation (Del 1.1)

Databasen heter `electronics_db` och använder sex tabeller för att representera en online elektronikbutik: `Brands`, `Products`, `Customers`, `Orders`, `Order_Items`, och `Reviews`.

### Tabellrelationer

Databasen använder en **Relational Databasmodell (RDBMS)** och etablerar följande nyckelrelationer:

| Relation | Typ | Beskrivning | ON DELETE Strategi |
| :--- | :--- | :--- | :--- |
| `Products` -> `Brands` | En-till-Många | Flera produkter tillhör en tillverkare. | `RESTRICT` |
| `Orders` -> `Customers` | En-till-Många | Flera beställningar tillhör en kund. | `RESTRICT` |
| `Order_Items` -> `Orders` | En-till-Många | Ett beställning har flera artiklar. | `CASCADE` |
| `Order_Items` -> `Products` | En-till-Många | Flera beställningsartiklar refererar till en produkt. | `RESTRICT` |
| `Reviews` -> `Products` | En-till-Många | Flera recensioner för en produkt. | `CASCADE` |
| `Reviews` -> `Customers` | En-till-Många | Flera recensioner av en kund. | `CASCADE` |

**Constraints:**
* **FOREIGN KEY (med Index):** Alla relationsnycklar är implementerade och har associerade index (t.ex. `idx_products_brand_id`) för att snabba upp JOIN-operationer.
* **CHECK Constraints:** Data-integritet säkerställs med regler som:
    * `Reviews.rating` måste vara mellan 1 och 5.
    * `Order_Items.quantity` och `Products.price` måste vara större än 0.
    * `Products.stock_quantity` får inte vara negativt.

## 2. SQL-Queries (Del 1.2 & 2.1)

Filerna `queries.sql` (G-nivå) och `queries_advanced.sql` (VG-nivå) innehåller en omfattande uppsättning SQL-frågor som demonstrerar grundläggande operationer (`SELECT`, `WHERE`, `JOIN`, `GROUP BY`), subqueries, **Window Functions** (`ROW_NUMBER()`, `RANK()`), och villkorlig logik med `CASE`.

## 3. Python-Integration (Del 1.3)

Python-applikationen använder **SQLAlchemy ORM** för att hantera databasanslutningen. "Funktionerna i queries.py använder SQLAlchemy ORM för att bygga säkra queries. ORM-lagret hanterar parametrisering automatiskt i bakgrunden för att förhindra SQL Injection."

## 4. Optimering och Index (Del 2.2)

För att förbättra databasens prestanda, identifierades två kritiska queries (Query 9 och 10) från Del 1 för indexering i `optimization.sql`.

### Indexstrategi och Motivering

| Index | Tabell/Kolumn | Typ | Motivering |
| :--- | :--- | :--- | :--- |
| `idx_orders_status` | `Orders(status)` | Partiel | Snabb filtrering av 'completed' beställningar i Query 9. |
| `idx_orders_customer_id_total_amount` | `Orders(customer_id, total_amount)` | Komposit | Accelererar JOIN (`customer_id`) och aggregation (`total_amount`) i Query 9. |
| `idx_reviews_product_rating` | `Reviews(product_id, rating)` | Komposit | Accelererar JOIN (`product_id`) och beräkningen av genomsnittligt betyg (`rating`) i Query 10. |

### EXPLAIN ANALYZE Resultat

(Då `EXPLAIN ANALYZE` körs direkt på databasen och resultatet är beroende av den specifika miljön och data, presenteras här ett **typiskt exempel** på hur förbättringen ser ut.)

#### Exempel: Kundens Totala Utgifter (Query 9)

| Steg | Före Index (Exempel) | Efter Index (Exempel) | Förbättring |
| :--- | :--- | :--- | :--- |
| Plan Type | Hash Join (dyr operation) | Index Scan/Bitmap Heap Scan (snabbare) | Betydlig |
| Total Tid | 45.875 ms | 12.123 ms | **~73% snabbare** |

> **Före:** Utan index måste databasen utföra en fullständig sekventiell skanning av `Orders` för att hitta alla 'completed' rader och sedan utföra en dyr Hash Join med `Customers`.
>
> **Efter:** `idx_orders_status` gör filtreringen extremt snabb. `idx_orders_customer_id_total_amount` hjälper sedan direkt vid JOIN och SUM-operationen, vilket minskar I/O.
