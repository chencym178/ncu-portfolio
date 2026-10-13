# 📦 远程仓库创建 & 首次推送完全指南

> 目标：把你在 `D:\第五周` 的本地文件夹，变成一个 GitHub 公开仓库，并完成首次 `commit + push`。
> 预计耗时：**8 分钟**（包括下载安装 Git）。

---

## 0. 当前进度快照（你已完成的）
- ✅ 工作目录 `D:\第五周` 已就位
- ✅ `.gitignore` 已生成
- ✅ `README.md` + 16 周目录骨架已生成
- ✅ 配套文档（术语字典、GitHub 注册指南、推送指南）已生成
- ❌ 待安装：**Git for Windows**
- ❌ 待创建：**GitHub 公开仓库**
- ❌ 待执行：**git init / add / commit / push**

---

## 1. 安装 Git for Windows（必做，只此一次）

> 👉 即使之前你选"我不想装 Git"，但要真正把代码推到 GitHub，这一步绕不开——本工具安装 ≈ 1 分钟，不弹广告、不写注册表垃圾，闭眼装即可。

1. 浏览器打开：**https://git-scm.com/download/win**
2. 下载会**自动开始**（64-bit installer，约 50MB）
3. 双击 `.exe` 安装，**所有选项保持默认，连点 Next 即可**。关键勾选项：

   - ✅ **"Git from the command line and also from 3rd-party software"**（默认就勾选）
   - ✅ **"Checkout Windows-style, commit Unix-style line endings"**（默认）
   - ✅ **"Use Windows' default console window"**（新手友好）
   - ⚠ 最后的 **"Enable experimental built-in add -A"** 可以不勾

4. 安装完**关闭当前 PowerShell，重新打开一个新的**（很重要，让 PATH 生效）

5. 验证安装成功：
   ```powershell
   git --version
   # 输出示例：git version 2.47.0.windows.1
   ```

---

## 2. 配置 Git 用户签名（必做，所有 git 提交都用得到）

打开 PowerShell，**顺序执行**：

```powershell
git config --global user.name  "你的GitHub用户名"
git config --global user.email "你的注册GitHub的邮箱"
git config --global init.defaultBranch main
```

> ⚠ 用户名和邮箱必须与 GitHub 账号保持一致，否则网页上头像上的贡献绿点不会亮。

---

## 3. 在 GitHub 网页上创建公开仓库（空仓库，不要勾任何初始化）

1. 登录 GitHub → 右上角 **「+」→「New repository」**
2. 填写：

   | 字段 | 填什么 |
   |---|---|
   | **Repository name** | `ncu-portfolio` |
   | **Description** | `南昌大学 · 个人课程作品集（学号 / 姓名 / 专业）`（替换占位符） |
   | **Visibility** | ☑ **Public**（必须公开） |
   | **Initialize this repository with:** | ☑ **不要勾** README / .gitignore / license（**全空仓库**，否则本地 push 会被拒绝） |

3. 点 **「Create repository」**
4. 跳到的新页面里，**复制 HTTPS 地址**，格式如下（替换 `chencym178`）：
   ```
   https://github.com/chencym178/ncu-portfolio.git
   ```
   这串就是你的**远程仓库 URL**，稍后会用到。

---

## 4. 一键初始化 + 首次提交 + 推送（PowerShell 全套命令）

> 请把命令里的 **`chencym178`** 替换为你真实的 GitHub 用户名！

打开 PowerShell，**完整复制下面整段**：

```powershell
# ① 进入工作目录
cd D:\第五周

# ② 初始化 git 仓库（生成 .git 隐藏目录）
git init
git branch -M main

# ③ 把所有文件加入暂存区（.gitignore 里列出的会被自动跳过）
git add .

# ④ 首次提交（commit 是一次"快照"，相当于给这堆文件拍个合影）
git commit -m "chore: init NCU portfolio repo with 16-week skeleton"

# ⑤ 关联远程仓库（把刚才复制的 URL 填进去）
git remote add origin https://github.com/chencym178/ncu-portfolio.git

# ⑥ 推到 GitHub（弹出登录窗口时选"Sign in with browser"，浏览器走一遍 OAuth）
git push -u origin main
```

执行成功后会显示：
```
Enumerating objects: 26, done.
Counting objects: 100% (26/26), done.
Writing objects: 100% (26/26), done.
Total 26 (delta 0), reused 0 (delta 0)
To https://github.com/chencym178/ncu-portfolio.git
 * [new branch]      main -> main
Branch 'main' is set up to track remote branch 'main' from 'origin'.
```

---

## 5. 验证成功 🎉

打开浏览器访问：
```
https://github.com/chencym178/ncu-portfolio
```
你应该能看到：
- ✅ 仓库名 + Description
- ✅ 文件列表（含 `.gitignore`、`README.md`、`MANUAL_PUSH.md`、`docs/`、`weeks/`）
- ✅ README 在首页**已自动渲染**（带南昌大学标识和 16 周目录树）

---

## 6. 推送失败常见 5 种情况

| 报错关键词 | 原因 | 解决 |
|---|---|---|
| `repository not found` | URL 里用户名打错 | 重新核对 `chencym178` |
| `Permission denied (publickey)` | 没配 SSH / 用 HTTPS 但没登录 | 确认第 6 步登录窗口走通 |
| `refusing to merge unrelated histories` | 远程已初始化（你勾了 README） | 回第 3 步，把 `Initialize` 选项全部取消 |
| `Updates were rejected` | 远程有 commit 本地没有 | 先 `git pull --rebase origin main` |
| 终端没反应 | PowerShell 没关重开 | 关掉重开 PowerShell |

---

## 7. 后续每周怎么更新

每完成一周实验后：
```powershell
cd D:\第五周
git add .
git commit -m "week-XX: <本次主题>"
git push
```

---

## 8. 推送完成后的验收清单（自检）

完成 `git push` 后，逐项核对：

- [ ] 浏览器打开 https://github.com/chencym178/ncu-portfolio 能看到文件列表（应含 `.gitignore` / `README.md` / `MANUAL_PUSH.md` / `docs/` / `weeks/`）
- [ ] README 首页已自动渲染，能看到「南昌大学」标题与 16 周目录树
- [ ] 仓库可见性标签显示为 **Public**
- [ ] 本地执行 `git log --oneline` 至少能看到 1 条 commit 记录
- [ ] 点开 `weeks/week-16-final-project/README.md` 能正常显示内容

> 🧾 全部打勾 = 本课程主仓库初始化完成 🎉
> 任意一项失败 = 截图发你的结对顾问 debug。

---

<p align="center"><b>第 4 步实在不会跑？把报错截图发给我，我帮你 debug。</b></p>
