# Yemen Mandi Backend Architecture Notes

## 5) نظام التوفر (Critical Feature)

### المشكلة
في تطبيقات التوصيل، أكبر مصدر فشل هو قبول طلبات على منتجات غير متوفرة أو مخزونها لا يكفي.

### الحل المقترح
عند `POST /orders`:
1. التحقق أن `is_available = true` لكل منتج.
2. التحقق أن الكمية المطلوبة <= `stock - reserved_stock`.
3. (اختياري) إنشاء **Inventory Lock** قصير المدة أثناء الـ checkout لتقليل التضارب.

### تنفيذ قاعدة البيانات
- `products.reserved_stock` لحجز مؤقت للمخزون.
- `products.stock_version` لدعم optimistic locking عند التحديث.
- جدول `inventory_locks` مع `expires_at` لتنظيف الحجوزات المنتهية.

## 6) Admin Portal (قلب المشروع)

### المكونات الأساسية
- **Dashboard**: إجمالي الطلبات + الإيراد + الحالات التشغيلية.
- **Meal Management**: إنشاء/تحديث/حذف الوجبات.
- **Instant Availability**: تفعيل/تعطيل الوجبات فورياً.
- **Live Order Management**: تغيير حالة الطلبات بشكل مباشر.

### Endpoints
- `GET /admin/dashboard`
- `POST /admin/products`
- `PUT /admin/products/{id}`
- `DELETE /admin/products/{id}`
- `PATCH /admin/products/{id}/availability`
- `GET /admin/orders`
- `PATCH /admin/orders/{id}/status`

## 7) Tech Stack (مجرب في السوق)

### Mobile
- **Flutter** (recommended)
- أو **React Native**

### Backend
- **Node.js (NestJS)**

### Database
- **PostgreSQL**

### Realtime
- **Firebase** أو **Socket.IO**

## Realtime Integration Pattern
- Broadcast order status updates to:
  - Customer channel: `orders:{order_id}`
  - Admin ops channel: `admin:orders`
- Trigger UI refresh in dashboard and order tracking screens instantly.
