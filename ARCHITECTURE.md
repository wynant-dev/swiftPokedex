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
│   └── Presentation/             LoadState, LoadTaskRunner
├── Data/
│   ├── Common/                   Shared DTOs (PagedListDTO, NamedResourceDTO)
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
- [ ] Shared API list shapes use `Data/Common/` (e.g. `PagedListDTO`, `NamedResourceDTO`).
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

### 8. Naming consistency

- [ ] `*Protocol` = contract; `Remote*` = network repository implementation.
- [ ] Feature/screen: `GenerationList`, `PokemonDetail` (UI + VM + feature protocol names).
- [ ] API resource folders: `Data/Pokemon/`, `Data/Generations/` (plural resource, not mixed `Generation/` duplicates).
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

Add a feature-specific error type only for real domain/business failures, not for generic HTTP/decode errors.

---

## Data flow (reference)

```text
View  →  ViewModel.loadX()  →  LoadTaskRunner
  →  RepositoryProtocol  →  RemoteRepository
  →  APIClientProtocol  →  PokeAPI
  →  DTO  →  Mapper  →  Domain model  →  LoadState.loaded
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
