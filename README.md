# Product Catalog App

A production-grade, premium Flutter application demonstrating **Feature-First Clean Architecture**, strict **BLoC State Management (Subclass Pattern)**, and type-safe data transformations.

The application communicates with the [Fake Store API](https://fakestoreapi.com/) for authentication and product exploration, caching favorite product IDs locally using `SharedPreferences`.

---

## 🛠️ Setup Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable Channel, SDK `^3.11.3`)
- [Dart SDK](https://dart.dev/get-started) (Null safety enabled)
- A physical device or emulator (Android / iOS / Web)

### Step 1: Install Dependencies
Download and fetch all required pub packages:
```bash
flutter pub get
```

### Step 2: Run Static Code Analysis
Ensure that all code complies with formatting and type safety:
```bash
flutter analyze
```

### Step 3: Run the Application
Start the application in debug mode on your connected emulator or device:
```bash
flutter run
```

### Step 4: Build Release APK
To compile and generate the release build APK:
```bash
flutter build apk --release
```
The resulting APK will be saved under: `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🏗️ Architecture Explanation

The project uses **Feature-First Clean Architecture** which splits features (`auth` and `product`) into isolated folders. Each feature has three distinct layers to ensure separation of concerns:

```
lib/
├── core/                  # Core modules shared across features
│   ├── errors/            # Base Failures definitions
│   ├── network/           # Dio HTTP client wrapper
│   └── theme/             # Premium color palettes & Typography
├── features/              # Feature directories
│   ├── auth/              # Authentication Feature
│   └── product/           # Product Catalog Feature
│       ├── data/          # Models, Remote & Local Sources, Repo Impls
│       ├── domain/        # Entities, Use Cases, Repository Contracts
│       └── presentation/  # UI Pages & Bloc state managers
├── injection_container.dart
└── main.dart
```

### Domain Layer (Inner Core)
- **Entities**: Business logic definitions (e.g., `ProductEntity` including `isFavorite`). Pure Dart, completely decoupled from data layers.
- **Use Cases**: Encapsulates specific application flow actions (e.g., `GetProducts`, `ToggleFavorite`).
- **Repositories**: Contract/interface specifications implemented by the Data layer.

### Data Layer (Infrastructure)
- **Models**: Extends entities to support JSON serialization and safe data transformations (e.g., `ProductModel.fromJson`).
- **Data Sources**: Handles data fetches.
  - `ProductRemoteDataSource`: Interacts with Fake Store API using Dio.
  - `ProductLocalDataSource`: Manages local favorites storage using `SharedPreferences`.
- **Repository Implementations**: Coordinates sources, merges remote/local status, and translates errors into custom Failures (`ServerFailure`, `CredentialFailure`, `CacheFailure`).

### Presentation Layer (UI & State)
- **BLoCs**: Manages events and maps them to states.
- **Pages / Widgets**: Direct UI widgets building layout from state templates.

---

## 🔄 State Management Explanation

We utilize `flutter_bloc` adhering to explicit semantic events and a strict subclass/multiple-state pattern.

### 1. Product Filter States & Parameters
To prevent the UI from resetting active criteria during loading transitions, the base state `ProductState` implements filter parameters:
- `searchQuery` (String)
- `selectedCategory` (String)
- `sortOrder` (String - `price_asc` | `price_desc`)

Subclasses:
- `ProductInitial`: Instantiated with default values (query: `''`, category: `'All'`, sort: `'price_asc'`).
- `ProductLoading`: Extends base state, maintaining filter parameters so filters remain highlighted on UI during fetching.
- `ProductLoaded`: Contains master database list (`allProducts`) and UI list (`filteredProducts`).
- `ProductError`: Emits details along with active filters.

### 2. Search Debouncing Stream
We intercept rapid keystrokes to prevent API/pipeline processing spam. RxDart operators are attached exclusively to `SearchQueryFilterChanged`:
```dart
on<SearchQueryFilterChanged>(
  _onSearchQueryFilterChanged,
  transformer: (events, mapper) => events
      .debounceTime(const Duration(milliseconds: 300))
      .switchMap(mapper),
);
```

### 3. Central Filter Processing Pipeline
Filters are computed synchronously inside the BLoC by casting to `ProductLoaded` and piping through a unified selection chain:
$$\text{Category Matching} \rightarrow \text{Search Query Contains} \rightarrow \text{Price Sorting}$$

### 4. Differentiated Authentication Errors
Validation, credential, and network faults are split into distinct error states:
- `AuthValidationError`: Local validations (e.g. empty fields, password < 6 characters).
- `AuthCredentialError`: Incorrect username/password returns (HTTP 400/401 Bad Request).
- `AuthServerError`: Connection failure or API timeouts.

---

## 📦 Third-Party Libraries Used

| Library | Version | Description |
| :--- | :--- | :--- |
| **`flutter_bloc`** | `^8.1.3` | Event-driven State Management pattern implementation. |
| **`get_it`** | `^7.6.0` | Service Locator for dependency injection (DI). |
| **`dio`** | `^5.4.0` | HTTP Client supporting request, response, and error interceptors. |
| **`shared_preferences`** | `^2.2.2` | Persistent caching for favorite product IDs locally. |
| **`equatable`** | `^2.0.5` | Value-equality comparison to optimize rebuild triggers. |
| **`rxdart`** | `^0.27.7` | Stream extensions for search debounce and switchMap operators. |

---

## 🔑 Default Credentials for Login
Because the Fake Store API login endpoint requires registered API users, please use the credentials below to log in:

*   **Username**: `johnd`
*   **Password**: `m38rmF$`
