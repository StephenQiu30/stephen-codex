---
layer: Plan
doc_no: "001"
audience:
  - PM
  - Dev
  - QA
  - Ops
feature_area: agent-orchestration
purpose: "规划如何将 Symphony-ready ticket-level 编排规则落入 Codex 模板的 AGENTS.md 与校验脚本。"
canonical_path: "docs/plans/001-symphony-ready-agent编排实施计划.md"
status: draft
version: "0.1.0"
owner: "StephenQiu30"
inputs:
  - "docs/design/001-symphony-ready-agent编排设计.md"
  - "AGENTS.md"
  - "scripts/validate-repository.sh"
outputs:
  - "AGENTS.md 新增 Symphony-ready 编排规范"
  - "WORKFLOW.md 接入官方风格的 Linear ticket 调度契约"
  - "scripts/validate-repository.sh 新增规范文本门禁"
triggers:
  - "需要将 Symphony-ready 编排规范落入 Codex Agent 模板"
downstream:
  - "AGENTS.md"
  - "根目录 WORKFLOW.md 模板"
---

# Symphony-ready Agent Orchestration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 OpenAI Symphony 推荐的 ticket-level 编排方式落入 Codex 模板，使 `AGENTS.md` 明确长期规则，并用根目录 `WORKFLOW.md` 承接 Linear ticket 调度契约。

**Architecture:** 先用 `scripts/validate-repository.sh` 增加文本门禁制造红灯，再更新 `AGENTS.md` 让门禁变绿。`AGENTS.md` 承载长期行为准则，根目录 `WORKFLOW.md` 负责 Linear project、workspace、hooks 和 agent command 等实例配置。

**Tech Stack:** Markdown, Bash, npm script, git.

---

## File Structure

- Modify: `scripts/validate-repository.sh`
  Responsibility: 用最轻量的 grep 门禁确保 Symphony-ready 编排规范不会从模板中丢失。
- Modify: `AGENTS.md`
  Responsibility: 记录 Codex 侧长期稳定的 Symphony-ready ticket-level 执行规范。
- Validate: `npm test`, `git diff --check`, `rg`.

---

### Task 1: Add Failing Codex Validation Gate

**Files:**
- Modify: `scripts/validate-repository.sh`

- [ ] **Step 1: Add Symphony-ready text checks**

Insert these checks after the existing `grep -q "npm test" AGENTS.md` line:

```bash
grep -q "## Symphony-ready 编排原则" AGENTS.md
grep -q "Linear ticket" AGENTS.md
grep -q "## Codex Workpad" AGENTS.md
grep -q "Human Review" AGENTS.md
grep -q "Rework" AGENTS.md
grep -q "Playwright" AGENTS.md
```

- [ ] **Step 2: Run validation to confirm red state**

Run:

```bash
npm test
```

Expected: command exits with status `1` because `AGENTS.md` does not yet contain `## Symphony-ready 编排原则`.

- [ ] **Step 3: Commit failing gate**

Run:

```bash
git add scripts/validate-repository.sh
git commit -m "test: 增加 Codex Symphony-ready 编排门禁"
```

Expected: commit succeeds with only `scripts/validate-repository.sh` staged.

---

### Task 2: Implement Codex Symphony-ready Sections

**Files:**
- Modify: `AGENTS.md`

- [ ] **Step 1: Insert Symphony-ready sections**

Insert the following content after the `docs 目录规范` section and before `角色协作结构`:

```markdown
## Symphony-ready 编排原则

1. 复杂开发任务优先以 Linear ticket 为执行单位，而不是以一次聊天会话为执行单位。
2. 推荐落地顺序为 `Harness -> Orchestration -> Linear`：先补齐项目自启动、自验证和文档结构，再配置 `WORKFLOW.md`，最后接入 Linear 状态机。
3. 每个被调度的 ticket 应在隔离 workspace 中执行，Agent 只能操作当前 workspace 和本任务相关文件。
4. `AGENTS.md` 记录长期稳定的 Codex 行为准则；项目级 `WORKFLOW.md` 记录 Linear project、workspace root、hooks、agent command、并发数等调度配置。
5. Agent 应先计划和设计验收方式，再实现；先复现或确认当前行为，再修改代码或文档。
6. Agent 必须自治执行到可审查结果，只有缺少必要权限、secret、外部服务或工具时才可以阻塞。

## Linear Ticket 状态机

推荐状态流为 `Backlog -> Todo -> In Progress -> Human Review -> Merging -> Done`，并保留 `Rework` 返工路径。

1. `Backlog`：不自动执行，等待人工明确移动到 `Todo`。
2. `Todo`：可被 Symphony 或兼容 runner 拾取；拾取后应立即移动到 `In Progress`。
3. `In Progress`：Agent 正在隔离 workspace 中执行计划、实现和验证。
4. `Human Review`：PR、验证证据和 Workpad 已准备好，等待人工审查。
5. `Merging`：人工批准后进入合并流程；合并前仍需检查 CI、冲突和目标分支状态。
6. `Done`：终态，runner 不再处理。
7. `Rework`：审查后需要返工，必须重新读取 ticket、评论、PR 反馈和当前代码状态，再重新计划。

## Workpad 单一事实源

1. 每个 Linear ticket 只维护一个持久评论作为进度事实源，Codex 使用标题 `## Codex Workpad`。
2. Workpad 应包含环境戳，格式为 `<hostname>:<abs-workdir>@<short-sha>`。
3. Workpad 必须维护 `Plan`、`Acceptance Criteria`、`Validation`、`Notes` 和必要时的 `Confusions`。
4. Ticket 描述、评论、OpenSpec change、PR 反馈中的验收要求必须同步到 Workpad 的验收和验证清单。
5. 计划、进度、验证、阻塞和交付说明都更新到同一个 Workpad，不额外散落多个总结评论。

