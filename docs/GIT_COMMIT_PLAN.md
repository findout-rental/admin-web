# Git Commit Plan - Flutter Admin Web

**Date:** December 2024  
**Branch:** main  
**Status:** Ready for staged commits

---

## 📋 Current Git Status

```
Modified files:
- lib/main.dart
- pubspec.yaml
- test/widget_test.dart

Untracked files:
- lib/app/ (entire directory)
- lib/core/ (entire directory)
- lib/data/ (entire directory)
- lib/domain/ (entire directory)
- lib/presentation/ (entire directory)
```

---

## 🎯 Commit Strategy

**Approach:** Categorical commits for better history and review  
**Total Commits:** 7 commits (6 feature commits + 1 config commit)

---

## 📦 Commit Categories

### Commit 1: Core Infrastructure & Configuration
**Message:** `feat: add core infrastructure and project configuration`

**Files:**
```
lib/core/
  - constants/
  - network/
  - storage/
  - theme/
  - utils/
lib/app/
  - app.dart
lib/main.dart
pubspec.yaml
```

**Description:**
- Core network layer (API client, interceptors, exceptions)
- Theme system (light/dark mode)
- Storage utilities
- Constants (API endpoints, storage keys)
- Utilities (validators, formatters, date utils)
- App configuration
- Dependencies in pubspec.yaml

**Why separate:** Foundation of the application, no business logic

---

### Commit 2: Domain Layer (Entities, Repositories, Use Cases)
**Message:** `feat: implement domain layer with entities, repositories, and use cases`

**Files:**
```
lib/domain/
  - entities/
  - repositories/
  - usecases/
```

**Description:**
- All domain entities (User, Apartment, Booking, etc.)
- Repository interfaces
- All use cases (business logic)
- Domain-driven design structure

**Why separate:** Pure business logic, no dependencies on data or presentation

---

### Commit 3: Data Layer (Models, Data Sources, Repositories)
**Message:** `feat: implement data layer with models, data sources, and repository implementations`

**Files:**
```
lib/data/
  - models/
  - datasources/
  - repositories/
```

**Description:**
- Data models with JSON serialization
- Remote and local data sources
- Repository implementations
- API integration layer

**Why separate:** Data access layer, depends on domain but not presentation

---

### Commit 4: Authentication & Layout Components
**Message:** `feat: implement authentication and common layout components`

**Files:**
```
lib/presentation/
  - pages/auth/
  - controllers/auth/
  - widgets/layout/
  - widgets/auth/
lib/app/
  - middleware/
  - bindings/initial_binding.dart (auth-related parts)
```

**Description:**
- Login page
- Auth controllers
- Auth guard
- App scaffold
- Sidebar navigation
- Top app bar
- Breadcrumbs
- Auth middleware

**Why separate:** Core authentication and layout, used by all other features

---

### Commit 5: Dashboard & Registration Management
**Message:** `feat: implement dashboard and registration management features`

**Files:**
```
lib/presentation/
  - pages/dashboard/
  - controllers/dashboard/
  - pages/pending_registrations/
  - controllers/registration/
  - widgets/cards/
lib/data/
  - datasources/remote/dashboard_remote_datasource.dart
  - datasources/remote/registration_remote_datasource.dart
  - repositories/dashboard_repository_impl.dart
  - repositories/registration_repository_impl.dart
lib/domain/
  - usecases/dashboard/
  - usecases/registration/
lib/app/bindings/initial_binding.dart (dashboard & registration parts)
```

**Description:**
- Dashboard page with statistics
- Pending registrations list
- Registration approval/rejection
- Stat cards widget

**Why separate:** First major feature set, logically grouped

---

### Commit 6: User Management & Content Overview
**Message:** `feat: implement user management and content overview features`

**Files:**
```
lib/presentation/
  - pages/users/
  - controllers/user/
  - pages/apartments/
  - controllers/apartment/
  - pages/bookings/
  - controllers/booking/
lib/data/
  - datasources/remote/user_remote_datasource.dart
  - datasources/remote/apartment_remote_datasource.dart
  - datasources/remote/booking_remote_datasource.dart
  - repositories/user_repository_impl.dart
  - repositories/apartment_repository_impl.dart
  - repositories/booking_repository_impl.dart
lib/domain/
  - usecases/user/
  - usecases/apartment/
  - usecases/booking/
lib/app/bindings/initial_binding.dart (user, apartment, booking parts)
lib/app/routes/app_pages.dart
```

