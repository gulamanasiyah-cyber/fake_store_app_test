# 🛍️ Fake Store App

A modern e-commerce catalog app built with Flutter using **Clean Architecture** and **BLoC** state management, powered by the [FakeStore API](https://fakestoreapi.com).

---

## 📱 Screenshots

| Login (Dark) | Product List (Dark) | Product Detail (Light) |
|---|---|---|
| Login screen with gradient | Product grid with search & filters | Detail page with quantity selector |

---

## ⚙️ Setup Instructions

### Prerequisites
- Flutter **3.x (latest stable)**
- Dart **3.x**
- Android SDK (for APK) or Xcode (for iOS)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/gulamanasiyah-cyber/fake_store_app_test.git
cd fake_store_app_test

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Build release APK
flutter build apk --release
```

### Test Credentials
The app uses the FakeStore API. Use these credentials to log in:
```
Username: johnd
Password: m38rmF$
```

---

## 🏛️ Architecture

This project follows **Clean Architecture** principles, separating the codebase into three distinct layers:

```
lib/
├── core/
│   ├── errors/           # Failure types (ServerFailure, CredentialFailure, etc.)
│   ├── network/          # DioClient (base HTTP client)
│   └── theme/            # AppTheme + ThemeBloc (light/dark)
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/    # AuthRemoteDataSource (API calls)
│   │   │   └── repositories/  # AuthRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/       # (token handled as String)
│   │   │   ├── repositories/   # AuthRepository (abstract)
│   │   │   └── usecases/       # LoginUseCase
│   │   └── presentation/
│   │       ├── bloc/           # AuthBloc, AuthEvent, AuthState
│   │       └── pages/          # LoginPage
│   │
│   └── product/
│       ├── data/
│       │   ├── datasources/    # ProductRemoteDataSource, ProductLocalDataSource
│       │   ├── models/         # ProductModel (JSON serialization)
│       │   └── repositories/  # ProductRepositoryImpl
│       ├── domain/
│       │   ├── entities/       # ProductEntity
│       │   ├── repositories/   # ProductRepository (abstract)
│       │   └── usecases/       # GetProducts, GetFavorites, ToggleFavorite
│       └── presentation/
│           ├── bloc/           # ProductBloc, ProductEvent, ProductState
│           └── pages/          # ProductListPage, ProductDetailPage
│
├── injection_container.dart    # GetIt dependency injection
└── main.dart                   # Entry point
```

### Layer Responsibilities

| Layer | Responsibility |
|---|---|
| **Data** | API calls, local storage, JSON parsing, repository implementation |
| **Domain** | Business logic, use cases, abstract repository contracts, entities |
| **Presentation** | UI widgets, BLoC state management, user interaction |

---

## 🔄 State Management

The app uses **flutter_bloc** (BLoC pattern) for all state management.

### AuthBloc
Manages the authentication flow:

```
AuthLoginSubmitted → AuthLoading → AuthSuccess / AuthError
                                          └── AuthValidationError   (empty fields)
                                          └── AuthCredentialError   (wrong username/password)
                                          └── AuthError             (server/network error)
```

### ProductBloc
Manages the product catalog with client-side filtering:

```
FetchCatalogStarted      → ProductLoading → ProductLoaded
SearchQueryFilterChanged → ProductLoaded (filtered)
CategoryFilterChanged    → ProductLoaded (filtered)
ToggleFavoritePressed    → ProductLoaded (updated favorites)
```

> **Note:** All states carry `searchQuery`, `selectedCategory`, and `sortOrder` to prevent UI resets during state transitions.

### ThemeBloc
Manages the app-wide light/dark theme toggle, persisted via `SharedPreferences`:

```
ThemeToggled → ThemeState(isDark: true/false)
```

---

## 📦 Third-Party Libraries

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^9.1.1 | BLoC / Cubit state management |
| `bloc` | ^9.0.0 | Core BLoC library |
| `equatable` | ^2.0.7 | Value equality for BLoC states/events |
| `get_it` | ^8.0.3 | Service locator / dependency injection |
| `dio` | ^5.8.0+1 | HTTP client for API requests |
| `shared_preferences` | ^2.5.3 | Local key-value storage (favorites, theme) |
| `dartz` | ^0.10.1 | Functional programming (`Either` for error handling) |

---

## ✨ Features

### Core
- [x] Browse product catalog from FakeStore API
- [x] Search products by keyword
- [x] Filter by category (All, Electronics, Jewelery, Men's, Women's)
- [x] View product details (image, description, price, rating)
- [x] Quantity selector with live total calculation
- [x] Add to cart feedback (snackbar confirmation)
- [x] Mark/unmark favorites (persisted locally)
- [x] JWT-based authentication via FakeStore API

### Bonus
- [x] 🌙 **Dark / Light mode toggle** (persisted across sessions)
- [x] 🎨 **Premium marketplace UI** with glassmorphism & gradients
- [x] ✨ **Animations** (fade-in on login, animated containers, chip transitions)
- [x] 💾 **Offline caching** for favorite products via SharedPreferences
- [x] 🛡️ **Differentiated error handling** (Validation / Credential / Server errors)

---

## 🔌 API Reference

Base URL: `https://fakestoreapi.com`

| Endpoint | Method | Description |
|---|---|---|
| `/auth/login` | POST | Authenticate and receive JWT token |
| `/products` | GET | Fetch all products |
| `/products/categories` | GET | Fetch all categories |

> The login endpoint returns **HTTP 201** with `{ "token": "..." }`.

---

## 🗂️ Error Handling

Errors are mapped through a `Failure` hierarchy:

```dart
abstract class Failure
  ├── ServerFailure     // Network errors, unexpected server responses
  ├── CacheFailure      // Local storage read/write errors
  └── CredentialFailure // Invalid username or password (HTTP 400/401)
```

Each `Failure` is caught in the BLoC layer and converted to a specific UI state, which renders the appropriate error message or snackbar to the user.
