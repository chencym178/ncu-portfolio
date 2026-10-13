# 🗂️ 静态资源目录

存放与本作品集相关的图片、证书 PDF、Logo、截图等**非代码**资源。

## 当前内容

```
assets/
├── README.md              本说明文件
└── ncu-banner.svg         🏫 南昌大学标识横幅（README 顶部引用）
```

> `ncu-banner.svg` 是**手绘 SVG 示意图**（红五星 + 赣江水纹 + 翠绿山体 + 校训），
> 不含官方校徽图形文件，可安全公开分发。矢量格式，任意缩放不糊，体积仅几 KB。

## 建议扩充结构

```
assets/
├── ncu-banner.svg         现有横幅
├── screenshots/           各类运行截图
│   ├── week-01-env-setup.png
│   └── ...
└── certificates/          证书、奖项
```

## 使用方式

在 Markdown 中引用（相对路径，GitHub 上可直接渲染）：

```markdown
<p align="center">
  <img src="./assets/ncu-banner.svg" alt="南昌大学 · 个人课程作品集" width="100%">
</p>
```

## ⚠️ 注意事项

- 💡 **大文件（>50MB）请勿放入仓库**。如确需存放视频、模型权重等超大文件，请使用 **Git LFS**，或放到外部网盘后在 README 里贴链接。
- 🔒 **不要放入含个人敏感信息的截图**（身份证、成绩单原件、手机号、家庭住址等），公开仓库任何人可见。
- 🧭 文件命名建议统一为小写 + 连字符，例如 `week-03-operator-demo.png`，避免中文名和空格（跨平台兼容性更好）。
