# Week 12 · 面向对象：类与对象

> 🗓️ 学期第 12 周 ｜ 🎯 目标：用"对象"建模现实世界

## 本周交付物
- [ ] `main.py`：定义 `Student` 类（属性：学号、姓名、专业；方法：`introduce()`）
- [ ] `notes.md`：解释 `class` / `object` / `__init__` / `self` 四件套

## 知识点速记
```python
class Student:
    def __init__(self, sid: str, name: str, major: str):
        self.sid = sid
        self.name = name
        self.major = major

    def introduce(self) -> str:
        return f"我是 {self.name}，学号 {self.sid}，{self.major} 专业。"
```

## 学习笔记
\`\`\`
（这里写你的 notes.md 内容）
\`\`\`
