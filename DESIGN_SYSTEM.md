# Yemen Mandi — Premium Food Delivery Design System

## 1) Brand Foundation

**Product personality:** premium, warm, trustworthy, celebratory, modern Middle Eastern hospitality.

**Design principles**
- **Delicious clarity:** food is always visually primary.
- **Fast confidence:** clear hierarchy for quick ordering decisions.
- **Bilingual by default:** Arabic and English parity across all surfaces.
- **Premium warmth:** vivid brand accents balanced by clean layouts.

---

## 2) Color System

### 2.1 Core Brand Palette
- **Primary Red**: `#E52B2B`
- **Secondary Orange**: `#F28C28`
- **Accent Gold**: `#F5C542`
- **Highlight Teal**: `#2CA6A4`

### 2.2 Neutrals
- **Light Background**: `#FFF8F3`
- **Dark Background**: `#0D0D0D`
- **Text Primary**: `#1A1A1A`
- **Text Secondary**: `#6B6B6B`
- **White**: `#FFFFFF`
- **Dark Card**: `#1A1A1A`
- **Dark Text Soft White**: `#EAEAEA`

### 2.3 Semantic Tokens

#### Light Mode
- `color.bg.app` = `#FFF8F3`
- `color.bg.surface` = `#FFFFFF`
- `color.bg.elevated` = `#FFFFFF`
- `color.text.primary` = `#1A1A1A`
- `color.text.secondary` = `#6B6B6B`
- `color.text.inverse` = `#FFFFFF`
- `color.border.default` = `#F2D7C7`
- `color.border.focus` = `#F28C28`
- `color.action.primary` = `#E52B2B`
- `color.action.primary.hover` = `#CD2323`
- `color.action.primary.pressed` = `#B91C1C`
- `color.action.secondary` = `#F28C28`
- `color.action.secondary.hover` = `#DB7D21`
- `color.action.ghost` = `transparent`
- `color.status.warning` = `#F5C542`
- `color.status.info` = `#2CA6A4`

#### Dark Mode
- `color.bg.app` = `#0D0D0D`
- `color.bg.surface` = `#1A1A1A`
- `color.bg.elevated` = `#222222`
- `color.text.primary` = `#EAEAEA`
- `color.text.secondary` = `#B8B8B8`
- `color.text.inverse` = `#0D0D0D`
- `color.border.default` = `#2C2C2C`
- `color.border.focus` = `#F28C28`
- `color.action.primary` = `#E52B2B`
- `color.action.secondary` = `#F28C28`
- `color.status.warning` = `#F5C542`
- `color.status.info` = `#2CA6A4`

### 2.4 Gradients (Optional Premium Layer)
- `gradient.hero.warm` = `linear-gradient(135deg, #E52B2B 0%, #F28C28 65%, #F5C542 100%)`
- `gradient.badge.special` = `linear-gradient(135deg, #F5C542 0%, #F28C28 100%)`

---

## 3) Typography

### 3.1 Font Families
- **Arabic UI:** Cairo (fallback: IBM Plex Arabic, sans-serif)
- **English UI:** Inter (fallback: SF Pro Text, -apple-system, sans-serif)

### 3.2 Type Scale & Tokens
- **H1**: 32 / 36, **700**
- **H2**: 24 / 30, **600**
- **Body L**: 16 / 24, **400**
- **Body M**: 14 / 22, **400**
- **Caption**: 12 / 16, **400**
- **Label Button**: 14 / 20, **600**

> Allowed visual range from brief is preserved: H1 (28–32), H2 (22–26), Body (14–16), Caption (12).

### 3.3 Language Rules
- Respect locale direction (RTL for Arabic, LTR for English).
- Keep identical hierarchy between Arabic and English screens.
- Use tabular numbers for prices and ratings where available.

---

## 4) Spacing, Grid, and Layout

### 4.1 8pt Spacing Scale
- `space-1` = 4
- `space-2` = 8
- `space-3` = 12
- `space-4` = 16
- `space-5` = 20
- `space-6` = 24
- `space-8` = 32
- `space-10` = 40

### 4.2 App Layout
- Horizontal screen padding: **16–20 px**
- Content max-width (tablet/web responsive): 680–760 px center column
- Vertical rhythm uses 8pt increments only.

### 4.3 Radii
- `radius-sm` = 8
- `radius-md` = 12 (inputs)
- `radius-lg` = 16 (cards)
- `radius-xl` = 24 (feature banners/chips)
- `radius-pill` = 999

