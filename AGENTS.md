# 一世韶华 / grass.show — AGENTS

## 你正在维护什么

- **项目概览**：本仓库是 Hugo 驱动的个人博客，主题使用 `PaperMod`（作为 Git 子模块引入），通过 Netlify 自动构建部署到 `https://grass.show/`。
- **文章内容**：所有正式文章与随笔位于 `content/post/`，译文位于 `content/translate/`，文件为 Markdown 格式并带 Hugo front matter。
- **部署方式**：Netlify 按照仓库根目录配置（见 `netlify.toml`）运行 `hugo` 构建，使用 `public/` 作为发布目录。

## 目录地图（重要目录）

- `content/post/`：博文与随笔，新增文章默认放在这里。
- `content/translate/`：翻译类文章。
- `layouts/partials/`：自定义或覆盖主题的局部模板（例如评论组件 `comments.html`）。
- `themes/PaperMod/`：博客主题作为 Git 子模块引入，**一般不直接修改**，如需改动优先在 `layouts/` 下覆盖。
- `static/`：静态资源（图片等），会按原路径拷贝到构建输出。
- `public/`：`hugo` 生成的静态站点目录，已在 `.gitignore` 中忽略，不应提交。
- `hugo.toml`：站点与主题配置。
- `netlify.toml`：Netlify 构建配置。

## 必跑命令（在仓库根执行）

> 所有命令默认在仓库根目录 `/home/grass/workspace/personal/running-grass.github.io` 执行。

- **本地预览（包含草稿）**：`hugo server -D`  
  - 访问本地预览：`http://localhost:1313/`
- **正式构建**：`hugo`  
  - 输出会写入 `public/` 目录。
- **首次克隆后拉取主题子模块**：`git submodule update --init --recursive`

## 约束（MUST / SHOULD）

### MUST（硬约束）

- **MUST**：提交信息遵循 Conventional Commits 规范，type、scope、description 等按约定书写（见下文“技能使用约定”中的 `conventional-commits` 技能）。
- **MUST**：不要提交 `public/` 目录内容，构建产物一律视为可重建文件。
- **MUST**：不要在 `themes/PaperMod/` 目录中直接修改主题源码；如需自定义样式或局部模板，优先在 `layouts/` 或 `static/` 下添加/覆盖文件。
- **MUST**：在新增文章时，为 Markdown 文件添加合规的 front matter（至少包含 `title`、`date`、`draft` 字段，必要时补充 `tags`、`series` 等）。
- **MUST**：每篇文章的 front matter **必须包含 `aliases`**，用于给该文章生成“指向自身的旧链接/别名链接”，避免未来调整 URL 结构或改名导致 404。
  - **规则**：`aliases` 至少包含 1 条路径（以 `/` 开头、不以 `/` 结尾、不含域名），作为该文章需要长期兼容的入口。
  - **建议默认值**：
    - `content/post/<name>.md`：`aliases = ["/post/<name>"]`
    - `content/translate/<name>.md`：`aliases = ["/translate/<name>"]`
  - **变更约定**：当你修改文章的最终访问路径（例如设置 `url`、更改站点 permalink 规则、或改文件名导致 URL 改变）时，**把旧路径追加到 `aliases`**（可保留多条），确保老链接能跳转到新链接。
- **MUST**：当使用 **YAML front matter**（`---`）时，数组字段必须使用 **YAML 多行列表**（block sequence），不要使用 `[...]` 这种 JSON/flow style 数组写法。
  - **示例（推荐）**：`aliases:` / `tags:` 换行后用多行 `- item` 的形式书写。

### SHOULD（建议）

- **SHOULD**：新增博文统一放在 `content/post/`，译文放在 `content/translate/`。
- **SHOULD**：在本地使用 `hugo server -D` 预览文章排版与链接是否正常，再提交。
- **SHOULD**：新增文章时合理使用标签（`tags`）与系列（`series`），方便站内导航。

## 安全与数据

- **构建环境**：由 Netlify 管理，构建参数与 Hugo 版本在 `netlify.toml` 中声明，无需在本地执行部署脚本。
- **敏感信息**：本仓库不应包含任何密钥、账号密码或私有配置文件；如有部署相关密钥，应通过 Netlify 的环境变量或其他密钥管理方式注入。
- **破坏性操作**：任何会删除远端数据、修改生产配置的操作，均不应通过本仓库脚本自动执行，必须由人工在部署平台上确认。

## 技能使用约定

本仓库在 Cursor / AI coding agent 中推荐使用以下技能：

- **讨论并生成新博文**：`.agents/skills/discuss-and-generate-post/SKILL.md`  
  - 触发时机：当你想写一篇新的博文，希望 AI 从**灵感碰撞 → 大纲 → 初稿 → 润色 → 检查 → 定稿 → 写入文件**全流程协作时。  
  - 行为边界：在你确认主题与大纲前，AI **不得**直接生成整篇长文；在你确认定稿前，AI **不得**写入最终文件。

> 就近优先：当本仓库的 `AGENTS.md` 与全局技能说明存在冲突时，以本文件为准；对话中的显式指令优先于本文件约定。

## 新增文章的基本流程（简要）

1. 在对话中说明你想写的主题；如需要 AI 协助，请显式调用“讨论并生成新博文”技能工作流。  
2. 在 AI 协助下确定文章主题、读者与角度，生成并确认大纲。  
3. 由 AI 或你自己完成正文初稿，多轮润色后确定定稿。  
4. 由 AI 按本仓库惯例生成 Markdown 文件（含 front matter），写入 `content/post/<slug>.md`。  
5. 本地执行 `hugo server -D`，确认文章显示与链接正确，再提交代码。

## 验收标准（DoD）

- [ ] 在仓库根运行 `hugo` 能成功生成站点，输出到 `public/`，无报错。
- [ ] 在仓库根运行 `hugo server -D` 能正常预览，首页与文章页展示正常。
- [ ] 主题子模块 `themes/PaperMod` 能正常拉取（`git submodule update --init --recursive` 成功）。
- [ ] 提交信息符合 Conventional Commits 规范，且使用中文描述。
- [ ] 新增文章的 Markdown 文件位于 `content/post/`（或 `content/translate/`），front matter 字段完整且能被 Hugo 正常解析。

