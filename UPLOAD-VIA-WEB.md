# 🚀 零安装上传指南（GitHub 网页操作）

> **适用人群**：不想在电脑上安装 Git，只想快速把作品集传到 GitHub 的同学。
> **总耗时**：约 5 分钟。
> **原理**：GitHub 网页版的「上传文件」功能，会自动在服务器端帮你完成 `git init` + `git commit`，效果和命令行完全一样。

---

## ✅ 前置检查

- [ ] 你已经有 GitHub 账号（本次使用账号：`chencym178`）
- [ ] 你的作品集文件已经在本地 `D:\第五周` 备好（26 个文件，已就绪 ✅）

---

## 第 1 步 · 创建空仓库（如果你还没建）

1. 浏览器打开：**https://github.com/new**

2. 填写页面上的字段（**只填这 4 处，其它一律留空**）：

   | 字段 | 填什么 |
   |---|---|
   | **Repository name** | `ncu-portfolio` |
   | **Description** | `南昌大学 · 个人课程作品集` |
   | **Visibility** | ⦿ **Public**（务必选中，不要选 Private） |
   | **Initialize this repository with** | ☐ 三个勾**全部取消**（不要勾 README / .gitignore / license） |

3. 滚到页底，点绿色按钮 **`Create repository`**

4. 🎯 你的仓库地址诞生了：
   ```
   https://github.com/chencym178/ncu-portfolio
   ```

> ⚠️ **为什么三个 Initialize 选项都不能勾？**
> 因为一旦勾了，GitHub 会先帮你生成一个初始 commit。之后你再上传文件时，两边内容会"打架"，导致上传失败或需要额外处理。勾了就得重来。

---

## 第 2 步 · 进入上传页面

在**空仓库首页**，你会看到一段灰底提示，里面有：

> **…or upload an existing file**

点它。或者点页面上的 **`Add file`** 下拉菜单 → 选 **`Upload files`**。

---

## 第 3 步 · 拖拽文件 ⭐ 最容易出错的一步

### ❌ 错误做法（90% 的新手会踩）
直接把桌面上的 **`第五周` 文件夹**整个拖进浏览器上传框。
**后果**：仓库根目录会多出一个 `第五周/` 子文件夹，你的 `README.md` 被埋在里面，首页看不到作品集。

### ✅ 正确做法

1. 用**文件资源管理器**（Win+E）打开 `D:\第五周`
2. **双击进入 `第五周` 文件夹内部**（地址栏显示 `D:\第五周`）
3. 按 **`Ctrl + A`** 全选里面的所有内容：
   ```
   ☑ .gitignore
   ☑ README.md
   ☑ MANUAL_PUSH.md
   ☑ UPLOAD-VIA-WEB.md
   ☑ setup.ps1
   ☑ assets（文件夹）
   ☑ docs（文件夹）
   ☑ weeks（文件夹）
   ```
4. 把**选中的这些内容**一起拖进浏览器上传框

> 🧠 **记忆口诀**：「**拖里边的东西，别拖那个袋子本身**」。

### 🔍 如果看不到 `.gitignore`
Windows 资源管理器默认**不隐藏**以点开头的文件，正常情况下你能看到它。
如果确实看不到：
- 资源管理器顶部 **查看** → 勾选 **隐藏的项目**

---

## 第 4 步 · 填写 Commit 信息 ⭐ 这一步就是"首个 Commit"

文件拖完后，页面**下方**会出现 **`Commit changes`** 区域，有两个输入框：

| 位置 | 填什么 |
|---|---|
| **上方短输入框**（commit 标题） | `chore: init NCU portfolio repo with 16-week skeleton` |
| **下方长输入框**（commit 描述，可选） | `南昌大学个人课程作品集 · 初始化 16 周实验骨架` |

然后确认**单选按钮**选中：
```
⦿ Commit directly to the main branch
```
（另一个 `Create a new branch...` 不要选）

---

## 第 5 步 · 点下绿色按钮

点击 **`Commit changes`**。

页面会跳转，显示"上传进度 → 完成"。

✅ **恭喜！这就是你的首个 Commit。**
它等价于命令行里执行了：
```bash
git init                                  # 初始化仓库
git add .                                 # 把所有文件加入暂存区
git commit -m "chore: init NCU portfolio repo..."   # 拍下第一张快照
```

---

## 第 6 步 · 验证成果

浏览器打开：
```
https://github.com/chencym178/ncu-portfolio
```

应该看到：

- [ ] 根目录下直接列着 `.gitignore`、`README.md`、`MANUAL_PUSH.md`、`setup.ps1`、`UPLOAD-VIA-WEB.md`（**没有多余的 `第五周/` 子目录**）
- [ ] `assets/`、`docs/`、`weeks/` 三个文件夹
- [ ] README 内容**自动渲染**在页面下方（能看到「南昌大学」标题和 16 周目录树）
- [ ] 页面右侧 commit 区域显示 `chore: init NCU portfolio repo with 16-week skeleton`
- [ ] 顶部标签显示 **Public**

全打勾 = **本课程主仓库初始化完成** 🎉

---

## ⚠️ 常见坑速查

| 现象 | 原因 | 解决 |
|---|---|---|
| 仓库首页看不到 README | 你传成了 `第五周/README.md` | 删除 `第五周/` 文件夹，按第 3 步重传 |
| 上传按钮是灰的，点不动 | 还没拖入文件 | 至少要拖入 1 个文件 |
| 提示文件太大 | 单文件 > 25MB | 我们文件都很小，不会遇到 |
| 上传半天不动 | 网络抖动 | 等 2 分钟，或刷新页面重拖 |
| 想改 commit message | 已提交后想改 | 网页上不好改，直接再传一次覆盖也行 |
| 后面老师要求"必须用命令行提交" | 老师看的是 commit 记录，不关心你怎么产生的 | 网页提交的 commit 和命令行 commit **完全等同**，放心 |

---

## 📚 后续每周怎么更新（网页方式）

1. 进仓库 → `Add file` → `Upload files`
2. 只拖拽**你本周新增/修改的文件**（例如只拖 `weeks/week-02-data-types-variables/` 这个文件夹）
3. 同名文件会自动**覆盖**旧版本
4. 填 commit 标题：`week-02: 完成数据类型练习`
5. 点 `Commit changes`

> 💡 **建议**：等你熟悉了网页流程，再考虑安装 Git 走命令行。**先跑通，再优化**。

---

<p align="center"><b>卡在哪一步，截图发你的结对顾问（我），我帮你 debug。</b></p>
