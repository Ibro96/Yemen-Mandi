# Yemen Mandi

Production-oriented Flutter frontend for Yemen Mandi food delivery, integrated with existing NestJS/PostgreSQL backend APIs, plus complete product/backend documentation assets.

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

## Documentation assets

- Design System: [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md)
- Database Schema (PostgreSQL): [DATABASE_SCHEMA.sql](./DATABASE_SCHEMA.sql)
- REST API (OpenAPI 3.0): [REST_API_SPEC.yaml](./REST_API_SPEC.yaml)
- Backend Architecture Notes: [BACKEND_ARCHITECTURE.md](./BACKEND_ARCHITECTURE.md)
