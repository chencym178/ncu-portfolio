# Week 13 · 面向对象：继承与多态

> 🗓️ 学期第 13 周 ｜ 🎯 目标：让类**复用**与**多变**

## 本周交付物
- [ ] `main.py`：构建 3 层继承树：`Animal → Dog/Cat → 具体犬种/猫种`，并演示多态（同一 `speak()` 方法，调用结果不同）
- [ ] `notes.md`：对比"继承"与"组合"两种复用方式的优劣

## 知识点速记
```python
class Animal:
    def speak(self): raise NotImplementedError

class Dog(Animal):
    def speak(self): return "汪！"
```

## 学习笔记
\`\`\`
（这里写你的 notes.md 内容）
\`\`\`
