# SwiftPokedex — Architecture

This document defines how the codebase is structured and what to verify before each commit.

---

## Project layout

```text
SwiftPokedex/
├── App/                          Composition root (SwiftPokedexApp, AppContainer)
├── Core/
│   ├── Networking/               APIClient, APIClientProtocol, APIConfiguration, APIError
│   ├── Errors/                   UserFacingError
│   ├── Logging/                  AppLog (debug-only)
│   ├── Localization/             L10n, LocaleFormatting, API names, ResourceEnrichment
│   └── Presentation/             LoadState, LoadTaskRunner
│
│   Resources/
│   └── Localizable.xcstrings     App UI strings (en, fr, de)
├── Data/
│   ├── Common/                   Shared DTOs (PagedListDTO, NamedResourceDTO, LocalizedNameDTO, ResourceURLParser)
│   └── <Resource>/               Per API resource
│       ├── DTO/
│       ├── *Endpoints.swift
│       ├── *Mapper.swift
│       └── Remote*Repository.swift
└── Features/
    └── <Feature>/
        ├── Domain/               Entities, *RepositoryProtocol, domain-only types
        └── Presentation/         View, ViewModel
```

### Dependency rule (mandatory)

```text
Presentation  →  Domain  ←  Data  →  Core
```

- **Never** import Data or Presentation from Domain.
- **Never** import Presentation from Data.
- **Never** put feature-specific types in Core.

---

## Pre-commit checklist

### 1. Layers & feature modularization (Clean Architecture)

- [ ] UI lives under `Features/<Feature>/Presentation/`.
- [ ] Domain entities and repository **protocols** live under `Features/<Feature>/Domain/` (or shared Domain when used by multiple features).
- [ ] DTOs, endpoints, mappers, and `Remote*Repository` live under `Data/<Resource>/`.
- [ ] Shared API list shapes use `Data/Common/` (e.g. `PagedListDTO`, `NamedResourceDTO`, `LocalizedNameDTO`).
- [ ] Localized display names use `Core/Localization/` — do not duplicate resolver/enrichment logic per feature.
- [ ] Shared app-wide HTTP config uses `Core/Networking/APIConfiguration` (single `baseURL`); resource paths stay in `Data/*/Endpoints`.
- [ ] Dependencies respect the inward rule above.

### 2. Protocol-oriented design

- [ ] Boundaries are defined by protocols: `APIClientProtocol`, `*RepositoryProtocol`.
- [ ] Protocols are named with a `Protocol` suffix (e.g. `PokemonRepositoryProtocol`).
- [ ] Implementations are concrete: `APIClient`, `RemotePokemonRepository`, `RemoteGenerationRepository`.
- [ ] View models and repositories depend on `any SomeProtocol`, not concrete remote types.

### 3. Repository pattern

- [ ] View models call repository protocols only — no `APIClient`, `URLSession`, `JSONDecoder`, or URL building in VMs/views.
- [ ] Repository implementations fetch DTOs, then map to domain models before returning.
- [ ] Domain types are not `Decodable` and do not mirror JSON field names.
- [ ] Mapping lives in `Data/<Resource>/*Mapper.swift`, not in Domain or Presentation.

### 4. Dependency injection

- [ ] Dependencies are not constructed inside views or view models (`Repository()`, `APIClient()` forbidden there).
- [ ] Wiring is centralized in `AppContainer` (composition root).
- [ ] View models receive protocols via `init(repository:)` (and similar).
- [ ] Views receive view models via `init(viewModel:)` from `AppContainer` factories.
- [ ] Tests inject `Mock*Repository` / `MockAPIClient` via initializers or `AppContainer` test init.

### 5. MVVM

- [ ] **Views:** layout, bindings, navigation triggers only — no business rules or mapping.
- [ ] **View models:** `@MainActor`, `ObservableObject`, expose UI state (prefer `LoadState<T>`).
- [ ] **Models:** domain structs in Domain layer.
- [ ] Loading and error handling use shared helpers (`LoadTaskRunner`, `UserFacingError`) unless a documented exception exists.
- [ ] Views switch on `viewModel.state` (or equivalent), not parallel `isLoading` + `errorMessage` + content flags.

### 6. Swift Concurrency

- [ ] Network and repository APIs use `async throws` (no new completion-handler APIs).
- [ ] UI-facing types are `@MainActor` where they touch SwiftUI state.
- [ ] User-triggered loads cancel previous work (`LoadTaskRunner` or equivalent).
- [ ] `CancellationError` is not shown as a user-facing error.
- [ ] User-visible errors go through `UserFacingError` / `LoadState.failed`.

### 7. Tests

- [ ] Repository and view model tests use mocks — no real network in unit tests.
- [ ] New repository or non-trivial VM logic includes tests in `SwiftPokedexTests/`.
- [ ] View model tests avoid asserting exact localized UI copy; use `guard case .failed` or check substrings (e.g. status code).

### 8. Naming consistency

