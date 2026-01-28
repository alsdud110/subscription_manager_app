# 📱 Subscription Manager App - UI Visualization Guide

## Complete App Flow Overview

This document provides detailed descriptions of all screens and their visual appearance, organized by user flow.

---

## 🎬 Screen 1: Splash Screen

### Visual Description
```
┌─────────────────────────────────────┐
│                                     │
│     [Gradient Background]           │
│     (Blue → Purple gradient)        │
│                                     │
│          ┌─────────┐                │
│          │         │                │
│          │   📅    │  ← White rounded box
│          │         │     with calendar icon
│          └─────────┘                │
│                                     │
│    Subscription Manager             │
│    (Large, Bold, White)             │
│                                     │
│  Manage your subscriptions easily   │
│    (Smaller, White70)               │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

**Key Features:**
- Full-screen gradient background
- Center-aligned content
- 150x150 white rounded container
- 80px calendar icon (blue)
- Auto-navigates after 3 seconds
- Smooth fade transition

---

## 🏠 Screen 2: Home Screen (Light Theme)

### Visual Layout
```
┌─────────────────────────────────────┐
│  🌙  Subscription Manager      ➕   │ ← AppBar
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │  🔽 January 2026         📅 │   │
│  ├─────────────────────────────┤   │
│  │ Mon Tue Wed Thu Fri Sat Sun │   │
│  │  1   2   3   4   5   6   7  │   │
│  │  8   9  10  11  12  13  14  │   │
│  │ 15● 16  17  18  19  20  21  │   │ ← Dots mark subscription dates
│  │ 22  23  24  25● 26  27  28  │   │
│  │ 29  30  31                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅  Weekly Total            │   │
│  │     ₩27,000                 │   │ ← Blue gradient card
│  │     $14.99                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📆  Monthly Total           │   │
│  │     ₩89,500                 │   │ ← Green gradient card
│  │     $29.98                  │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Key Elements:**
- **AppBar**: Moon icon (left), title (center), + button (right)
- **Calendar**: 
  - Month/year display with dropdown
  - Week/Month format toggle
  - Blue dots on dates with subscriptions
  - Today highlighted with light blue circle
  - Selected date with solid blue circle
- **Summary Cards**:
  - Weekly Total: Blue gradient, calendar_view_week icon
  - Monthly Total: Green gradient, calendar_month icon
  - Shows both KRW and USD totals
  - Large, bold amounts

---

## 🌙 Screen 3: Home Screen (Dark Theme)

