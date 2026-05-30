---
layer: Design
doc_no: "001"
audience:
  - PM
  - Dev
  - QA
  - Ops
feature_area: agent-orchestration
purpose: "定义 Codex Agent 模板如何吸收 OpenAI Symphony 的 ticket-level 编排思想，形成可复制的 Symphony-ready harness。"
canonical_path: "docs/design/001-symphony-ready-agent编排设计.md"
status: draft
version: "0.1.0"
owner: "StephenQiu30"
inputs:
  - "AGENTS.md"
  - "docs/README.md"
  - "https://github.com/openai/symphony/blob/main/elixir/WORKFLOW.md"
  - "https://github.com/openai/symphony/blob/main/SPEC.md"
  - "https://www.youtube.com/watch?v=M_AmPWmkpwA"
outputs:
  - "AGENTS.md 的 Symphony-ready 编排规范优化方向"
  - "WORKFLOW.md 模板的职责边界与根目录接入要求"
  - "Linear ticket 状态机、Workpad、Harness 与 Human Review 门禁设计"
triggers:
  - "新增或调整 Codex Agent 自动化开发工作流"
  - "需要接入 OpenAI Symphony 或兼容 runner"
  - "需要将 Linear ticket 作为自动化开发控制面"
downstream:
  - "AGENTS.md"
  - "WORKFLOW.md"
  - "docs/operations/"
  - "docs/acceptance/"
---

# Symphony-ready Agent 编排设计

## 1. 背景

当前 Codex 模板已经沉淀了 MVP、TDD、SMART、OpenSpec、角色协作、PR 和 Git 收口规范。OpenAI Symphony 提供了另一层更高阶的组织方式：开发工作不再围绕一次聊天会话或一个临时 agent session，而是围绕 Linear ticket、隔离 workspace、持久 workpad、自动验证和 human review 状态机执行。

本设计用于把 Symphony 的推荐工作流吸收到 Codex 模板中，使模板复制到新项目后天然具备 Symphony-ready harness。第一版重点是模板层能力，不实现新的调度器，也不强制所有项目立即启用完整 Playwright 录屏上传。

## 2. 目标

1. 将 Codex 自动化开发单位从会话提升为 Linear ticket。
2. 在 `AGENTS.md` 中定义稳定的 ticket-level 编排规则，供 Codex 长期遵循。
3. 在根目录接入 `WORKFLOW.md`，并保持职责清晰：调度配置放在 `WORKFLOW.md`，长期行为准则放在 `AGENTS.md`。
4. 定义最小 harness 要求：一键启动、统一验证入口、日志和配置说明、验收证据规范。
5. 将 Playwright、截图、trace、录屏作为 UI 和前端任务的推荐验收能力。
6. 保持与 Claude 模板等价，确保双模板后续可以同步演进。

## 3. 非目标

1. 不在第一版实现完整 Symphony runner。
2. 不把 OpenAI 的 `elixir/WORKFLOW.md` 原样复制进 `AGENTS.md`。
3. 不强制所有项目立即接入 Linear API、Playwright 录屏上传或 PR 自动合并。
4. 不把 GitHub Issues、Jira、Trello 作为第一版控制面；它们只作为未来适配方向。
5. 不替代 OpenSpec；OpenSpec 仍负责较大 change 的 proposal、tasks、spec delta 和归档闭环。

## 4. 核心内容

### 4.1 推荐落地顺序

Codex 模板采用三段式落地顺序：

```text
Harness -> Orchestration -> Linear
```

1. `Harness`：先让项目具备 agent 可独立完成任务的工程环境，例如启动脚本、验证命令、文档结构、日志路径和验收证据能力。
2. `Orchestration`：再用 `WORKFLOW.md` 描述调度器配置和 agent SOP。
3. `Linear`：最后让 Linear ticket 成为状态机和人工审查入口。

这个顺序避免在项目尚不可自验证时过早启动无人值守 agent。

### 4.2 文件职责边界

