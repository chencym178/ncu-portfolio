# 🐙 GitHub 注册 & 入门指南

> 目标：在 5 分钟内完成 GitHub 注册、头像、SSH / HTTPS 验证。

---

## 1. 注册 GitHub 账号

1. 打开浏览器：https://github.com/signup
2. 填写：
   - **Email**：**推荐用学校邮箱**（如 `xxx@stu.ncu.edu.cn`），万一以后有教育优惠可用
   - **Password**：12 字符以上，含大小写+数字+符号
   - **Username**：**慎重取名！**一旦确定基本不能改。建议英文+数字，例如 `zhangsan-ncu` / `lisi-ncu-2026`。这会成为你的**职业名片 ID**。
3. 验证邮件：去邮箱点验证链接
4. （可选）选择个人计划：选 **Free**
5. （可选）调查问卷：随便选，最后点 **"Skip this step"**

注册完成。

---

## 2. 完善 Profile（让简历感更强）

1. 右上角头像 → **Settings** → **Public profile**
2. 必填：
   - **Name**：`张三`
   - **Bio**：`南昌大学 · [专业] · 2026 级 · 在校生`
   - **Avatar**：换一张正经头像（避免二次元或非主流）

---

## 3. 创建一个公开仓库（一次性步骤）

1. 右上角 **「+」→「New repository」**
2. 填写：

   | 字段 | 填什么 |
   |---|---|
   | **Repository name** | `ncu-portfolio` |
   | **Description** | `南昌大学 · 个人课程作品集（学号 / 姓名 / 专业）` |
   | **Visibility** | ☑ **Public**（必须公开） |
   | **Initialize this repository with:** | ☑ **全部不勾**（要全空仓库） |

3. 点 **「Create repository」**
4. 跳到的页面上，**复制那个 HTTPS 链接**，形如：
   ```
   https://github.com/chencym178/ncu-portfolio.git
   ```
   把它发给你的结对顾问（我），用于替换仓库里的占位符。

---

## 4. 验证 SSH 或 HTTPS（首次 push 时浏览器会引导你登录，**这一步可忽略**）

GitHub 2021 年起 **HTTPS + 浏览器登录** 比 SSH 更省心。你直接按 `MANUAL_PUSH.md` 第 6 步走，弹窗浏览器走一遍 OAuth 就完事了，无需额外配置 SSH key。

---

## 5. 三个新手友好的"防呆小贴士"

1. **不要在仓库 Settings 里勾 "Template repository"**（一旦勾了，clone 下来的文件夹会少一些预设）
2. **不要勾 "Allow merge commits" 之外的复杂选项**（默认就行）
3. **不要把超过 50MB 的单文件 push 上去**（GitHub 会拒绝，并提示你用 Git LFS）

---

<p align="center">完成上面 3 步（注册 + 改 profile + 创建 `ncu-portfolio` 仓库）后，把仓库 URL 发给我的顾问，我帮你做最后的链接替换与验收。</p>
