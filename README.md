# Yemen Mandi

Production-oriented Flutter frontend for Yemen Mandi food delivery, integrated with existing NestJS/PostgreSQL backend APIs.

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

## Delivered frontend scope

- Arabic-first RTL with English LTR toggle
- Light / Dark premium brand theme
- Riverpod state management + Dio API service + repository usage
- Splash, onboarding, auth, home, product details, cart, checkout, orders, profile
- Bottom navigation (Home, Orders, Cart, Favorites, Profile)
- Availability-aware add-to-cart and checkout validation
- API fallback to mock data in development when backend is unavailable

## Existing docs

- `DESIGN_SYSTEM.md`
- `REST_API_SPEC.yaml`
- `DATABASE_SCHEMA.sql`
- `BACKEND_ARCHITECTURE.md`
