# lex-nomad

HashiCorp Nomad integration for [LegionIO](https://github.com/LegionIO/LegionIO). Provides runners for interacting with the Nomad HTTP API covering jobs, nodes, allocations, deployments, evaluations, namespaces, services, variables, status, and search.

## Installation

```bash
gem install lex-nomad
```

## Functions

### Jobs
`list_jobs`, `get_job`, `create_job`, `update_job`, `delete_job`, `plan_job`, `dispatch_job`, `revert_job`, `job_versions`, `job_summary`, `job_allocations`, `job_evaluations`, `job_deployments`, `job_latest_deployment`, `evaluate_job`, `force_periodic_job`, `scale_job`, `job_scale_status`, `job_services`, `parse_job`

### Nodes
`list_nodes`, `get_node`, `node_allocations`, `evaluate_node`, `drain_node`, `purge_node`, `set_node_eligibility`

### Allocations
`list_allocations`, `get_allocation`, `stop_allocation`, `signal_allocation`, `restart_allocation`, `allocation_services`, `allocation_checks`

### Deployments
`list_deployments`, `get_deployment`, `deployment_allocations`, `fail_deployment`, `pause_deployment`, `promote_deployment`, `set_allocation_health`, `unblock_deployment`

### Evaluations
`list_evaluations`, `get_evaluation`, `evaluation_allocations`, `evaluations_count`, `delete_evaluations`

### Namespaces
`list_namespaces`, `get_namespace`, `create_or_update_namespace`, `delete_namespace`

### Services
`list_services`, `get_service`, `delete_service`

### Variables
`list_variables`, `get_variable`, `create_or_update_variable`, `delete_variable`

### Status
`leader`, `peers`

### Search
`prefix_search`, `fuzzy_search`

## Standalone Usage

```ruby
require 'legion/extensions/nomad'

client = Legion::Extensions::Nomad::Client.new(
  address: 'http://nomad.example.com:4646',
  token: 'your-acl-token',
  namespace: 'default'
)

client.list_jobs
client.get_job(job_id: 'my-service')
client.leader
```

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework (optional for standalone client usage)
- HashiCorp Nomad cluster (API v1)
- `faraday` >= 2.0

## License

MIT