1. `AGENTS.md`：记录长期稳定的 Codex 行为准则，包括 Symphony-ready 编排原则、状态机、workpad、review 门禁、rework 和 blocked 规则。
2. `WORKFLOW.md`：记录项目级调度契约，包括 Linear project slug、active states、terminal states、polling interval、workspace root、hooks、agent command 和并发上限。
3. `AGENTS.local.md`：记录具体项目的本地配置提示，例如 secret 来源、workspace root、启动命令和验证命令。
4. `docs/operations/`：记录如何配置 Linear 状态、runner、secret、workspace 和 GitHub/PR 流程。
5. `docs/acceptance/`：记录如何产出测试、截图、trace、录屏和 PR/CI 证据。

### 4.3 Linear 状态机

Codex 模板推荐以下状态流：

```text
Backlog -> Todo -> In Progress -> Human Review -> Merging -> Done
                         ^                 |
                         |                 v
                       Rework <------------
```

状态语义：

1. `Backlog`：不自动执行，等待人工明确进入 Todo。
2. `Todo`：可被 Symphony 或兼容 runner 拾取；拾取后立即进入 `In Progress`。
3. `In Progress`：agent 正在隔离 workspace 中执行。
4. `Human Review`：PR 和验证证据已准备好，等待人工审查。
5. `Merging`：人工批准后进入合并流程。
6. `Done`：终态，runner 不再处理。
7. `Rework`：审查后需要返工，必须重新读 ticket 和反馈，重新计划后再执行。

第一版要求模板文档明确推荐 Linear 项目配置 `Human Review` 和 `Merging`，避免 agent 因缺少状态而提前移动到 `Done`。

### 4.4 Workpad 单一事实源

每个 Linear ticket 只维护一个持久评论作为进度事实源，Codex 使用以下标题：

```md
## Codex Workpad
```

Workpad 必须包含：

1. 环境戳：`<hostname>:<abs-workdir>@<short-sha>`。
2. `Plan`：分层 checklist，反映当前执行计划。
3. `Acceptance Criteria`：从 ticket 描述、评论、测试计划和 OpenSpec 验收条件提取。
4. `Validation`：命令、测试、截图、trace、录屏或手工验收证据。
5. `Notes`：关键里程碑、同步结果、PR 链接状态和风险。
6. `Confusions`：仅在执行中出现歧义时记录，保持短句。

Agent 不应在同一 ticket 下散落多个总结评论；计划、进度、验证和阻塞信息都应更新到同一个 workpad。

### 4.5 Codex 执行流程

Codex ticket-level 执行顺序固定为：

1. 读取 Linear ticket 状态并路由。
2. `Todo` 立即移动到 `In Progress`。
3. 查找或创建 `## Codex Workpad`。
4. 更新计划、验收标准和验证清单。
5. 复现问题或确认当前行为，记录复现证据。
6. 同步 `origin/main`，记录同步结果和 HEAD。
7. 按 TDD 和最小实现原则完成代码或文档改动。
8. 运行与范围匹配的测试、lint、构建或运行时验证。
9. 创建或更新 PR，并把 PR 关联到 Linear ticket。
10. 扫描并处理 PR 评论、inline review、bot review 和 CI 反馈。
11. 更新 workpad 的最终 checklist 和验证证据。
12. 满足门禁后移动到 `Human Review`。

### 4.6 Harness 能力要求

参考视频中 `Harness -> Orchestration -> Linear` 的落地思路，模板不盲目增加零散 skill，而是保留三类能形成闭环的 harness skill：

1. `harness-local-server`：让项目在新 workspace 中可安装、可启动、可健康检查、可定位 logs。
2. `harness-playwright-evidence`：用 Playwright 产出端到端证据，包括 screenshot、trace、video recording、console logs 和 network logs。
3. `harness-linear-loop`：通过 Linear API 或 MCP 同步状态、Workpad、PR 链接与验证证据，支持 upload video evidence 时优先上传。

每个复制此模板的项目应逐步具备以下能力：

