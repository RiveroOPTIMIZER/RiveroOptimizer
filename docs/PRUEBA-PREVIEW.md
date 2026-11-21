# Cómo probar Rivero Optimizer Preview

## Importante

Esta compilación 0.5.0-preview es una **vista previa de solo lectura**. Sirve para comprobar la interfaz, el selector PC/LAPTOP, las categorías, la búsqueda y el diagnóstico básico. No aplica optimizaciones, no desinstala aplicaciones y no cambia la configuración de Windows. No necesita permisos de administrador.

## Pasos

1. Descarga el ZIP de la rama `rivero/winutil-foundation` desde GitHub y extrae toda la carpeta.
2. Abre la carpeta extraída.
3. Comprueba que estén juntos `RiveroOptimizer-Test.ps1`, `Modules` y `Catalog`.
4. Haz clic derecho en `RiveroOptimizer-Test.ps1` y elige **Ejecutar con PowerShell**.
5. En la ventana, cambia entre **PC** y **LAPTOP**, prueba las categorías y el buscador.
6. Pulsa **VER DIAGNÓSTICO** para mostrar información básica del equipo.

Si Windows impide abrir el archivo, no desactives sus protecciones. Dime el mensaje exacto que aparece y lo revisamos.

## Qué necesito que revises

- ¿Abre la ventana sin errores?
- ¿Se ve el tema negro y verde?
- ¿El selector cambia las opciones al alternar PC/LAPTOP?
- ¿Funcionan las categorías y la búsqueda?
- ¿El diagnóstico muestra correctamente Windows, CPU, RAM y GPU?

Esta vista previa no representa todavía la integración completa de Chris Titus WinUtil. Las pestañas Instalación, Configuración y Actualizaciones son marcadores de posición.