- [ ] `*Protocol` = contract; `Remote*` = network repository implementation.
- [ ] Feature/screen: `GenerationList`, `PokemonDetail` (UI + VM + feature protocol names).
- [ ] API resource folders: `Data/Pokemon/`, `Data/Generations/` (plural resource; no duplicate `Data/Generation/`).
- [ ] Methods that return collections: plural (`fetchGenerations()` → `[Generation]`).

---

## Shared components (do not duplicate per feature)

| Component | Location | Purpose |
|-----------|----------|---------|
| `LoadState<T>` | `Core/Presentation/` | `idle` / `loading` / `loaded` / `failed` |
| `LoadTaskRunner` | `Core/Presentation/` | Cancellable async load → state updates |
| `UserFacingError` | `Core/Errors/` | Map `APIError` (and unknown errors) to UI strings |
| `APIConfiguration` | `Core/Networking/` | Single API base URL + `url(path:)` |
| `PagedListDTO` / `NamedResourceDTO` | `Data/Common/` | PokeAPI paginated list responses |
| `LocalizedNameDTO` | `Data/Common/` | `names[]` entries from detail endpoints |
| `LocalizedNameResolver` | `Core/Localization/` | Pick display string for device locale |
| `SlugDisplayNameFormatter` | `Core/Localization/` | Fallback label from API slug before enrichment |
| `ResourceEnrichment` | `Core/Localization/` | Parallel detail fetch + merge into list summaries |
| `ResourceURLParser` | `Data/Common/` | Parse numeric id from PokeAPI resource URLs |
| `L10n` | `Core/Localization/` | App UI strings from `Localizable.xcstrings` |
| `LocaleFormatting` | `Core/Localization/` | Locale-aware number and measurement formatting |
| `AppLog` | `Core/Logging/` | Debug-only `os.Logger` helpers (not user-facing) |

---

## App UI localization (String Catalog)

Supported languages: **English (default)**, **French**, **German** (`knownRegions`: en, fr, de).

| Piece | Location | Purpose |
|-------|----------|---------|
| `Localizable.xcstrings` | `Resources/` | UI copy, plural rules, translations |
| `L10n` | `Core/Localization/` | Type-safe accessors; uses `Locale.current` internally |
| `LocaleFormatting` | `Core/Localization/` | Numbers and measurements via `Locale.current` |

### Rules

- **UI strings** → `Localizable.xcstrings` via `L10n` (not hard-coded in views).
- **PokeAPI `names[]`** → `LocalizedNameResolver` (separate from app UI l10n).

---

## Localized resources (list + detail enrichment)

PokeAPI list endpoints return only `name` + `url`. Translations live on **detail** responses (`names[]` with `language` + localized `name`).

### Pattern (reuse for every localizable resource)

1. **List fetch** — `GET /<resource>` → `PagedListDTO<NamedResourceDTO>`.
2. **Summary mapping** — `slug` + `displayName` from `SlugDisplayNameFormatter` + `isDisplayNameLocalized = false`.
3. **Enrichment** — `ResourceEnrichment.enrich` fetches `GET /<resource>/{id}` in parallel, merges via resource mapper.
4. **Localized mapping** — `LocalizedNameResolver.displayName(from: detail.names, fallback: summary.displayName)` + `isDisplayNameLocalized = true`.

### Domain model fields

| Field | Purpose |
|-------|---------|
| `slug` | Stable API identifier (`generation-i`) |
| `displayName` | String shown in UI |
| `isDisplayNameLocalized` | `false` = slug fallback; `true` = resolved from `names[]` |

### Per-resource responsibilities (`Data/<Resource>/`)

| File | Role |
|------|------|
| `<Resource>DetailDTO` | Decodes detail JSON including `names: [LocalizedNameDTO]` |
| `<Resource>Mapper` | `toDomainSummary`, `enriched(from:summary:)` |
| `Remote*Repository` | List fetch + `ResourceEnrichment` + detail endpoint |

### Performance note

Enrichment runs N detail calls after the list. Acceptable for small lists (e.g. generations). For large lists (e.g. Pokémon), add **cache** in Data later; keep `ResourceEnrichment` and mappers unchanged.

---

## Data flow (reference)

```text
View  →  ViewModel.loadX()  →  LoadTaskRunner
  →  RepositoryProtocol  →  RemoteRepository
  →  APIClientProtocol  →  PokeAPI list
  →  summary DTO  →  Mapper  →  Domain summaries
  →  ResourceEnrichment  →  detail DTO per item  →  Mapper merge
  →  LoadState.loaded
```

---

## Principles summary

| Principle | How it shows up in this project |
|-----------|----------------------------------|
| Swift Concurrency | `async/await`, `Task`, `@MainActor`, cancellation |
| MVVM | SwiftUI Views + `ObservableObject` ViewModels + Domain models |
| Clean / feature-based | `Features/*` + `Data/*` + `Core/*` with inward dependencies |
| Dependency injection | `AppContainer` + initializer injection |
| Repository pattern | Protocol in Domain, `Remote*` implementation in Data |
| Protocol-oriented design | `APIClientProtocol`, `*RepositoryProtocol`, test mocks |

---

## Related docs

- [README.md](README.md) — overview and tech stack
- [.swiftlint.yml](.swiftlint.yml) — style rules (also enforced on build)