1. 一键启动：例如 `scripts/start-local.sh`、`make start` 或项目等价入口。
2. 统一验证：例如 `npm test`、`scripts/verify.sh` 或项目等价入口。
3. 环境说明：`.env.example`、secret 来源、本机与 CI 差异。
4. 日志说明：agent 能定位服务日志、浏览器日志、后端日志或构建日志。
5. 验收证据：命令输出、截图、trace、录屏、PR 检查和 Linear workpad 记录。
6. UI 推荐能力：前端或网页任务优先提供 Playwright 验证、截图、trace 或录屏证据；第一版不强制所有项目上传视频到 Linear。

### 4.7 Human Review 门禁

进入 `Human Review` 前必须满足：

1. Workpad 中的计划、验收标准和验证清单已更新且完成项已勾选。
2. ticket 明确要求的 `Validation`、`Test Plan` 或 `Testing` 已执行。
3. 最新提交对应的测试、lint、构建或运行时验证通过。
4. PR 已创建或更新，并与 Linear ticket 关联。
5. PR 检查为绿色，或明确说明当前项目没有配置检查。
6. PR feedback sweep 已完成，没有未处理的 actionable 评论。
7. UI 或前端任务已提供适当的截图、trace、录屏或可复现手工证据。

### 4.8 Rework 与 Blocked 规则

`Rework` 是完整返工流程，不是临时补丁模式。Agent 必须重新读取 ticket、workpad、PR 评论和人类反馈，明确本轮和上一轮不同的处理方式。必要时关闭旧 PR，从 `origin/main` 新建分支，并重新生成 workpad。

`Blocked` 只用于真实外部阻塞，例如缺少必要权限、secret、Linear/GitHub 工具、外部服务访问或不可替代的人工输入。阻塞时必须在 workpad 写清楚缺什么、为什么阻塞、需要人做什么，不应把普通实现困难当作阻塞。

## 5. 关联文档

### 5.1 输入文档

1. `AGENTS.md`
2. `docs/README.md`
3. OpenAI Symphony `elixir/WORKFLOW.md`
4. OpenAI Symphony `SPEC.md`
5. AI Jason 视频 `New AI coding paradiagm - OpenAI Symphony`

### 5.2 输出文档

1. 本设计文档。
2. `AGENTS.md` 编排规范优化。
3. 根目录 `WORKFLOW.md` 模板。

### 5.3 下游文档

1. `docs/operations/` 下的 Linear 与 Symphony runner 操作说明。
2. `docs/acceptance/` 下的 harness 验收证据规范。

## 6. 验收门禁

1. `AGENTS.md` 能表达 Symphony-ready 的 ticket-level 编排原则。
2. `AGENTS.md` 明确 Linear 状态机、workpad、Human Review、Rework 和 Blocked 规则。
3. 文档边界清晰：长期规则在 `AGENTS.md`，项目调度配置在 `WORKFLOW.md`。
4. Codex 与 Claude 模板保持等价，只在文件名、workpad 标题和生态路径上不同。
5. 根目录 `WORKFLOW.md` 对齐官方 YAML front matter 与 Markdown prompt body 的编排结构。
6. 根目录 skills 提供 `harness-local-server`、`harness-playwright-evidence` 与 `harness-linear-loop` 三件套。
7. 第一版不会强制所有项目接入完整 runner 或视频上传，但会把 harness 能力列为推荐演进方向。

## 7. 风险与边界

1. 如果项目缺少一键启动和统一验证入口，Symphony-ready 规则会停留在文档层，无法稳定无人值守执行。
2. 如果 Linear 项目没有 `Human Review` 和 `Merging` 状态，agent 可能无法按推荐状态机流转。
3. 如果 PR/CI/GitHub 权限不足，agent 只能在 workpad 中记录阻塞，不能伪装完成。
4. Playwright 录屏和上传能力依赖具体项目技术栈，第一版只作为推荐能力。

## 8. 待确认问题

已确认第一版采用 Codex + Claude 双模板同步升级、Linear 优先、Playwright/录屏作为推荐 harness 能力，不强制完整上传自动化。

## 9. 变更记录

| 日期 | 作者 | 版本 | 变更说明 |
| --- | --- | --- | --- |
| 2026-05-30 | StephenQiu30 | 0.1.0 | 初始化 Symphony-ready Agent 编排设计 |