### 4.4 Shadows (Soft)
- `shadow-sm`: `0 2px 8px rgba(0,0,0,0.08)`
- `shadow-md`: `0 6px 16px rgba(0,0,0,0.12)`
- `shadow-card`: `0 4px 12px rgba(0,0,0,0.10)`

---

## 5) Components

## 5.1 Buttons

### Primary Button
- Background: `#E52B2B`
- Text: `#FFFFFF`
- Radius: 12
- Height: 48
- Horizontal padding: 16–20
- States:
  - Hover: darken to `#CD2323`
  - Pressed: `#B91C1C`
  - Disabled: bg `#F3B8B8`, text `#FFFFFF`

### Secondary Button (Outline)
- Background: transparent
- Border: 1.5px `#F28C28`
- Text: `#F28C28`
- Radius: 12
- Height: 48
- States: subtle orange tint on hover (`rgba(242,140,40,0.08)`)

### Ghost Button
- Background: transparent
- Border: none
- Text: `#1A1A1A` (light) / `#EAEAEA` (dark)
- Touch feedback: opacity to 0.72

## 5.2 Food Card
- Container:
  - Radius: 16
  - Background: white (light) / `#1A1A1A` (dark)
  - Shadow: `shadow-card`
- Structure (top → bottom):
  1. Food image (16:9), top corners rounded.
  2. Dish name (H2 compact / 16 semibold).
  3. Price row (`Body L` + currency).
  4. Rating row (star icon + value).
- Internal spacing:
  - Outer padding: 12–16
  - Row gaps: 8

## 5.3 Inputs
- Height: 48
- Radius: 12
- Background: `#FFFFFF` / `#1A1A1A`
- Border default: `1px #F2D7C7` (light), `1px #2C2C2C` (dark)
- Focus: `2px #F28C28`
- Placeholder: `#A0A0A0`
- Error: border `#E52B2B`, helper text in red.

## 5.4 Bottom Navigation (5 Tabs)
Tabs: **Home / Orders / Cart / Favorites / Profile**
- Height: 72 (includes safe area handling)
- Icon size: 24
- Label size: 12
- Active color: `#E52B2B`
- Inactive color: `#6B6B6B` (light) / `#9B9B9B` (dark)
- Background: white (light), `#1A1A1A` (dark)
- Top border: subtle divider (`#EFE5DF` light, `#2A2A2A` dark)

---

## 6) Motion System

### 6.1 Global Timing
- Default interaction: **200ms**
- Easing: `ease` (or cubic-bezier(0.2, 0, 0, 1) for refined motion)

### 6.2 Key Motions
- **Add to cart:** micro bounce
  - Scale 1 → 1.06 → 0.98 → 1 in 260ms
- **Page transitions:** fade + slide
  - Enter: opacity 0→1, translateY 8→0, 220ms
  - Exit: opacity 1→0, translateY 0→-8, 180ms
- **Button press:** scale to 0.98 over 100ms, release to 1 over 150ms

### 6.3 Accessibility
- Respect reduced-motion setting:
  - Disable bounce
  - Use opacity-only transitions (120ms)

---

## 7) Dark Mode Rules

- App background: `#0D0D0D`
- Cards/surfaces: `#1A1A1A`
- Primary text: `#EAEAEA`
- Keep brand colors unchanged for consistency.
- Increase border visibility on dark surfaces (`#2C2C2C` minimum).
- Shadow softness reduced (prefer overlays + contrast over heavy blur).

---

## 8) Iconography & Imagery

- Icon style: rounded, minimal, 2px optical stroke equivalent.
- Use filled icon state for active bottom-nav tab.
- Food images: warm white balance, high sharpness, avoid cluttered backgrounds.
- Use subtle gradient overlays for text on images when needed.

---

## 9) Accessibility Standards

- Minimum tap target: 44x44 px
- Maintain WCAG AA contrast for body text and critical controls.
- Provide visible focus ring (orange) on keyboard navigation.
- Support dynamic text scaling up to 120% without clipping.
- Ensure full RTL mirroring for Arabic layouts and icon direction where applicable.

---

## 10) Design Tokens (JSON Starter)

