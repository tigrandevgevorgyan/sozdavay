# Sozdavay mobile — gamification work tracker

Companion to backend `docs/sozdavay-mobile-plan.md` (which tracks Stream A — the API surface).
This doc tracks the Flutter side (Stream B).

**Branch:** `feat/gamification`
**Designer (Figma):** Gohar — file `gYweMWgPsdFah0suXk6ZY8`
**Style rule:** match Gohar's *layout/structure*, but **keep existing app's tokens** (Ablation/Outfit fonts, current colors, current button/component patterns). Don't introduce Montserrat.

## Figma access

- ✅ File shared with `tigran@partao.com`.
- ⚠️ Seat is still **View** in both Figma plans (6 tool calls/month). Need **Dev/Full seat** for sustainable screen pulls (~30 screens × 1 call each).
- 25 screens identified in the file. Inventory in commit message of mobile-ui(1).

## Commits

### mobile-ui(1) — data foundation
- [x] Extended `UserProfile` model with gamification fields (nickname, avatar_url, equipped_avatar_frame_id, creator_points, account_level, shop_discount_percent, rating_balance, rating_level, referral_code). All nullable — model still parses against legacy backend responses.
- [x] New `RatingLevelSummary` model (mirrors backend `RatingLevelService::summary()`).
- [x] New `RatingBalanceResponse` model.
- [x] New `GamificationService` retrofit interface (currently exposes `GET /rating/balance`; will expand as screens land).
- [x] New `IGamificationRepository` + `GamificationRepository` implementation.
- [x] DI registration in `lib/config/dependencies.dart`.
- [x] `dart run build_runner build` ran clean — 38 outputs.
- [x] `flutter analyze` on touched files — no issues.