**Description:**
- All users page (master-detail)
- User management (delete, deposit, withdraw)
- All apartments page
- All bookings page
- Routes configuration

**Why separate:** Major feature set, user-facing functionality

---

### Commit 7: Settings & Final Configuration
**Message:** `feat: implement settings pages and complete app configuration`

**Files:**
```
lib/presentation/
  - pages/settings/
  - controllers/settings/
lib/data/
  - datasources/remote/profile_remote_datasource.dart
  - repositories/profile_repository_impl.dart
lib/domain/
  - usecases/profile/
lib/app/bindings/initial_binding.dart (profile parts)
test/widget_test.dart (if modified)
```

**Description:**
- Profile settings page
- Language settings page
- Theme settings page
- Profile management
- Complete dependency injection setup

**Why separate:** Settings feature, final configuration

---

## 🚀 Execution Commands

### Option A: Manual Staging (Recommended)

```bash
# Commit 1: Core Infrastructure
git add lib/core/ lib/app/app.dart lib/main.dart pubspec.yaml
git commit -m "feat: add core infrastructure and project configuration

- Add API client with interceptors and exception handling
- Implement theme system with light/dark mode support
- Add storage utilities and constants
- Configure app structure and dependencies"

# Commit 2: Domain Layer
git add lib/domain/
git commit -m "feat: implement domain layer with entities, repositories, and use cases

- Add all domain entities (User, Apartment, Booking, etc.)
- Implement repository interfaces
- Add all business logic use cases
- Follow domain-driven design architecture"

# Commit 3: Data Layer
git add lib/data/
git commit -m "feat: implement data layer with models, data sources, and repository implementations

- Add data models with JSON serialization
- Implement remote and local data sources
- Add repository implementations
- Complete API integration layer"

# Commit 4: Authentication & Layout
git add lib/presentation/pages/auth/ lib/presentation/controllers/auth/ lib/presentation/widgets/layout/ lib/presentation/widgets/auth/ lib/app/middleware/ lib/app/bindings/initial_binding.dart
git commit -m "feat: implement authentication and common layout components

- Add login page with split-screen design
- Implement auth controllers and guards
- Add app scaffold with sidebar and top app bar
- Add breadcrumb navigation
- Configure auth middleware"

# Commit 5: Dashboard & Registration
git add lib/presentation/pages/dashboard/ lib/presentation/controllers/dashboard/ lib/presentation/pages/pending_registrations/ lib/presentation/controllers/registration/ lib/presentation/widgets/cards/ lib/data/datasources/remote/dashboard_remote_datasource.dart lib/data/datasources/remote/registration_remote_datasource.dart lib/data/repositories/dashboard_repository_impl.dart lib/data/repositories/registration_repository_impl.dart
git commit -m "feat: implement dashboard and registration management features

- Add dashboard page with statistics cards
- Implement pending registrations list with modern UI
- Add registration approval/rejection functionality
- Add stat card widget"

# Commit 6: User Management & Content
git add lib/presentation/pages/users/ lib/presentation/controllers/user/ lib/presentation/pages/apartments/ lib/presentation/controllers/apartment/ lib/presentation/pages/bookings/ lib/presentation/controllers/booking/ lib/data/datasources/remote/user_remote_datasource.dart lib/data/datasources/remote/apartment_remote_datasource.dart lib/data/datasources/remote/booking_remote_datasource.dart lib/data/repositories/user_repository_impl.dart lib/data/repositories/apartment_repository_impl.dart lib/data/repositories/booking_repository_impl.dart lib/app/routes/app_pages.dart
git commit -m "feat: implement user management and content overview features

- Add all users page with master-detail layout
- Implement user management (delete, deposit, withdraw)
- Add all apartments and bookings pages with modern UI
- Configure all routes"

# Commit 7: Settings & Final Config
git add lib/presentation/pages/settings/ lib/presentation/controllers/settings/ lib/data/datasources/remote/profile_remote_datasource.dart lib/data/repositories/profile_repository_impl.dart test/widget_test.dart
git commit -m "feat: implement settings pages and complete app configuration

- Add profile, language, and theme settings pages
- Complete dependency injection setup
- Finalize app configuration"
```