```json
{
  "color": {
    "brand": {
      "primary": "#E52B2B",
      "secondary": "#F28C28",
      "accent": "#F5C542",
      "highlight": "#2CA6A4"
    },
    "bg": {
      "light": "#FFF8F3",
      "dark": "#0D0D0D",
      "cardDark": "#1A1A1A"
    },
    "text": {
      "primary": "#1A1A1A",
      "secondary": "#6B6B6B",
      "white": "#FFFFFF",
      "softWhite": "#EAEAEA"
    }
  },
  "spacing": [4, 8, 12, 16, 20, 24, 32, 40],
  "radius": {
    "sm": 8,
    "md": 12,
    "lg": 16,
    "xl": 24,
    "pill": 999
  },
  "motion": {
    "durationDefault": 200,
    "easing": "ease"
  }
}
```

---

## 11) Screen-Level Application Checklist

- **Home:** hero promo, category chips, food cards with add-to-cart CTAs.
- **Orders:** segmented states (active/past), clear status chips.
- **Cart:** sticky checkout summary with primary CTA.
- **Favorites:** grid/list toggle with consistent card behavior.
- **Profile:** settings list, payment methods, addresses, language switch.

This design system is ready to implement in Figma variables and code design tokens for iOS, Android, and web.

---

## 12) UX Flow (احترافي — "يبيع فعلاً")

### 12.1 الهدف الرئيسي
- **الهدف:** المستخدم ينهي الطلب خلال **أقل من 30 ثانية** من لحظة فتح التطبيق.
- **قاعدة UX:** "Don’t make me think" — القرار يجب أن يكون ضغطة/ضغطتين بحد أقصى في كل خطوة.

### 12.2 Flow كامل من الدخول حتى ما بعد الطلب

#### 1) الدخول
- فتح التطبيق مباشرة على آخر حالة مستخدم.
- إذا أول مرة:
  - Onboarding سريع (2–3 شاشات فقط).
  - Skip واضح.
  - طلب صلاحيات الموقع في الوقت المناسب (عند اختيار العنوان، وليس قبل).

#### 2) الصفحة الرئيسية (Critical Screen)
**لازم تحتوي بشكل واضح وفوري:**
- Search في أعلى الشاشة مع Placeholder واضح.
- Categories أفقية سهلة التصفح.
- Best Sellers مباشرة في أول fold.

**قاعدة التنفيذ:**
- المستخدم لا يقرأ كثيراً… فقط يرى → يضغط → يضيف.

#### 3) اختيار الوجبة
- صورة كبيرة وجذابة.
- السعر + التقييم + Badge (إن وجد) في نفس البطاقة.
- زر **"إضافة"** مباشر داخل البطاقة بدون الدخول لصفحة التفاصيل.
- الدخول للتفاصيل يكون اختياري (للخيارات الإضافية فقط).

#### 4) Add to Cart Experience
- Animation قصيرة وسريعة (Micro-interaction).
- إظهار **Mini Cart** ثابت/عائم فوراً بعد الإضافة.
- CTA واضح: **"إكمال الطلب"**.
- تحديث عداد السلة لحظياً مع Feedback بصري.

#### 5) Checkout (One-screen checkout)
- أقل عدد خطوات ممكن:
  - Address محفوظ مسبقاً (مع خيار تغيير سريع).
  - Payment محفوظ مسبقاً (مع خيار تغيير سريع).
- ملخص الطلب واضح (Subtotal + Delivery + Tax + Total).
- زر أساسي واحد: **"تأكيد الطلب"**.

#### 6) بعد الطلب (Retention Screen)
- شاشة ممتعة فيها Animation + Progress للحالة.
- رسالة تأكيد مطمئنة + ETA واضح.
- Upsell مباشر بعد التأكيد: **"أضف مشروب"** أو إضافة خفيفة مرتبطة بالطلب.

### 12.3 Growth Tricks داخل UX
- ⭐ قسم **"الأكثر طلباً"** مثبت في الصفحة الرئيسية.
- 🔥 Badge **"Popular"** على العناصر عالية التحويل.
- ⏱️ Badge **"سريع التوصيل"** للعناصر الأسرع وصولاً.
- 🧠 Upsell ذكي داخل السلة/الدفع:
  - "أضف صوص بـ $1"
  - "أضف مشروب بخصم خاص"

### 12.4 Conversion Rules (قواعد ترفع البيع فعلياً)
- إظهار CTA الأساسي دائماً فوق الطي (above the fold).
- تقليل الاحتكاك: لا تسجيل إجباري قبل بناء السلة.
- تفضيل الإعدادات المحفوظة افتراضياً (العنوان/الدفع).
- إبقاء رحلة الطلب على **3 مراحل فقط**: Browse → Cart → Confirm.
- دعم العربية RTL بشكل كامل بدون كسر التسلسل البصري للخطوات.

