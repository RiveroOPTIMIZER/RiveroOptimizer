# Plan de adaptación: Rivero Optimizer

## Objetivo
Adaptar la base de Chris Titus Tech WinUtil para crear Rivero Optimizer, conservando su interfaz WPF/XAML y sus flujos funcionales. La adaptación no debe ser una imitación nueva en WinForms.

## Cambios de identidad
- Nombre visible: Rivero Optimizer.
- Idioma de la interfaz: español.
- Tema: negro y verde (ver `docs/RIVERO-THEME.md`).
- Selector de dispositivo: PC / LAPTOP.

## Organización por dispositivo
Las categorías y subcategorías serán compartidas, pero cada ajuste tendrá reglas de aplicabilidad:
- PC: ajustes apropiados para equipos de escritorio.
- LAPTOP: ajustes apropiados para portátiles, preservando batería, suspensión y gestión térmica.
- AMBOS: ajustes seguros y compatibles con ambos.

La detección automática de batería no será definitiva: el usuario podrá cambiar PC/LAPTOP manualmente.

## Requisitos del motor de ajustes
Cada ajuste debe declarar:
- identificador estable, nombre y descripción en español;
- categoría y subcategoría;
- dispositivos compatibles;
- comprobación de estado actual;
- función de aplicación;
- función de reversión cuando sea posible;
- nivel de riesgo y requisito de administrador;
- compatibilidad de versión de Windows.

No mostrar un ajuste como reversible si no existe una reversión probada. No marcar como aplicado un ajuste si no se verificó el estado final.

## Seguridad y alcance
No incluir como optimizaciones predeterminadas cambios que desactiven Microsoft Defender, Firewall, UAC, BitLocker, Secure Boot, Windows Update o protecciones térmicas. Evitar cambios irreversibles y eliminar aplicaciones/funciones sin confirmación explícita. En portátiles, no forzar planes de alto rendimiento ni desactivar suspensión/hibernación como opción predeterminada.

## Fases
1. Incorporar la base WPF/XAML y conservar la licencia y avisos de terceros.
2. Aplicar identidad Rivero, idioma español y paleta negro/verde.
3. Añadir selector PC/LAPTOP y filtrado por compatibilidad.
4. Portar el catálogo de ajustes de forma individual, revisando seguridad, compatibilidad y reversión.
5. Probar en Windows 10/11 y en PC/portátil antes de publicar.

## Estado
Rama de trabajo: `rivero/winutil-foundation`.
La versión actual 0.4.0 sigue siendo un prototipo WinForms con catálogo de ejemplo; no debe confundirse con una implementación funcional de los ajustes.
