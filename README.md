# 📱 Emojournal

**Emojournal** es una app móvil sencilla pero poderosa para registrar tu estado de ánimo diario. Utiliza iconos de Material Design para representar tus emociones y te ofrece un resumen visual de cómo te has sentido en los últimos días, semanas o meses.

Repositorio del proyecto 👉 [github.com/Trollkopf/Emojournal](https://github.com/Trollkopf/Emojournal)

---

## 🌟 Funcionalidades

- Selección de estado de ánimo mediante iconos intuitivos
- Opción de añadir una nota personal por cada entrada
- Gráfico de línea con tu evolución emocional
- Comparación con el periodo anterior
- Historial completo de todos tus registros
- Interfaz clara, moderna y amigable

---

## 🧠 Tecnologías usadas

- [Flutter](https://flutter.dev/) (SDK 3.x)
- [fl_chart](https://pub.dev/packages/fl_chart) para visualización de datos
- [shared_preferences](https://pub.dev/packages/shared_preferences) para almacenamiento local
- Icons de [Material Design](https://fonts.google.com/icons)

---

## 📦 Estructura del proyecto

```
lib/
├── models/             # Modelo de datos (MoodEntry)
├── screens/            # Pantallas: home, historial, entrada
├── services/           # Almacenamiento local (MoodStorage)
├── widgets/            # Componentes reutilizables (MoodCard)
└── main.dart           # Punto de entrada
```

---

## 🚀 Cómo ejecutar

```bash
flutter pub get
flutter run
```

---

## 💾 Notas de desarrollo

- Los datos se guardan localmente con `shared_preferences`.
- Cada entrada se compone de un `moodId`, nota opcional y fecha.
- El resumen gráfico se actualiza según el rango de días elegido (semana, quincena o mes).
- La comparación con el periodo anterior se calcula automáticamente.

---

## 🧩 Próximas mejoras (ideas)

- Exportar como imagen el resumen emocional
- Recordatorios diarios para registrar tu ánimo
- Filtros y etiquetas personalizadas
- Estadísticas mensuales o anuales

---

## 👤 Autor

Desarrollado por [Maximiliano Serratosa Obladen](https://www.linkedin.com/in/maximiliano-serratosa-obladen-full-stack-developer/)  
GitHub: [@Trollkopf](https://github.com/Trollkopf)

---

## 📄 Licencia

Este proyecto es de uso personal/educativo. ¡Si te sirve de base para algo más grande, me alegra mucho! 😊