## Harness 能力要求

1. 项目应提供一键启动入口，例如 `scripts/start-local.sh`、`make start` 或等价命令。
2. 项目应提供统一验证入口，例如 `npm test`、`scripts/verify.sh` 或等价命令。
3. 项目应说明 `.env.example`、secret 来源、本机与 CI 差异、日志位置和常见故障处理方式。
4. Agent 应优先使用可重复验证方式证明变更有效，包括测试输出、构建结果、接口响应、日志、截图、trace 或录屏。
5. 前端、网页和 UI 任务推荐使用 Playwright、截图、trace 或录屏作为验收证据；第一版不强制所有项目自动上传视频到 Linear。

## Human Review 门禁

进入 `Human Review` 前必须满足：

1. Workpad 中的计划、验收标准和验证清单已更新，完成项已勾选。
2. Ticket 明确要求的 `Validation`、`Test Plan` 或 `Testing` 已执行。
3. 最新提交对应的测试、lint、构建或运行时验证通过。
4. PR 已创建或更新，并与 Linear ticket 关联。
5. PR 检查为绿色；如果项目没有配置检查，必须明确说明 `statusCheckRollup` 或等价检查为空。
6. PR feedback sweep 已完成，没有未处理的 actionable 评论。
7. UI 或前端任务已提供适当的截图、trace、录屏或可复现手工证据。

## Rework 与 Blocked 规则

1. `Rework` 是完整返工流程，不是在旧分支上随手补丁。
2. 进入 `Rework` 后必须重新读取 ticket、Workpad、PR 评论、人类反馈和最新 `origin/main`。
3. 如果旧 PR 已关闭、已合并或实现方向不可复用，应关闭旧 PR 或明确废弃旧状态，再从 `origin/main` 新建分支。
4. `Blocked` 只用于真实外部阻塞，例如缺少必要权限、secret、Linear/GitHub 工具、外部服务访问或不可替代的人工输入。
5. 阻塞时必须在 Workpad 写清楚缺什么、为什么阻塞、需要人做什么；不得把普通实现困难当作阻塞。
```

- [ ] **Step 2: Run validation to confirm green state**

Run:

```bash
npm test
```

Expected: command exits with status `0`.

- [ ] **Step 3: Run Markdown whitespace check**

Run:

```bash
git diff --check
```

Expected: no output and status `0`.

- [ ] **Step 4: Confirm required sections are present**

Run:

```bash
rg -n "Symphony-ready 编排原则|Linear Ticket 状态机|Codex Workpad|Harness 能力要求|Human Review 门禁|Rework 与 Blocked" AGENTS.md
```

Expected: each section title or marker appears once.

- [ ] **Step 5: Commit implementation**

Run:

```bash
git add AGENTS.md
git commit -m "docs: 优化 Codex Symphony-ready 编排规范"
```

Expected: commit succeeds with only `AGENTS.md` staged.

---

### Task 3: Final Codex Repository Verification

**Files:**
- Validate: `AGENTS.md`
- Validate: `scripts/validate-repository.sh`

- [ ] **Step 1: Run full validation**

Run:

```bash
npm test
git diff --check
git status --short
```

Expected: `npm test` and `git diff --check` pass; `git status --short` shows no uncommitted files from this plan.

- [ ] **Step 2: Inspect recent commits**

Run:

```bash
git log --oneline -3
```

Expected: recent commits include:

```text
docs: 优化 Codex Symphony-ready 编排规范
test: 增加 Codex Symphony-ready 编排门禁
docs: 规划 Codex Symphony-ready 编排实施
```

---

## Self-Review

1. Spec coverage: this plan covers the approved design items for `AGENTS.md`, Linear ticket state flow, `## Codex Workpad`, harness requirements, Human Review gates, Rework and Blocked handling, plus CI-enforced text gates.
2. Placeholder scan: this plan contains no placeholder markers or deferred implementation language.
3. Type consistency: all section names used in validation commands match the sections inserted into `AGENTS.md`.
