# Codex Agent 规范模板

一个面向 Codex 的开源 Agent 协作规范模板，用于帮助个人或团队快速建立稳定、可复用、可验收的 AI 协作工作流。

本项目把 Codex 项目中常见的规范文件、角色分工、OpenSpec change 流程、TDD/SMART/MVP 原则、docs 文档分类和 Git/PR 收口要求整理为一套可直接复用的目录模板。你可以把它作为新项目的起点，也可以复制其中的规范文件到已有项目中逐步落地。

## 项目地址

GitHub: <https://github.com/StephenQiu30/stephen-codex.git>

## 适用人群

1. 希望为 Codex 项目建立统一协作规则的开发者。
2. 希望把 AI Agent 分工固化为可维护文件结构的团队。
3. 正在使用 OpenSpec 管理需求、计划、验收和变更归档的项目。
4. 希望将 TDD、SMART、MVP 原则写入日常 AI 协作流程的工程团队。
5. 需要一个可开源、可复制、可二次定制的 Codex Agent 模板项目的用户。

## 目录定位

`codex/` 是独立项目，不依赖同级 `claude/` 目录即可单独复制、维护和开源发布。它面向 Codex 使用场景，重点解决以下问题：

1. Codex 在项目中应该读取哪些规范文件。
2. Codex 全局规范与项目局部规范如何区分。
3. Codex 多角色协作时 PM、Explorer、Builder、Tester、Reporter 如何分工。
4. OpenSpec change 完成后如何验证、总结并使用中文 Git 提交收口。
5. 如何在 Codex 工作流中持续执行 MVP、TDD、SMART 规范。

## 目录功能

1. `AGENTS.md`：Codex 侧长期稳定的全局协作规范。
2. `AGENTS.local.md`：当前项目中的局部规范配置，用于和全局规则区分。
3. `.codex/agents/`：Codex 角色定义目录。
4. `.codex/skills/`：Codex 可复用工作流目录，当前主要承载 OpenSpec 相关流程。
5. `docs/`：项目文档目录，按 PRD、计划、设计、验收、运维等类型分类存放。
6. `openspec/`：OpenSpec 配置、changes 与 specs 的落位目录。
7. `.github/workflows/ci.yml`：GitHub Actions CI，用于检查模板基础结构和正式文档格式。
8. `package.json`：Node 项目元信息，用于后续安装 OpenSpec 相关依赖。
9. `LICENSE`：开源许可证。
10. `CONTRIBUTING.md`：贡献说明。

## 文件结构

```text
codex/
├── .github/
│   └── workflows/
│       └── ci.yml
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── AGENTS.md
├── AGENTS.local.md
├── .codex/
│   ├── agents/
│   │   ├── pm.toml
│   │   ├── explorer.toml
│   │   ├── builder.toml
│   │   ├── tester.toml
│   │   └── reporter.toml
│   └── skills/
├── docs/
│   ├── README.md
│   ├── TEMPLATE.md
│   ├── prd/
│   ├── plans/
│   ├── design/
│   ├── acceptance/
│   └── operations/
├── openspec/
│   ├── config.yaml
│   ├── changes/
│   └── specs/
└── package.json
```

## 开源使用

1. 克隆项目：`git clone https://github.com/StephenQiu30/stephen-codex.git`。
2. 优先阅读 `AGENTS.md` 理解全局规则，再按需修改 `AGENTS.local.md`。
3. 自定义角色时修改 `.codex/agents/` 下的角色文件。
4. 新增文档时遵循 `docs/` 分类规则，不同类型文档写入不同子目录。
5. 在已有 Codex 项目中使用时，可以直接复制 `AGENTS.md`、`AGENTS.local.md`、`.codex/`、`docs/` 和 `openspec/`。
6. 本项目使用 MIT License，允许个人或团队在保留许可证声明的前提下自由使用和修改。

## 核心规范

1. `MVP`：优先完成最小可用闭环，不做过度设计。
2. `TDD`：新增功能、修复缺陷或调整核心逻辑时，优先执行红灯、绿灯、重构流程。
3. `SMART`：需求、任务与验收标准需要具体、可衡量、可达成、相关并具备阶段边界。
4. `文件规模`：单个文件原则上不要超过 200-500 行，持续膨胀时按职责拆分。
5. `Git 收口`：每次使用 OpenSpec 执行完一个较大的 change 后，应使用中文 Git 提交信息提交，并保持工作区干净。
6. `PR 合并`：PR 合并前必须先给目标分支状态打 tag，作为合并前回滚点。

## 角色分工

1. `PM`：按 SMART 原则拆解需求、定义范围、制定验收标准、控制 MVP 边界。
2. `Explorer`：读取代码、查找文件、梳理依赖、提供事实依据。
3. `Builder`：基于验收目标做最小实现，涉及逻辑改动时遵循 TDD。
4. `Tester`：执行测试、lint、回归检查，并确认 TDD 红绿重构结果。
5. `Reporter`：汇总修改内容、验证证据、残余风险和交付说明。

标准执行顺序：

```text
Explorer -> PM -> Builder -> Tester -> Reporter
```

简单任务可以压缩为：

```text
PM -> Builder -> Tester
```

## OpenSpec 使用约定

1. 较大的需求变更应优先以 OpenSpec change 方式组织。
2. change 应明确 proposal、tasks、spec delta 和验收标准。
3. 执行过程中应持续对齐 MVP、TDD 与 SMART 规范。
4. 完成后应验证 change，记录验证结果。
5. 较大的 change 完成后应使用中文 Git 提交信息提交，保持工作区干净。

## 验收标准

1. `AGENTS.md` 存在，并包含 MVP、TDD、SMART、OpenSpec change 提交收口、角色协作和交付输出要求。
2. `AGENTS.local.md` 存在，并说明它是项目局部规范配置文件。
3. `.codex/agents/` 中存在 `pm`、`explorer`、`builder`、`tester`、`reporter` 五类角色。
4. `docs/` 中存在 `TEMPLATE.md`、`prd`、`plans`、`design`、`acceptance`、`operations` 子目录，且每个目录有 README。
5. `openspec/config.yaml` 存在，且 OpenSpec changes 与 specs 有固定目录。
6. `LICENSE` 与 `CONTRIBUTING.md` 存在，项目具备基础开源使用说明。
7. README 能够说明本目录定位、功能、结构、角色、OpenSpec 使用方式和验收标准。
8. Git 提交与 PR 合并规范包含中文提交、工作区干净、PR 合并前 tag 等要求。
9. GitHub Actions CI 存在，并检查关键规范文件、docs 子目录和 Markdown 基础格式。
10. 单个规范文件保持在 200-500 行以内。

## 维护原则

1. Codex 侧文件命名保持 `AGENTS.md` 与 `AGENTS.local.md`。
2. 全局稳定规则写入 `AGENTS.md`，项目局部规则写入 `AGENTS.local.md`。
3. 角色职责写入 `.codex/agents/`，不要混入全局规则文件。
4. 不为当前没有使用场景的角色、流程或目录做过度扩展。
