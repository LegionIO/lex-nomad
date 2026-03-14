# lex-nomad: HashiCorp Nomad Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent (Level 2)**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`
- **Parent (Level 1)**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to HashiCorp Nomad. Provides runners for interacting with the full Nomad HTTP API v1 covering jobs, nodes, allocations, deployments, evaluations, namespaces, services, variables, cluster status, and search.

**GitHub**: https://github.com/LegionIO/lex-nomad
**License**: MIT

## Architecture

```
Legion::Extensions::Nomad
├── Runners/
│   ├── Jobs              # CRUD jobs, plan, dispatch, revert, scale, versions, summary
│   ├── Nodes             # List/get nodes, drain, purge, eligibility
│   ├── Allocations       # List/get/stop/signal/restart allocations, services, checks
│   ├── Deployments       # List/get deployments, fail, pause, promote, health, unblock
│   ├── Evaluations       # List/get/delete evaluations, count
│   ├── Namespaces        # CRUD namespaces
│   ├── Services          # List/get/delete service registrations
│   ├── Variables         # CRUD variables (Nomad KV)
│   ├── Status            # Cluster leader and raft peers
│   └── Search            # Prefix and fuzzy search across resources
├── Helpers/
│   └── Client            # Faraday connection builder (Nomad API v1)
└── Client                # Standalone client class (includes all runners)
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (>= 2.0) | HTTP client for Nomad REST API |

## Connection

Authentication uses `X-Nomad-Token` header (ACL token). Namespace scoping via `namespace` query parameter. Default address: `http://127.0.0.1:4646`.

## Testing

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
