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

### mobile-ui(3+) — Profile, Clans, Shop, etc. — BLOCKED on Figma seat upgrade

Pending Figma pulls (need Dev seat — 22 screens left, **3 calls remaining this month** on View seat):
- [ ] Profile (`1:1573`)
- [ ] Achievements wall (`1:1719`)
- [ ] Edit profile (`1:1894`)
- [ ] Edit Notifications (`1:1955`)
- [ ] Clan screens — 13 variants (`1:1985` → `1:3532`)
- [ ] Shop screens — 5 variants (`1:3672` → `1:4524`)
- [ ] Notifications inbox (`1:4779`)

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