### Visual Layout
```
┌─────────────────────────────────────┐
│  ☀️  Subscription Manager      ➕   │ ← Dark AppBar
├─────────────────────────────────────┤
│  [Dark Background: #121212]         │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  🔽 January 2026         📅 │   │
│  ├─────────────────────────────┤   │
│  │ Mon Tue Wed Thu Fri Sat Sun │   │
│  │  1   2   3   4   5   6   7  │   │ ← White text on dark
│  │  8   9  10  11  12  13  14  │   │
│  │ 15● 16  17  18  19  20  21  │   │
│  │ 22  23  24  25● 26  27  28  │   │
│  │ 29  30  31                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅  Weekly Total            │   │
│  │     ₩27,000                 │   │ ← Dark blue card
│  │     $14.99                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📆  Monthly Total           │   │
│  │     ₩89,500                 │   │ ← Dark green card
│  │     $29.98                  │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Theme Differences:**
- Dark background (#121212)
- Sun icon instead of moon
- Lighter text colors
- Darker card backgrounds
- Higher contrast for accessibility
- Same layout as light theme

---

## ➕ Screen 4: Add Subscription Screen

### Visual Layout
```
┌─────────────────────────────────────┐
│  ⬅ Add Subscription                │ ← AppBar with back button
├─────────────────────────────────────┤
│                                     │
│  Select Service                     │
│  ┌────────┬────────┬────────────┐   │
│  │🎬 Netflix│🛒 Coupang│▶️ YouTube│ │ ← Service chips (chips wrap)
│  ├────────┴────────┴────────────┤   │
│  │🏰 Disney+│🎵 Spotify│🎶 Apple  │ │
│  ├────────┬────────┬────────────┤   │
│  │📦 Amazon│🎞️ Watcha│📺 Wavve   │ │
│  ├────────┴────────┴────────────┤   │
│  │🎭 Tving │💳 Custom            │ │
│  └────────────────────────────────┘ │
│                                     │
│  [If Custom selected]               │
│  ┌─────────────────────────────┐   │
│  │ Custom Service Name         │   │
│  │ [User input field]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  Price                              │
│  ┌──────────────────┬─────────┐    │
│  │ Amount           │  ₩  $   │    │ ← Amount input + Currency toggle
│  │ [13500]          │ [₩][  ] │    │
│  └──────────────────┴─────────┘    │
│                                     │
│  Billing Cycle                      │
│  ┌─────────────────────────────┐   │
│  │[Weekly][Monthly][Yearly]    │   │ ← Segmented buttons
│  └─────────────────────────────┘   │
│                                     │
│  Select Day of Month                │
│  ┌─────────────────────────────┐   │
│  │ [Dropdown: 15]          🔽  │   │ ← Day selector (1-31)
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Add Subscription          │   │ ← Large button
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Form Sections:**

1. **Service Selection**:
   - Choice chips with emoji icons
   - Selected chip highlighted
   - Custom option shows text field

2. **Price Input**:
   - Number input field (left)
   - Currency toggle buttons (right): ₩ and $
   - Selected currency highlighted in blue

3. **Billing Cycle**:
   - Three segmented buttons
   - Weekly / Monthly / Yearly
   - Selected option highlighted

4. **Date Selection** (varies by cycle):
   - **Weekly**: Dropdown with days (Monday-Sunday)
   - **Monthly**: Dropdown with dates (1-31)
   - **Yearly**: Two dropdowns (Month + Day)

5. **Submit Button**:
   - Full-width elevated button
   - Blue background
   - "Add Subscription" text

---

## 📋 Screen 5: Bottom Modal Sheet (Subscription List)

### Visual Layout
```
│                                     │
├─────────────────────────────────────┤ ← Slides up from bottom
│  January 15, 2026              ✕   │ ← Date header + close button
│  2 subscription(s)                  │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ ┌───┐                         │ │
│  │ │🎬 │ Netflix                 │ │ ← Subscription item
│  │ └───┘ Every 15th of the month │ │
│  │       ₩13,500            🗑️   │ │ ← Amount + Delete button
│  └───────────────────────────────┘ │
│                                     │
│  ─────────────────────────────────  │ ← Divider
│                                     │
│  ┌───────────────────────────────┐ │
│  │ ┌───┐                         │ │
│  │ │🎵 │ Spotify                 │ │
│  │ └───┘ Every 15th of the month │ │
│  │       ₩10,900            🗑️   │ │
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Key Features:**
- Rounded top corners (20px)
- Scrollable list if many subscriptions
- Each subscription shows:
  - Service icon in colored box (50x50)
  - Service name (bold, 16px)
  - Billing info (gray, 12px)
  - Amount in colored text (primary color, bold, 16px)
  - Delete icon button (red)
- Dividers between items
- Close button in header

### Delete Confirmation Dialog
```
        ┌─────────────────────────┐
        │ Delete Subscription     │
        ├─────────────────────────┤
        │ Are you sure you want   │
        │ to delete "Netflix"?    │
        │                         │
        │   [Cancel]   [Delete]   │
        └─────────────────────────┘
