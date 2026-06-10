# Agent Governance

## Purpose

Define the accepted long-lived governance baseline for the Codex agent standards template, including how OpenSpec, project boundaries, and repository validation work together.

## Requirements

### Requirement: OpenSpec Baseline Must Exist
The repository MUST keep an OpenSpec baseline under `openspec/specs/` for long-lived governance and workflow requirements.

#### Scenario: Fresh clone inspects normative assets
- **GIVEN** a contributor clones the repository
- **WHEN** the contributor reviews the normative files
- **THEN** the repository includes `openspec/config.yaml`
- **AND** the repository includes at least one tracked spec under `openspec/specs/`
- **AND** those files describe the accepted governance baseline

### Requirement: SDD Updates Must Precede Normative Changes
Any change that alters long-lived behavior, contracts, review gates, or role responsibilities MUST update OpenSpec specs before the corresponding implementation or normative rewrite is considered complete.

#### Scenario: Governance rule changes
- **GIVEN** a change modifies `AGENTS.md`, `WORKFLOW.md`, role definitions, or validation expectations
- **WHEN** the change affects durable repository behavior
- **THEN** the change updates `openspec/specs/` or creates an OpenSpec delta under `openspec/changes/`
- **AND** the matching `docs/design/` SDD document is updated in the same change set

### Requirement: Tests Must Stay Inside Accepted Boundary
The repository MUST reject compatibility-only tests and MUST keep automated checks aligned to the current accepted project boundary.

#### Scenario: Compatibility fallback test is proposed
- **GIVEN** a change adds tests for legacy fallback behavior, dual-track compatibility, or unaccepted historical branches
- **WHEN** that behavior is not explicitly required by the repository norms
- **THEN** the change is treated as out of scope
- **AND** the compatibility-only test is not part of the accepted baseline

### Requirement: Validation Must Check OpenSpec Assets
Repository validation MUST fail when the required OpenSpec baseline or OpenSpec skills are missing.

#### Scenario: Required OpenSpec asset removed
- **GIVEN** `openspec/config.yaml`, `openspec/specs/agent-governance/spec.md`, or required `.codex/skills/openspec-*` skill files are missing
- **WHEN** `bash scripts/validate-repository.sh` runs
- **THEN** `scripts/validate-repository.sh` fails
- **AND** the repository is not considered ready for review
