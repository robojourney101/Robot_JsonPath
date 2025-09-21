# Robot Framework + JSONLibrary: ดึงและกรอง JSON ด้วย JSONPath

ตัวอย่างนี้แสดงวิธีการ **เรียก API, แปลง JSON, ดึงค่า และกรองข้อมูล** ด้วย Robot Framework โดยใช้ **RequestsLibrary** และ **JSONLibrary** พร้อมแนวทางกรองข้อมูลซับซ้อนด้วย Python

---

# JSONPath คืออะไร
JSONPath เป็นภาษาที่ใช้ ระบุตำแหน่งข้อมูลใน JSON คล้าย XPath ของ XML
- ใช้ดึงค่าที่ต้องการจาก JSON
- รองรับ field, array, filter, slice, recursive
- ใช้ในการ API Testing, Automation, Data Extraction

---

## 📦 Requirements

- Robot Framework >= 5.x  
- RequestsLibrary  
- JSONLibrary  

ติดตั้งผ่าน pip:

```bash
pip install robotframework
pip install robotframework-requests
pip install robotframework-jsonlibrary
