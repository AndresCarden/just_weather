# 🌤️ Just Weather

**Just Weather** es una aplicación Flutter que muestra información meteorológica detallada, incluyendo:

✔️ Pronóstico horario y diario  
✔️ Sensación térmica, humedad, viento, UV, visibilidad y más  
✔️ Búsquedas recientes con autocompletado  
✔️ Modo claro/oscuro  
✔️ Skeleton loaders durante carga  
✔️ Soporte de ubicación del usuario  
✔️ UI responsiva para móvil y tablet  
✔️ Tests unitarios y de widget  

---

## 📸 Screenshots

_Puedes insertar aquí imágenes o vídeos luego._

---

## 🚀 Arquitectura

La app está basada en **Flutter + Riverpod** siguiendo separación por capas:

```txt
lib/
├─ core/
│  ├─ di/
│  │  └─ app_providers.dart
│  ├─ theme/
│  │  ├─ app_colors.dart
│  │  ├─ app_text_styles.dart
│  │  ├─ app_theme.dart
│  ├─ api_client.dart
│  ├─ env.dart
│  ├─ app_images.dart
│  └─ location_service.dart
│
├─ features/
│  └─ weather/
│     ├─ application/
│     │  ├─ weather_controller.dart
│     │  ├─ search_controller.dart
│     │  └─ theme_controller.dart
│     ├─ data/
│     │  ├─ weather_api_service.dart
│     │  └─ weather_repository.dart
│     ├─ models/
│     │  ├─ weather_models.dart
│     │  └─ detail_item.dart
│     └─ presentation/
│        ├─ pages/
│        │  └─ weather_home_page.dart
│        └─ widgets/
│           ├─ daily_forecast_strip.dart
│           ├─ hourly_forecast_strip.dart
│           ├─ search_dropdown.dart
│           ├─ section_title.dart
│           ├─ skeleton_box.dart
│           ├─ weather_details_grid.dart
│           ├─ weather_metrics_row.dart
│           └─ unit_chip.dart
│
└─ main.dart

```

---

## 🌍 API Meteorológica

La app utiliza:

👉 **Weather API**  
https://www.weatherapi.com/

Registro gratuito → obtener API KEY.

---

## ⚙️ Configuración de variables (API KEY y BASE URL)

La app **no trae la API key ni la URL quemadas en el código**.  
Se inyectan mediante `--dart-define` usando dos variables:

- `WEATHER_API_KEY`
- `WEATHER_API_BASE`

### Opción A – Archivo `.env` (línea de comandos)

Crear un archivo `.env` en la raíz del proyecto (no lo subas a git):

```env
WEATHER_API_KEY=TU_API_KEY_AQUI
WEATHER_API_BASE=https://api.weatherapi.com
```

Ejecutar la app:

```bash
flutter run --dart-define-from-file=.env
```

Para web:

```bash
flutter run -d chrome --dart-define-from-file=.env
```

Para builds:

```bash
flutter build apk  --release --dart-define-from-file=.env
flutter build web  --release --dart-define-from-file=.env
flutter build ipa  --release --no-codesign --dart-define-from-file=.env
```

---

### Opción B – Ejecutar desde VS Code (`.vscode/launch.json`)

Si usas VS Code puedes definir las variables directamente en la configuración de ejecución, sin escribir el comando cada vez.

Crea la carpeta `.vscode/` en la raíz (si no existe) y dentro un archivo `launch.json`:

```jsonc
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "JustWeather DEV",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=WEATHER_API_BASE=https://api.weatherapi.com",
        "--dart-define=WEATHER_API_KEY=TU_API_KEY_AQUI"
      ]
    }
  ]
}
```

---

## 📦 Instalación

### 1️⃣ Clonar el repo

```bash
git clone https://github.com/tu_usuario/just_weather.git
cd just_weather
```

### 2️⃣ Instalar dependencias

```bash
flutter pub get
```

### 3️⃣ Ejecutar

Usando `.env`:

```bash
flutter run --dart-define-from-file=.env
```

O desde **VS Code** usando la config `JustWeather DEV` del `launch.json`.

---

## 🧭 Funcionalidades

✔️ Ubicación  
✔️ Barra de búsqueda con debouncing  
✔️ Pronóstico horario (scroll horizontal)  
✔️ Tarjetas numéricas con % de cambio  
✔️ Detalles del clima  
✔️ Modo claro/oscuro  
✔️ Skeleton loaders  
✔️ Manejo de errores

---

## 📱 Responsive

Diseñado para:

Mobile: 360px, 390px  
Tablet: 768px, 810px

---

## 🧪 Testing

Ejecutar pruebas:

```bash
flutter test
```

Incluye:

- tests unitarios
- tests widget
- mocks de repositorio/ubicación

---

## 🌐 Demo Web

Generar build:

```bash
flutter build web --release
```
---

## 👨‍💻 Autor

**Andrés Cárdenas**

---

## ✔️ Conclusión

El proyecto cumple:

✓ Funcionalidad  
✓ UI moderna  
✓ Responsive  
✓ Modo oscuro  
✓ Skeletons  
✓ API integrada  
✓ Testing
