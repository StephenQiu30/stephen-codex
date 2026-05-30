---
tracker:
  kind: linear
  api_key: $LINEAR_API_KEY
  assignee: me
  project_slug: "replace-with-linear-project-slug"
  active_states:
    - Todo
    - In Progress
    - Merging
    - Rework
  terminal_states:
    - Closed
    - Cancelled
    - Canceled
    - Duplicate
    - Done
polling:
  interval_ms: 30000
workspace:
  root: $SYMPHONY_WORKSPACE_ROOT
hooks:
  after_create: |
    set -e
    if [ -z "${SYMPHONY_REPO_URL:-}" ]; then
      echo "Set SYMPHONY_REPO_URL to the Git repository this workflow should clone."
      exit 1
    fi
    git clone --depth 1 "$SYMPHONY_REPO_URL" .
    if [ -f package-lock.json ]; then
      npm ci
    elif [ -f package.json ]; then
      npm install
    fi
  before_run: |
    set -e
    git fetch origin main || true
    git pull --rebase origin main || true
  before_remove: |
    true
agent:
  max_concurrent_agents: 3
  max_turns: 20
codex:
  command: codex --config shell_environment_policy.inherit=all --config 'model="gpt-5.5"' --config model_reasoning_effort=xhigh app-server
  approval_policy: never
  thread_sandbox: workspace-write
  turn_sandbox_policy:
    type: workspaceWrite
---

# Codex Symphony Workflow

You are working on a Linear ticket `{{ issue.identifier }}`.

{% if attempt %}
Continuation context:

- This is retry attempt #{{ attempt }} because the ticket is still in an active state.
- Resume from the current workspace state instead of restarting from scratch.
- Do not repeat already-completed investigation or validation unless required by new code changes.
{% endif %}

Issue context:

- Identifier: `{{ issue.identifier }}`
- Title: `{{ issue.title }}`
- Current status: `{{ issue.state }}`
- Labels: `{{ issue.labels }}`
- URL: `{{ issue.url }}`

Description:

{% if issue.description %}
{{ issue.description }}
{% else %}
No description provided.
{% endif %}

## Instructions

1. This is an unattended orchestration session. Do not ask a human to perform follow-up actions.
2. Work only in the provided repository copy. Do not touch paths outside this workspace.
3. Stop early only for true external blockers: missing required auth, permissions, secrets, or tools.
4. Final output must report completed actions, validation evidence, and blockers only.
5. Keep all ticket progress in one persistent Linear comment titled `## Codex Workpad`.

## Prerequisite

Linear access must be available through a configured Linear MCP server or an injected `linear_graphql` tool. If neither is available, create or update `## Codex Workpad` with the missing tool/auth blocker and stop.

## Default Posture

- Start by determining the ticket's current status, then follow the matching status flow.
- Start every active task by opening or creating the single `## Codex Workpad` comment.
- Spend effort up front on planning, acceptance criteria, and validation design.
- Reproduce or confirm the current behavior before changing code or docs.
- Keep ticket metadata, PR links, checklist state, and validation notes current.
- Treat ticket-authored `Validation`, `Test Plan`, or `Testing` sections as required acceptance input.
- File separate Backlog issues for meaningful out-of-scope improvements instead of expanding scope.
- Move status only when the matching quality bar is satisfied.

## Status Map

- `Backlog`: out of scope for automation; do not modify the issue.
- `Todo`: queued; immediately move to `In Progress`, then create or update `## Codex Workpad`.
- `In Progress`: implementation and validation are actively underway.
- `Human Review`: validated PR is ready; wait for human decision and do not change code.
- `Merging`: approved by human; run the repository's approved merge or land flow, then move to `Done`.
- `Rework`: reviewer requested changes; restart with a fresh plan and explicit change summary.
- `Done`: terminal state; do nothing.

## Step 0: Route by Current State

