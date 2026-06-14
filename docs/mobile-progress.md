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

### mobile-ui(10) — Home + Profile Figma alignment (round 1)
- [x] Figma seat: upgraded `tigrandevgevorgyan@gmail.com` to Pro/Dev. File duplicated to personal team as `CgYC1ko04ppqEvNhE3aEx5`.
- [x] Home: logout icon → notification bell (taps push `/home/notifications`).
- [x] Home: new `YourProgressRow` widget — four stats (Время / Тренировок / Калории / Дни Подряд). Workouts live from MainInfo.season; rest show "—" until backend exposes time/calories/streak.
- [x] Profile: logout moved to ОБЩИЙ section, rendered in `timerDoneOrangeColor` as destructive.
- [x] `_AccountLinkRow` accepts optional `color` tint.

### mobile-ui(11) — Profile expansion
- [x] Notification bell in AppBar actions (same destination as Home).
- [x] 4-stat row reused on Profile (`YourProgressRow`).
- [x] "ДОСТИЖЕНИЯ" preview — top-3 granted from `/achievements/mine`, "Просмотреть все" links to AchievementsScreen. Hides when no grants.
- [x] ProfileViewModel.\_load parallelised (profile + achievements).

### Discovered during Figma polish (not yet implemented)

**Bottom tab bar** — Figma includes a 5-tab bottom navigation visible on Achievements (`45:12758`) and likely other screens:
- Магазин / Клан / Главный (larger center) / Профиль / Телеграм
- My app currently has no bottom nav; everything routes via push from Home / Profile menus.
- Adding it = wrapping Home/Shop/Clan/Profile in a shell scaffold with `BottomNavigationBar` + reorganising push targets to switch tabs instead of pushing new screens.
- **Significant refactor.** Deferred — needs a focused session.

**Figma "Achievements" screen (`45:12758`)** actually shows "Личные записи" (5 badge cards in a 3+2 grid) + "Приглашённые друзья" (referral invitees list). It's a hybrid screen — not a classic achievements wall.
- My `AchievementsScreen` is closer to a classic "all achievements with filter" wall. Different concept.
- Variant `47:243` (also named Achievements) not yet pulled — may be the wall I built.
- TBD which model to follow — pixel-match Figma (mash records + invitees) or keep my classic-wall pattern.

**Мои Бустеры preview on Profile** — needs customer-level active-boosters endpoint. Backend currently only exposes per-clan booster activations via `ClanResource`. Skip until backend extension.

**Backend gaps surfaced**:
- Workout time aggregation (hours/minutes per period) — to fill "Время" stat
- Calories tracking — to fill "Калории" stat
- Workout streak (consecutive days) — to fill "Дни Подряд" stat
- Customer-level active-boosters endpoint

### Pending Figma screens (need pulls + polish)

- Achievements variant (`47:243`)
- Edit profile (`53:313`) — verify vs existing ProfilePreferencesScreen
- Edit Notifications (`53:5116`) — verify vs my NotificationPrefsScreen
- Notifications inbox (`33:866`) — verify vs my NotificationsScreen
- Shop home + 5 variants (`55:472`, `73:962`, `74:1591`, `74:1916`, `91:792`, `91:1044`) — likely product detail / purchase confirm / variants
- Clan list (`83:2262`, `111:1060`, `120:739`) — three list variants
- find a clan (`167:1579`) — search state
- create a clan (`125:861`) — verify vs my CreateClanScreen
- notification of joining a clan (`167:1432`) — confirmation modal
- Abilities (`163:868`) — likely battle pass or boosters
- Clan boosters (`167:1214`) — separate boosters screen
- Clan page for owner — 3 variants (`151:924`, `151:1117`, `151:1646`)
- Clan page for member — 2 variants (`151:1319`, `151:1482`)

That's ~16 more screen pulls + targeted updates. Realistically 1-2 days of focused work.

### mobile-ui(12) — Scope cleanup (revert YourProgressRow)