### Option B: Using Git Add with Patterns

```bash
# Commit 1
git add lib/core/ lib/app/app.dart lib/main.dart pubspec.yaml
git commit -m "feat: add core infrastructure and project configuration"

# Commit 2
git add lib/domain/
git commit -m "feat: implement domain layer with entities, repositories, and use cases"

# Commit 3
git add lib/data/
git commit -m "feat: implement data layer with models, data sources, and repository implementations"

# Commit 4
git add lib/presentation/pages/auth/ lib/presentation/controllers/auth/ lib/presentation/widgets/ lib/app/middleware/ lib/app/bindings/
git commit -m "feat: implement authentication and common layout components"

# Commit 5
git add lib/presentation/pages/dashboard/ lib/presentation/pages/pending_registrations/ lib/presentation/controllers/dashboard/ lib/presentation/controllers/registration/ lib/presentation/widgets/cards/
git commit -m "feat: implement dashboard and registration management features"

# Commit 6
git add lib/presentation/pages/users/ lib/presentation/pages/apartments/ lib/presentation/pages/bookings/ lib/presentation/controllers/user/ lib/presentation/controllers/apartment/ lib/presentation/controllers/booking/ lib/app/routes/
git commit -m "feat: implement user management and content overview features"

# Commit 7
git add lib/presentation/pages/settings/ lib/presentation/controllers/settings/ test/
git commit -m "feat: implement settings pages and complete app configuration"
```

---

## ⚠️ Important Notes

### Before Committing:

1. **Check for Sensitive Data:**
   ```bash
   # Search for potential secrets
   grep -r "password\|secret\|key\|token" lib/ --include="*.dart" | grep -v "//\|StorageKeys\|ApiConstants"
   ```

2. **Verify No Hardcoded Credentials:**
   - Check `lib/core/constants/api_constants.dart` - should use environment variables or config
   - Check `lib/core/network/api_client.dart` - no hardcoded tokens
   - Check all data sources - no hardcoded API keys

3. **Review .gitignore:**
   ```bash
   # Ensure these are in .gitignore:
   - .env
   - .env.local
   - *.key
   - *.pem
   - build/
   - .dart_tool/
   ```

4. **Run Linter:**
   ```bash
   flutter analyze
   ```

5. **Check for TODO Comments:**
   - TODOs are fine to commit (they're tracked in documentation)
   - But review if any contain sensitive information

---

## 🔍 Pre-Commit Checklist

- [ ] No hardcoded API keys or secrets
- [ ] No sensitive user data in code
- [ ] All files follow project structure
- [ ] No large binary files
- [ ] .gitignore is properly configured
- [ ] Code passes linter checks
- [ ] Commit messages are descriptive
- [ ] Files are logically grouped

---

## 📝 Commit Message Format

**Format:**
```
feat: brief description

- Detailed point 1
- Detailed point 2
- Detailed point 3
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Tests
- `chore:` - Maintenance tasks

---

## 🚨 What NOT to Commit

- ❌ `.env` files
- ❌ API keys or secrets
- ❌ Hardcoded credentials
- ❌ Personal notes or TODOs with sensitive info
- ❌ Large binary files
- ❌ Build artifacts (`build/`, `.dart_tool/`)
- ❌ IDE-specific files (if not in .gitignore)

---

## ✅ After Committing

1. **Review Commit History:**
   ```bash
   git log --oneline
   ```

2. **Verify All Files Committed:**
   ```bash
   git status
   ```

3. **Push to Remote (if ready):**
   ```bash
   git push origin main
   ```

---

## 📋 Summary

**Total Commits:** 7  
**Approach:** Categorical commits for clean history  
**Estimated Time:** 10-15 minutes

**Benefits:**
- Clean, readable git history
- Easy to review changes
- Easy to revert specific features if needed
- Better collaboration
- Follows best practices

---

**Ready to commit?** Follow the execution commands above.

