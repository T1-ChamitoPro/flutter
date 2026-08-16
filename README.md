# Sistema de Préstamo de Equipos Audiovisuales

Aplicación para que los estudiantes puedan solicitar el préstamo de equipos audiovisuales de la universidad, como proyectores, micrófonos y cámaras.
Permite al departamento de tecnología llevar el control de los préstamos, conocer qué equipos están prestados y verificar cuáles ya fueron devueltos.

## El dominio

El dominio representa los elementos principales involucrados en el proceso de préstamo de equipos.

* `Prestamo` — entidad principal que representa una solicitud de préstamo. Contiene información como el equipo solicitado, el estudiante, las fechas del préstamo y su estado.
* `Equipo` — entidad que representa un equipo audiovisual disponible para préstamo, como proyectores, micrófonos o cámaras.
* `EstadoPrestamo` — enumeración que representa el estado actual de un préstamo.
* `PrestamosLocales` — fuente local de datos utilizada para almacenar y gestionar los préstamos durante la ejecución de la aplicación.
* `PrestamosRepository` — repositorio encargado de definir y centralizar las operaciones relacionadas con los préstamos.

### Estados del préstamo

`EstadoPrestamo` es una clase sellada (`sealed class`) que representa los diferentes estados que puede tener un préstamo. Cada estado contiene únicamente la información correspondiente a esa situación.

Los estados disponibles son:

* `Solicitado` — representa un préstamo que ha sido solicitado. Registra la fecha y hora en la que se realizó la solicitud mediante `solicitadoEn`.
* `Entregado` — representa un equipo que ya fue entregado al estudiante. Registra cuándo se realizó la entrega (`entregadoEn`) y quién realizó la entrega (`entregadoPor`).
* `Devuelto` — representa un equipo que fue regresado al departamento de tecnología. Registra la fecha de entrega, la fecha esperada de devolución, la fecha real de devolución y la persona que recibió el equipo.
* `Vencido` — representa un préstamo cuya devolución se encuentra vencida. Registra la fecha esperada de devolución, la fecha de devolución registrada y el motivo del vencimiento.

### Comportamiento de los estados

El modelo también define comportamientos asociados a cada estado:

* Un préstamo en estado `Solicitado` o `Entregado` puede ser cancelado.
* Un préstamo en estado `Devuelto` o `Vencido` no puede ser cancelado.
* Cada estado proporciona una etiqueta (`etiqueta`) para mostrar una descripción legible en la interfaz.

Por ejemplo:

```dart
Solicitado → "Solicitado"
Entregado → "Entregado · [persona]"
Devuelto   → "Devuelto"
Vencido    → "Vencido: [motivo]"
```

### Serialización

Los estados pueden convertirse desde y hacia JSON mediante los métodos `fromJson` y `toJson`.

Para identificar el tipo de estado, se utiliza el campo `tipo`:

```text
solicitado
entregado
devuelto
vencido
```

Esto permite almacenar y recuperar los estados del préstamo manteniendo la información específica de cada uno.


### Estructura del dominio

La funcionalidad relacionada con los préstamos se encuentra organizada dentro de `features/prestamos`:

```text
features/
└── prestamos/
    ├── data/
    │   └── prestamos_locales.dart
    │
    ├── domain/
    │   ├── equipo.dart
    │   ├── estado_prestamo.dart
    │   ├── prestamo.dart
    │   └── prestamos_repository.dart
    │
    └── presentation/
```

### Decisión de modelado

Se decidió utilizar **modelos escritos manualmente**, sin `freezed`, porque el dominio actual es pequeño y sus entidades tienen una estructura sencilla. Esto permite mantener el proyecto fácil de entender y evitar dependencias y generación de código innecesarias para esta etapa.

## Problema que resuelve

Actualmente los estudiantes no cuentan con un sistema centralizado para solicitar equipos audiovisuales de la universidad. Además, el departamento de tecnología tiene dificultades para llevar un control claro de los equipos prestados y saber cuáles ya fueron devueltos.

La aplicación busca solucionar este problema digitalizando el proceso de solicitud y seguimiento de préstamos, permitiendo tener un registro organizado del estado de cada equipo.

## Funcionalidad

La aplicación está orientada a permitir:

* Registrar solicitudes de préstamo.
* Seleccionar el equipo que se desea solicitar.
* Consultar la información de los equipos.
* Controlar el estado de cada préstamo.
* Identificar préstamos pendientes, aprobados y activos.
* Registrar la devolución de los equipos.
* Consultar qué equipos se encuentran actualmente prestados.
* Mantener la información organizada mediante un repositorio.

## Arquitectura

El proyecto sigue una organización basada en separación por funcionalidades y capas:

```text
features/
└── prestamos/
    ├── data/
    ├── domain/
    └── presentation/
```

### Domain

Contiene las reglas y modelos principales del negocio:

* Entidades.
* Estados.
* Contratos de repositorios.

### Data

Contiene la implementación de la fuente de datos utilizada actualmente por la aplicación.

### Presentation

Contiene la interfaz de usuario y los componentes encargados de presentar y gestionar la interacción con el usuario.

## Tecnologías

* **Flutter**
* **Dart**
* Modelado de dominio manual
* Arquitectura organizada por funcionalidades

## Cómo correrlo

Instalar las dependencias:

```bash
flutter pub get
```

Ejecutar las pruebas:

```bash
flutter test
```

Ejecutar la aplicación:

```bash
flutter run
```