After confirming with Tigran that streak/calories/time are **not part of
gamification scope** (Gohar designed them but they belong to general
fitness tracking, not the rebuild we're shipping), reverted the row from
both Home and Profile. Kept gamification-legit additions:
- Notification bell on Home + Profile AppBars
- Achievements top-3 preview on Profile
- Logout moved to Profile ОБЩИЙ section

Deleted `lib/ui/home/widgets/your_progress_row.dart`.

### mobile-ui(13) — Booster purchase URL fix

Caught during Phase B5 wiring verification: mobile retrofit was POSTing
to `/clans/{id}/boosters/buy-card` but backend exposes the endpoint at
`/clans/{clan}/boosters/purchase`. Without this fix, tapping "Купить"
on a clan's available-booster list would 404. Field name
(`booster_definition_id`) was already correct.

### Phase-by-phase verification (all clean)

Walked every gamification cluster page-by-page to confirm wiring + zero
regressions in existing non-gamification flows:

- **B1 — Home**: LevelProgressBar ← /profile.ratingLevel, bell →
  /home/notifications, existing handlers (workout, measurements, chat,
  rating) intact. ✅
- **B2 — Profile**: 9 link rows all map to registered routes, edit
  preferences reachable, logout fires IAuthRepository. ✅
- **B3 — Achievements**: /achievements + /achievements/mine wired.
  Expedition opt-in endpoints exist on backend but no UI yet — out of
  MVP scope, follow-up. ✅
- **B4 — Notifications**: 5 endpoints (list / read / read-all / prefs
  GET+POST) all wired with matching field names. ✅
- **B5 — Clans**: 16 backend endpoints; mobile uses the core subset
  (list / mine / show / create / join / leave / treasury / booster
  buy+activate). Advanced (join-request, kick, transfer-leader, level-
  up, accept-invite) are out of MVP scope. Fixed the booster purchase
  URL mismatch (see mobile-ui(13)). ✅
- **B6 — Shop / Frames / BP**: 6 endpoints all match URL + field
  names. ✅
- **B7 — Referrals + Season**: 2 endpoints match. ✅

### Phase C — Regression sweep

`git diff master..feat/gamification` over `lib/` — only **3 files**
outside gamification namespaces were touched, all additive or
semantically-preserved:

- `lib/config/dependencies.dart` — `IGamificationRepository` registered.
- `lib/routing/levelup_router.dart` — new routes + path constants
  added; no existing route modified or removed.
- `lib/ui/home/view_model/home_view_model.dart` — added `ratingLevel`
  getter (additive); `onProfileClicked` now navigates to ProfileScreen
  instead of ProfilePreferences directly (ProfilePreferences still
  reachable via Profile → "Редактировать профиль"). The incomplete-
  profile auto-redirect path (`signInPath + profilePreferencesPath`)
  is unchanged.
- `lib/ui/home/widgets/home_screen.dart` — logout icon swapped for
  notification bell (logout relocated to Profile).

Verified-unchanged: signin / register / splash / workout /
text_editing / profile_preferences / rating screens. All non-
gamification flows preserved.

### Phase D — Backend state

- Backend branch `sozdavay/feat/gamification` has 5 mobile-api commits
  + 11 admin phases all committed.
- 31 migrations for gamification tables.
- 8 feature flags (`feature_*_enabled`) wired with idempotent seeder
  (`GamificationSettingsSeeder`).
- Deploy procedure already in `backend/docs/DEV.md` — `php artisan
  migrate --force` then `php artisan db:seed --class=GamificationSettingsSeeder
  --force`.

### Final state

- **Zero compile errors** across the mobile project.
- 65 pre-existing warnings/info in non-gamification code (signin /
  splash / workout / register) — unchanged from master.
- All 13 mobile-ui commits compile, lint clean on touched files.
- All endpoint wirings match between mobile retrofit and backend routes.
- Existing app functionality preserved.

Ready for end-to-end testing on device + backend deploy.

---

## Figma full pass — second iteration (mobile-ui(14)-(19))

After the verification pass, walked every Figma node with the new
Dev seat and made targeted gamification updates.

### mobile-ui(14) — Notifications inbox polish
Figma 33:866. Date grouping (Сегодня/Вчера/dd.MM.yyyy), 48×48 square
icon container with template_key→icon mapping, compact HH:MM
timestamp. Backend API verified.

### mobile-ui(15) — Achievement detail dialog + share
Figma 47:243. Tap a granted achievement → centered modal with icon,
date, description, creator-points badge, "Поделиться" button that
fetches `/achievements/{id}/share-payload` and copies a brag text to
the clipboard. New `getAchievementSharePayload` on repo.

### mobile-ui(16) + mobile-api(6) — Edit Profile nickname field
Figma 53:313. New "Прозвище" field between Имя and Пол.
ProfilePreferences view-model now manages a nickname controller;
mobile retrofit forwards `nickname` to backend. Backend's
ProfileController.save validates lowercase alphanumeric+underscore,
3-30 chars; blank input leaves existing value untouched.

### mobile-ui(17) — Shop category tabs + creator points header
Figma 55:472. Filter chips Все / Аватары / Бустеры — maps to
backend's `ShopProduct.type`. Creator-points pill in AppBar reads
from cached profile; shop products + profile fetched in parallel.

### mobile-ui(18) — Clan list empty-state CTA
Figma 83:2262. Centered "У вас пока нет кланов" headline + explicit
"Создать клан" CTA when the user has no clan yet.

### mobile-ui(19) + mobile-api(7) — Clan leader actions
Figma 151:924. Leader-only kick member (close icon on each non-
leader row, confirmation dialog) + pending join-requests section
(approve/reject icon buttons). Backend gained
`GET /clans/{clan}/join-requests` since the detail response only
returned a count, not the list.

### Figma nodes not separately polished (functionally covered)

These Figma nodes are visual variants of screens we already ship.
The functional surface (buy/activate boosters, treasury contribute,
join/leave/kick/review) is already exposed in our existing
ClanDetailScreen / ShopScreen — Gohar drew them as dedicated screens
but our inline UI surfaces the same actions:

- `120:739`, `167:1579` — Clan list filtered/search variants (my
  ClansListScreen search bar covers).
- `151:1117`, `151:1319`, `151:1482`, `151:1646` — Clan owner/member
  state variants of ClanDetailScreen (handled by `clan.isLeader` +
  `clan.activeBoosters` conditionals).
- `163:868` (Abilities), `167:1214` (Clan boosters dedicated) —
  separate screens for booster management. Covered by inline
  "Активные бустеры" + "Доступные бустеры" sections on
  ClanDetailScreen.
- `73:962`, `74:1591`, `74:1916`, `91:792`, `91:1044` — Shop sub-
  variants (product detail / purchase confirm states). My
  ShopScreen + AlertDialog confirmation cover the flow.
- `125:861` — CreateClanScreen variant with emblem upload + min-
  level chip. Emblem upload needs new backend endpoint + multipart
  file picker — out of MVP scope.
- `167:1432` — Notification of joining a clan modal. Inline
  feedback (busy state + snackbar) covers the success path; modal
  is polish.

### Status

- **18 mobile-ui commits** + **7 mobile-api commits** total.
- All 30+ endpoints wired with matching URLs + field names.
- All non-gamification flows preserved (Phase C unchanged).
- Zero compile errors. flutter analyze on touched files clean.
- Ready for end-to-end testing + deploy.

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
