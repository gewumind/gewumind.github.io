# GewuMind 主页

GewuMind（格物智）的官方网站 / GitHub Pages 落地页，介绍 **GewuMind Boot**（AI 驱动的低代码后端容器，完整开源）与 **gewumind-skill**（可装进任意 AI Agent 的开发技能）。

纯静态多页，**零构建**：`index.html`、价格/法务页面 + `assets/`（CSS / JS / logo），直接部署即可。

## 本地预览

```bash
python3 -m http.server 4000
# 打开 http://localhost:4000
```

## 发布到 GitHub Pages

本仓库使用相对路径，根域与子路径都能正常访问。

**方案 A：组织站点（推荐，地址最短）**

仓库名用 `gewumind.github.io`，push 后即自动发布到 <https://gewumind.github.io>：

```bash
cd /data/projects/gewumind-github-html
git init -b main
git add .
git commit -m "feat: initial GewuMind landing page"
git remote add origin https://github.com/gewumind/gewumind.github.io.git
git push -u origin main
```

**方式 B：普通项目仓库**（例如 `homepage`），推送后在仓库
`Settings → Pages` → Source 选 `Deploy from a branch`，分支 `main`、目录 `/ (root)`。
最终地址为 `https://gewumind.github.io/homepage/`（`.nojekyll` 已就位，避免 Jekyll 处理）。生产域名为 `https://gewumind.com`。

## 目录

```
gewumind-github-html/
├── index.html              # 单页（中英双语，data-zh / data-en）
├── pricing.html            # 价格与授权档位（英文）
├── pricing.zh.html         # 价格与授权档位（中文）
├── terms.html              # 服务条款（英文）
├── terms.zh.html           # 服务条款（中文）
├── privacy.html            # 隐私政策（英文）
├── privacy.zh.html         # 隐私政策（中文）
├── license.html            # 软件授权协议（英文）
├── license.zh.html         # 软件授权协议（中文）
├── contact.html            # 联系方式（英文）
├── contact.zh.html         # 联系方式（中文）
├── robots.txt
├── sitemap.xml
├── assets/
│   ├── css/style.css
│   ├── js/main.js          # 首页语言切换（localStorage 记忆）
│   ├── js/legal-lang.js    # 法律页中英文自动切换
│   ├── logo.svg            # 完整 logo（含文字）
│   └── logo-mark.svg       # 图标
├── favicon.ico
└── .nojekyll
```

## 路线图与版本记录

- 官网 `index.html` 的 `#roadmap` 区块同时维护**产品路线**与**版本记录**，面向用户，不写内部实现。2.x 已发布到 2.2.0，3.x 仍为规划。
- 发布新版本时，在 `#roadmap` 的版本记录里加一条，保留最近 3–4 个即可；发行包只通过面包多 / Creem 交付，不在 GitHub Releases 公开下载。
- 文案口径：2.x 的**新增 AI 能力**属于商业版，通过**离线 License 解锁**，解锁后在配置中心开启；**原有免费功能继续免费**。3.x 仍为规划。路线图文案不要写价格或账单类字眼。
- 2.x 已发布：2.0 权限内数据问答、2.1 知识库 + 浏览器语音、2.2 H5 对外客服 + 转人工 + 渠道品牌 + Skill 测试。按用户价值写，不写内核版本、License 功能位等内部实现。
- 路线图状态用「已发布 / 规划中 / 远期规划」，不写具体交付日期，避免变成承诺。

## 维护

- 文案改 `index.html`：`<span data-zh>…</span><span data-en>…</span>` 成对出现。
- 配色改 `assets/css/style.css` 顶部 `:root` 变量（主色 `--indigo`）。
- 后续新增案例项目时，在 `#ecosystem` 区块加一张卡片即可。

## 许可

© GewuMind。logo 与文案版权归 GewuMind 所有。