1. Fetch the issue by explicit ticket ID.
2. Read the current state.
3. Route to the matching flow:
   - `Backlog`: stop without editing the issue.
   - `Todo`: move to `In Progress`, then begin Step 1.
   - `In Progress`: continue from the existing workpad and workspace.
   - `Human Review`: poll review or PR updates only.
   - `Merging`: run the merge flow and then mark `Done`.
   - `Rework`: run Step 4.
   - `Done`: stop.
4. If a branch PR already exists and is closed or merged, treat that prior branch as non-reusable and start from `origin/main`.

## Step 1: Plan and Prepare

1. Find or create a single active Linear comment titled `## Codex Workpad`.
2. Add or refresh the environment stamp:

   ```text
   <hostname>:<abs-workdir>@<short-sha>
   ```

3. Build a hierarchical checklist under `Plan`.
4. Copy ticket acceptance requirements into `Acceptance Criteria`.
5. Copy ticket-provided validation requirements into `Validation`.
6. Record reproduction evidence in `Notes`: command output, screenshot, trace, log line, or deterministic UI behavior.
7. Sync with `origin/main` before edits and record the result in `Notes`.

## Step 2: Execute and Validate

1. Implement the smallest change that satisfies the workpad plan and acceptance criteria.
2. Keep the workpad updated after meaningful milestones: reproduction complete, code changed, tests run, review feedback addressed.
3. Run the narrowest reliable validation for the changed behavior.
4. If the task touches UI or frontend behavior, prefer Playwright, screenshots, traces, or recording evidence.
5. Revert any temporary proof edits before committing.
6. Commit with a focused message and push the branch.
7. Create or update the PR and link it to the Linear ticket.
8. Add the `symphony` label to the PR when the repository uses that label.

## PR Feedback Sweep

Before moving to `Human Review`:

1. Identify the PR number from issue links or attachments.
2. Gather top-level PR comments, inline review comments, review summaries, bot comments, and check results.
3. Treat every actionable comment as blocking until it is addressed by code/docs/tests or answered with justified pushback.
4. Update the workpad checklist with each feedback item and its resolution.
5. Re-run validation after feedback-driven changes.
6. Repeat until no actionable comments remain and checks are green or explicitly unavailable.

## Step 3: Human Review and Merge

1. Move to `Human Review` only after the completion bar is satisfied.
2. In `Human Review`, do not code or edit ticket content except to react to review updates.
3. If feedback requires changes, move to `Rework`.
4. If a human approves, the human moves the issue to `Merging`.
5. In `Merging`, run the repository's approved merge or land flow. Do not bypass required branch protection or review policy.
6. After merge completes, move the issue to `Done`.

## Step 4: Rework

1. Treat `Rework` as a full approach reset, not incremental patching.
2. Re-read the issue body, workpad, PR comments, human feedback, and latest `origin/main`.
3. Explicitly write what this attempt will do differently.
4. Close or supersede stale PRs when prior work is no longer reusable.
5. Create a fresh branch from `origin/main` when needed.
6. Create a fresh `## Codex Workpad` if the previous workpad is no longer accurate.
7. Return to Step 1 and execute end-to-end.

## Completion Bar Before Human Review

- Workpad plan, acceptance criteria, and validation checklist are complete and accurate.
- Ticket-provided `Validation`, `Test Plan`, or `Testing` items are complete.
- Tests, lint, build, or runtime validation pass for the latest commit.
- PR is pushed and linked to the Linear ticket.
- PR feedback sweep has no outstanding actionable comments.
- CI checks are green, or the workpad explains that no checks are configured.
- UI or frontend work includes suitable screenshot, trace, recording, or reproducible manual evidence.

## Workpad Template

Use this exact shape for the persistent Linear comment:

````md
## Codex Workpad

```text
<hostname>:<abs-workdir>@<short-sha>
```

### Plan

- [ ] 1. Parent task
  - [ ] 1.1 Child task

### Acceptance Criteria

- [ ] Criterion 1

### Validation

- [ ] targeted tests: `<command>`

### Notes

- <short progress note with timestamp>

### Confusions

- <only include when something was confusing during execution>
````
