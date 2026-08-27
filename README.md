# HijabiSwap

A Flutter mobile app for browsing, listing, and swapping/trading hijabs and related items between users. It combines a marketplace-style product feed with a request/activity system so users can offer items, send and receive swap requests, and rate each other after a trade.

## Features

- **Auth** — email/password login, sign up, and forgot-password flow, backed by a token-based API session (auto-refresh via an auth interceptor).
- **Home feed** — browse listed products with an image slider, skeleton loading states, and per-user "my products" management (add/edit/delete).
- **Add / edit product** — create new listings with images, details, and location (via `geolocator` / `country_picker`).
- **Favorites** — save products of interest for later.
- **Activity** — track sent and received swap requests, confirm orders, and rate the other party after a swap completes.
- **Profile** — view and edit your own profile.
- **Notifications** — in-app notifications list plus push notifications via Firebase Cloud Messaging (`firebase_messaging`, `flutter_local_notifications`).

## Tech stack

- **Flutter** (Dart SDK ^3.7.2)
- **GetX** (`get`) for state management, dependency injection, and routing (see [lib/routes](lib/routes))
- **Dio** for networking, with custom interceptors for auth and logging (see [lib/core/network](lib/core/network))
- **Firebase** (Core + Messaging) for push notifications
- **get_storage** for local key/value persistence (auth token storage)
- **json_serializable** / **build_runner** for model (de)serialization codegen

## Project structure

```
lib/
  core/network/     # Dio client, interceptors, exceptions, API endpoints
  data/models/       # JSON-serializable data models
  data/services/     # API-backed services (auth, products, activity, profile, notifications)
  modules/           # Feature modules (auth, home, activity, favorites, profile, addproduct, ...)
                      #   each with view/controller/bindings following GetX conventions
  routes/            # App routes and page bindings
  storage/           # Local token storage
  theme/             # App colors and theme
  widgets/           # Shared/reusable widgets
  main.dart          # App entry point
```

## Getting started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and make sure `flutter doctor` passes.
2. Install dependencies:
   ```
   flutter pub get
   ```
3. This project uses Firebase (Core + Messaging). Make sure `android/app/google-services.json` and/or `ios/Runner/GoogleService-Info.plist` are configured for your Firebase project before running.
4. Generate model serialization code after any model change:
   ```
   dart run build_runner build --delete-conflicting-outputs
   ```
5. Run the app:
   ```
   flutter run
   ```

## Useful resources

- [Flutter documentation](https://docs.flutter.dev/)
- [GetX package](https://pub.dev/packages/get)
- [Dio package](https://pub.dev/packages/dio)
