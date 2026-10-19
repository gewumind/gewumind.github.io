# GewuMind 主页

GewuMind（格物智）的官方网站 / GitHub Pages 落地页，介绍 **GewuMind Boot**（AI 驱动的低代码后端容器，完整开源）与 **gewumind-skill**（可装进任意 AI Agent 的开发技能）。

纯静态单页，**零构建**：`index.html` + `assets/`（CSS / JS / logo），直接部署即可。

## 本地预览

```bash
python3 -m http.server 4000
# 打开 http://localhost:8000
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
最终地址为 `https://gewumind.github.io/homepage/`（`.nojekyll` 已就位，避免 Jekyll 处理）。

## 目录

```
gewumind-github-html/
├── index.html              # 单页（中英双语，data-zh / data-en）
├── assets/
│   ├── css/style.css
│   ├── js/main.js          # 语言切换（localStorage 记忆）
│   ├── logo.svg            # 完整 logo（含文字）
│   └── logo-mark.svg       # 图标
├── favicon.ico
└── .nojekyll
```

## 维护

- 文案改 `index.html`：`<span data-zh>…</span><span data-en>…</span>` 成对出现。
- 配色改 `assets/css/style.css` 顶部 `:root` 变量（主色 `--indigo`）。
- 后续新增案例项目时，在 `#ecosystem` 区块加一张卡片即可。

## 许可

© GewuMind。logo 与文案版权归 GewuMind 所有。
