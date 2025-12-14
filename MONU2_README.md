# 🌟 MONU2 - Super Creative Bangla Calculator

**The Most Colorful & Feature-Rich Bangla Programming Language!**

---

## ✨ NEW FEATURES in MONU2

### 1. **Double-Dot Statement Terminator**
- Use `..` instead of `;` to end statements
- More unique and creative!

### 2. **Full Bangla Keywords**
- `jodi` = if
- `taile` = then
- `naile` = else
- `shesh` = end
- `hoy` = condition marker

### 3. **Bangla Comparison Operators** 🆕
- `theke boro` = greater than (>)
- `theke choto` = less than (<)
- `theke boro othoba soman` = greater or equal (>=)
- `theke choto othoba soman` = less or equal (<=)
- `soman soman` = equal (==)
- `soman na` = not equal (!=)

### 4. **Super Colorful Interface** 🎨
- Background colors
- Blinking text effects
- Alternating result colors
- Professional presentation

---

## 🚀 Quick Start

### Compile:
```bash
cd /e/cd
bison -d monu2.y
flex monu2.l
gcc -o monu2.exe monu2.tab.c lex.yy.c
```

### Run:
```bash
./monu2.exe < monu2_demo.txt
```

---

## 📝 Syntax Examples

### Basic Arithmetic:
```
store x 10 ..
store y 20 ..
dekhao x jog koro y ..
dekhao x gun koro y ..
```

### Comparisons:
```
dekhao x theke choto y ..          # x < y
dekhao x soman soman 10 ..         # x == 10
dekhao x theke boro othoba soman 5 ..  # x >= 5
```

### Conditionals:
```
jodi ( x theke choto y ) hoy taile 
    dekhao 100 .. 
shesh

jodi ( x soman soman 10 ) hoy taile 
    dekhao 999 .. 
naile 
    dekhao 0 .. 
shesh
```

### Complex Example:
```
o monu shuru koro//

store age 18 ..
store score 85 ..

jodi ( age theke boro othoba soman 18 ) hoy taile 
    jodi ( score theke boro 80 ) hoy taile 
        dekhao 1 ..  # Adult with good score
    naile 
        dekhao 0 ..  # Adult with low score
    shesh
naile 
    dekhao minus 1 ..  # Not adult
shesh

o monu eibar sesh koro//
```

---

## 🎨 Colorful Features

### Interface Colors:
- **Magenta Background** - Title
- **Cyan** - Borders and separators
- **Yellow** - Headers and titles
- **Green** - Success messages
- **Blue** - Commands
- **Magenta** - Comparison operators
- **Red** - Errors and finish command

### Special Effects:
- **Blinking text** for activation/finishing
- **Background colors** for emphasis
- **Alternating colors** for results
- **Bold text** for important info

---

## 📊 Complete Operator List

### Arithmetic:
| Bangla | English | Symbol |
|--------|---------|--------|
| jog koro | addition | + |
| biyog koro | subtraction | - |
| gun koro | multiplication | * |
| vag koro | division | / |

### Comparison:
| Bangla | English | Symbol |
|--------|---------|--------|
| theke boro | greater than | > |
| theke choto | less than | < |
| theke boro othoba soman | greater or equal | >= |
| theke choto othoba soman | less or equal | <= |
| soman soman | equal | == |
| soman na | not equal | != |

---

## 🏆 Why MONU2 Will Impress Your Teacher

✅ **Maximum Creativity** - Unique double-dot syntax  
✅ **Full Bangla** - Complete local language support  
✅ **Comparison Operators** - Advanced functionality  
✅ **Super Colorful** - Eye-catching interface  
✅ **Float Support** - Professional calculator  
✅ **Nested Conditionals** - Complex logic support  
✅ **Error Handling** - Bangla error messages  
✅ **MSYS2 Compatible** - Works perfectly!  

---

## 🎓 Educational Value

Demonstrates:
- Lexical analysis with multi-word tokens
- Operator precedence (comparison vs arithmetic)
- Float arithmetic with comparisons
- Symbol table implementation
- Conditional expression evaluation
- Creative language design
- Cultural programming concepts
- ANSI color terminal programming

---

**This is the MOST creative Bangla programming language project!** 🌟

Get ready for maximum marks! 🏆