### mobile-ui(2) — Home: level progress bar
- [x] New widget `LevelProgressBar` — header strip with "Уровень N из 34 · {label}" + linear progress + "До «next»: N" subtitle. Returns SizedBox.shrink when profile hasn't loaded.
- [x] `HomeViewModel.ratingLevel` getter exposes the gamification block.
- [x] Inserted into `home_screen.dart` between AppBar and CalendarWidget (Gohar's layout order).
- [x] flutter analyze on touched files — clean.
- [~] Other Home design additions (circular rating ring, 4-stat "Ваш прогресс" row, mini leaderboard) — deferred. Existing widgets (StatisticsTileWidget, top3_rating_widget) cover most of these patterns; will iterate after Nikita reviews this slice.

### mobile-ui(3) — Profile hub
- [x] Pulled Profile design from Figma (`1:1573`) via `get_design_context` — used 1 of 3 remaining View-seat calls.
- [x] New `ProfileScreen` + `ProfileViewModel` under `lib/ui/profile/`. Layout matches Gohar's structure (header / avatar+name / level card / account links) but renders with app tokens (Ablation, Outfit, AppColors).
- [x] `_AvatarAndName`: 89px circular avatar with subtle border, network-image fallback to placeholder icon, displayName uppercase, creator-points pill with formatted thousand-separator.
- [x] `_LevelCard`: "УРОВЕНЬ N ИЗ 34 · {label}" header + "{points} баллов до следующего уровня" subtitle + level badges (current vs next) flanking the progress bar + "{in} / {total}" indicator. Max-level state collapses to a single line.
- [x] `_AccountLinkRow` with chevron — pattern Gohar uses for "Редактировать профиль", "Уведомление", "Поддерживать".
- [x] Wired entry point: changed Home gear icon → ProfileScreen (was → ProfilePreferences directly). ProfileScreen has "Редактировать профиль" link that opens ProfilePreferences (preserves the legacy edit form).
- [x] Route registered as `/home/profile` (extra: `bool hasWorkoutPlan`).
- [x] flutter analyze on touched files — clean. 9 pre-existing HomeViewModel warnings unrelated.
- [~] Deferred to later commits (in-scope per Gohar but bigger surface):
  - 4-stat row (Time / Workouts / Calories / Streak) — needs new backend fields (streak, calories). Workouts-per-month is already in MainInfo; rest would need server-side additions or design simplification.
  - Achievements wall preview (3 cards) — needs `/achievements/mine` call + asset/icon mapping.
  - Мои Бустеры (3 cards) — needs shop integration + active-booster query.
  - Notifications inbox row — needs `/notifications` UI built.

### mobile-ui(4) — full GamificationService surface
- [x] Retrofit interface + Repository wrapper for every Stream A endpoint
- [x] 8 new model clusters: achievement, clan, shop_product, avatar_frame, battle_pass, notification, season_current, referral
- [x] build_runner ran clean — 18 outputs

### mobile-ui(5) — Achievements wall
- [x] Pulled Figma `1:1719` skipped — extrapolated from Profile preview card pattern. Saves call for clans/shop later.
- [x] AchievementsScreen with summary header, filter row (Все / Получены / Доступны), 2-column grid of cards
- [x] Card shape: rounded icon, name, short description, creator-points reward badge; locked state fades icon + swaps to lock glyph
- [x] Wired from Profile → `/home/achievements`

### mobile-ui(6) — Notifications inbox + prefs
- [x] NotificationsScreen — inbox list, unread = green dot + active border, optimistic mark-read on tap, "Прочитать всё" bulk action
- [x] NotificationPrefsScreen — channel × type grid with switches, fires POST optimistically and reverts on failure
- [x] Russian labels for channels (push / in_app) and 6 notification types
- [x] Routes `/home/notifications` and `/home/notification_prefs`

### mobile-ui(7) — Clans (list + detail + create)
- [x] ClansListScreen — search bar (300ms debounce), 2-column tile, "Мой" badge on my clan, FAB '+' only when not in a clan
- [x] ClanDetailScreen — header, treasury card (with "Пополнить" for members, min 50 dialog), members list with leader badge + contribution, active boosters, available boosters (leader-only "Купить"), join/leave action
- [x] CreateClanScreen — name + description + 3-option join policy radio; pops on success and pushes the new clan
- [x] Three view models with optimistic state where useful

### mobile-ui(8) — Shop + frames + battle pass
- [x] ShopScreen — grid with VIP badge, discount badge, struck-through original price + green discounted price; confirm dialog on purchase
- [x] FramesScreen — owned frames grid with equip toggle (one-equipped invariant enforced server-side)
- [x] BattlePassScreen — VIP header, tier rows with free + VIP slots (claimed / claimable / locked / empty states), claim flow

### mobile-ui(9) — Referrals + Season
- [x] ReferralsScreen — code card with copy action, referrer block if any, invitee list with joined date; feature-disabled fallback panel
- [x] SeasonScreen — season header, my-progress card (rating / level / draw eligibility), reward list with rank badges; null-state when no active season

### Deferred — Profile final polish
- [~] 4-stat row (Time / Workouts / Calories / Streak) — Workouts is available via MainInfo, but streak + calories are not yet exposed by the backend. Will add when those fields land.
- [~] Achievements preview row on Profile — easy to add (uses `/achievements/mine`), but ProfileViewModel currently only reads cached UserProfile. Add when next iterating Profile.
- [~] Boosters preview row on Profile — needs active-clan-boosters query at the customer level (not just per-clan); revisit.
- [~] Notification bell with unread badge on Profile header — easy add, depends on a notifications "summary" call we haven't introduced yet.

These are visual additions, not blockers — the screens themselves are reachable via the explicit links in Profile's ИГРОФИКАЦИЯ + СЧЕТ sections.

**Not in Figma** (descope or later iteration): battle pass, season progress, leaderboards full screen, referrals page. Welcome/Onboarding confirmed dropped by Nikita.

## Open questions for Nikita

Carried from §11 of the gamification plan — most have working defaults that are visible in this work:
- Account level 8 thresholds — seeded `0/50/150/400/1000/2500/6000/15000`. Real numbers TBD.
- Level-up share image — backend returns payload; mobile renders (deferred to later screens).
- Avatar frame + clan booster stacking order — design implies single stack; confirm in mobile UX.

## Notes for the next agent

1. **Read backend `docs/sozdavay-mobile-plan.md` first** — that's the full API surface (30 endpoints, all live).
2. **`docs/sozdavay-gamification-plan.md`** in backend has architecture decisions.
3. After editing any json_serializable model or retrofit service: `dart run build_runner build --delete-conflicting-outputs`.
4. For Flutter compiles/analysis: `flutter analyze` (no full build needed for backend work, but useful before commits).
5. Existing design tokens: `lib/ui/core/themes/app_colors.dart` + `lib/ui/core/themes/text_styles.dart`. Don't add new fonts without checking pubspec/assets first.
6. Existing common widgets: `lib/ui/core/common_widgets/` — reuse `LevelUpButton`, `LevelUpContainer`, `LevelUpTextField`, `LevelUpLoader`, etc.
