# Week 11 · 异常处理（try / except / finally）

> 🗓️ 学期第 11 周 ｜ 🎯 目标：让程序**不轻易崩溃**

## 本周交付物
- [ ] `main.py`：改造 Week 10 的记账本，让它在文件不存在、权限不足、数据格式错误时**给出友好提示**而非崩溃
- [ ] `notes.md`：整理 7 种常见 Python 内置异常

## 知识点速记
```python
try:
    do_something()
except FileNotFoundError as e:
    print(f"文件不存在: {e}")
except Exception as e:
    print(f"未知异常: {e}")
finally:
    cleanup()
```

## 学习笔记
\`\`\`
（这里写你的 notes.md 内容）
\`\`\`
