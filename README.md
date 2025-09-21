# Robot Framework + JSONLibrary: ดึงและกรอง JSON ด้วย JSONPath

ตัวอย่างนี้แสดงวิธีการ **เรียก API, แปลง JSON, ดึงค่า และกรองข้อมูล** ด้วย Robot Framework โดยใช้ **RequestsLibrary** และ **JSONLibrary** พร้อมแนวทางกรองข้อมูลซับซ้อนด้วย Python

## 📦 Requirements

- Robot Framework >= 5.x  
- RequestsLibrary  
- JSONLibrary  

ติดตั้งผ่าน pip:

```bash
pip install robotframework
pip install robotframework-requests
pip install robotframework-jsonlibrary

```
---

# JSONPath คืออะไร
JSONPath เป็นภาษาที่ใช้ ระบุตำแหน่งข้อมูลใน JSON คล้าย XPath ของ XML
- ใช้ดึงค่าที่ต้องการจาก JSON
- รองรับ field, array, filter, slice, recursive
- ใช้ในการ API Testing, Automation, Data Extraction

## 1️⃣ Operators (ตัวดำเนินการหลัก)

Operators เหล่านี้ใช้สำหรับ **ระบุตำแหน่งข้อมูลใน JSON** ผ่าน JSONPath

| Operator | Description |
|----------|------------|
| `$` | Root element ของ JSON (เริ่มทุก path expression) |
| `@` | Current node ที่กำลังถูกประมวลผลใน filter |
| `*` | Wildcard → ใช้แทนชื่อ field หรือ index ของ array |
| `..` | Deep scan → ค้นหาทุกชื่อ field ที่ match ใน JSON |
| `.<name>` | Dot-notated child → เข้าถึง child โดยชื่อ |
| `['<name>' (, '<name>')]` | Bracket-notated child หรือหลายชื่อ field |
| `[<number> (, <number>)]` | Array index หรือหลาย index |
| `[start:end]` | Array slice operator |
| `[?(<expression>)]` | Filter expression → ต้องคืนค่า boolean |

## 2️⃣ Functions (เรียกใช้ท้าย path)

สามารถเรียกฟังก์ชันต่อท้าย path expression เพื่อทำ operation กับ array หรือ object

| Function     | Description                                    | Output type |
|-------------|-----------------------------------------------|------------|
| `min()`     | ค่าต่ำสุดของ array numbers                   | Double     |
| `max()`     | ค่าสูงสุดของ array numbers                   | Double     |
| `avg()`     | ค่าเฉลี่ยของ array numbers                   | Double     |
| `stddev()`  | Standard deviation ของ array numbers         | Double     |
| `length()`  | จำนวน element ของ array                       | Integer    |
| `sum()`     | ผลรวมของ array numbers                        | Double     |
| `keys()`    | ดึง property keys ของ object                  | Set<E>     |
| `concat(X)` | รวม path output กับ item ใหม่                 | เหมือน input |
| `append(X)` | เพิ่ม item ลงใน array ของ path output        | เหมือน input |
| `first()`   | ดึง element แรกของ array                      | ขึ้นกับ array |
| `last()`    | ดึง element สุดท้ายของ array                  | ขึ้นกับ array |
| `index(X)`  | ดึง element ของ array ตาม index X (ลบหมายถึงนับจากหลัง) | ขึ้นกับ array |

## 3️⃣ Filter Operators (กรอง array)

Filters ใช้กรอง element ของ array โดย `@` แทน element ปัจจุบัน  

| Operator     | Description |
|-------------|------------|
| `==`        | เท่ากับ (ตัวเลขกับ string ไม่เท่ากัน) |
| `!=`        | ไม่เท่ากับ |
| `<`         | น้อยกว่า |
| `<=`        | น้อยกว่าหรือเท่ากับ |
| `>`         | มากกว่า |
| `>=`        | มากกว่าหรือเท่ากับ |
| `=~`        | ตรงกับ regex `[?(@.name =~ /foo.*?/i)]` |
| `in`        | ค่าอยู่ใน array `[?(@.size in ['S','M'])]` |
| `nin`       | ค่าไม่อยู่ใน array |
| `subsetof`  | ค่าเป็น subset ของ array `[?(@.sizes subsetof ['S','M','L'])]` |
| `anyof`     | ค่า intersect กับ array `[?(@.sizes anyof ['M','L'])]` |
| `noneof`    | ค่าไม่มี intersection กับ array `[?(@.sizes noneof ['M','L'])]` |
| `size`      | ขนาด array หรือ string เท่ากับค่าที่ระบุ |
| `empty`     | array หรือ string ว่าง |

> **หมายเหตุ:** JSONLibrary ใช้ parser `jsonpath-ng` → รองรับ filter boolean แต่ **ไม่รองรับ regex หรือ startswith()** ต้องใช้ Python หลังจากดึง list

## 4️⃣ ตัวอย่าง JSONPath Expressions

| Expression | ผลลัพธ์ | ความหมาย |
|------------|---------|-----------|
| `$.users[*].name` | `["Eve","John","Emma"]` | ดึงชื่อทุกคน |
| `$..age` | `[25,30,22]` | ดึง field age ทุกที่ |
| `$.users[?(@.age > 23)].name` | `["Eve","John"]` | ชื่อผู้ที่อายุมากกว่า 23 |
| `$.users[?(@.roles anyof ['admin'])].name` | `["Eve"]` | ชื่อที่มี role admin |
| `$.users[?(@.name =~ /^E/)].name` | `["Eve","Emma"]` | ชื่อขึ้นต้นด้วย E (ต้อง regex support) |

---

## 🔹 Tips

- ใช้ `$..field` เพื่อ deep scan  
- ใช้ `[?()]` สำหรับ filter เงื่อนไข boolean  
- สำหรับ regex หรือ startswith → filter ด้วย Python list comprehension  
- Functions เช่น `length()`, `sum()`, `min()` สามารถใช้ต่อท้าย path expression ได้  

---

## 📌 References

- [JSONPath Syntax](https://goessner.net/articles/JsonPath/)  
- [Robot Framework JSONLibrary](https://robotframework-thailand.github.io/robotframework-jsonlibrary/)  
- [ReqRes API](https://reqres.in/)