```

---

## 🎨 Color Scheme

### Light Theme
- **Primary**: Blue (#2196F3)
- **Background**: White (#FFFFFF)
- **Surface**: Light Gray (#F5F5F5)
- **Text**: Dark Gray (#212121)
- **Accent**: Various service colors

### Dark Theme
- **Primary**: Light Blue (#64B5F6)
- **Background**: Very Dark Gray (#121212)
- **Surface**: Dark Gray (#1E1E1E)
- **Text**: White (#FFFFFF)
- **Accent**: Same service colors with higher contrast

---

## 📐 Typography

- **Title**: 28px, Bold (Splash screen)
- **AppBar Title**: 20px, Medium
- **Section Headers**: 18px, Bold
- **Body Text**: 16px, Regular
- **Small Text**: 14px, Regular
- **Captions**: 12px, Regular
- **Amounts**: 24px, Bold (summary), 16px, Bold (list)

---

## 🎭 Animations & Transitions

1. **Splash → Home**: Fade transition (300ms)
2. **Theme Toggle**: Smooth color transition (200ms)
3. **Calendar Date Selection**: Scale + color change
4. **Bottom Sheet**: Slide up from bottom (250ms)
5. **Screen Navigation**: Material slide transition
6. **Delete Action**: Fade out (150ms)
7. **Add Subscription**: Scale button press effect

---

## 💡 Interactive Elements

### Buttons
- **Elevated Button**: Shadow, press effect
- **Icon Button**: Circular ripple
- **Choice Chip**: Selected state with color
- **Segmented Button**: Solid fill when selected

### Cards
- **Elevation**: 2-4dp
- **Corner Radius**: 12px
- **Padding**: 16-20px
- **Gradient**: Light to lighter shade

### Calendar
- **Dots**: 6px diameter, primary color
- **Selected Date**: Circle background
- **Today**: Light circle background
- **Tap Ripple**: Circular expand from center

---

## 📱 Responsive Design

### Phone (< 600px)
- Single column layout
- Full-width cards
- Compact padding (16px)
- 3-4 service chips per row

### Tablet (≥ 600px)
- Same layout (optimized for phone)
- Larger touch targets
- More spacing

---

## ♿ Accessibility

- **Contrast Ratio**: WCAG AA compliant
- **Touch Targets**: Minimum 48x48dp
- **Text Size**: Scalable with system settings
- **Semantic Labels**: Proper widget labeling
- **Screen Reader**: Full support

---

## 🔄 User Flow Summary

```
1. App Launch
   ↓
2. Splash Screen (3s)
   ↓
3. Home Screen
   ├─→ Toggle Theme (Moon/Sun icon)
   ├─→ Add Subscription (+)
   │   ├─→ Select Service
   │   ├─→ Enter Price & Currency
   │   ├─→ Choose Billing Cycle
   │   ├─→ Select Date/Day
   │   └─→ Save → Return to Home
   └─→ Tap Calendar Date
       └─→ Bottom Sheet Opens
           ├─→ View Subscriptions
           └─→ Delete Subscription
               └─→ Confirm → Update Calendar
```

---

## 🎯 Key Visual Principles

1. **Consistency**: Same patterns throughout
2. **Clarity**: Clear visual hierarchy
3. **Feedback**: Visual response to all actions
4. **Simplicity**: Minimal cognitive load
5. **Delight**: Smooth animations and transitions

---

## 📸 Screenshot Checklist

If you want to capture these screens:

- [ ] Splash screen during fade-in
- [ ] Home screen (Light) with subscriptions
- [ ] Home screen (Light) with summary totals
- [ ] Home screen (Dark) - same view
- [ ] Add Subscription - service selection
- [ ] Add Subscription - filled form
- [ ] Add Subscription - weekly cycle option
- [ ] Add Subscription - yearly cycle option
- [ ] Bottom Modal - subscription list
- [ ] Bottom Modal - delete confirmation
- [ ] Calendar with multiple dots
- [ ] Summary cards with mixed currencies

---

**All screens are fully functional and ready to use!** 🚀

Run `flutter run` to see them in action.
