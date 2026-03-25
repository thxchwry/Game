# Simple Rhythm Game (Processing / Java) 🎵🎮

โปรเจกต์เกมกดตามจังหวะเพลงที่พัฒนาด้วย **Processing** โดยใช้ภาษา **Java** เป็นหลัก ตัวเกมเน้นการตอบสนองที่รวดเร็วและการซิงค์ข้อมูลระหว่างไฟล์เสียงและกราฟิกบนหน้าจอ

---

## 🔍 ภาพรวมของโปรเจกต์

ระบบถูกพัฒนาขึ้นเพื่อสร้างประสบการณ์เกมมิ่งในรูปแบบ Rhythm Game ผู้เล่นจะต้องกดปุ่มให้ตรงกับโน้ตที่เลื่อนลงมาตามจังหวะเพลงยอดนิยม (เช่น _Birds of a Feather_, _About You_) โดยมีการคำนวณคะแนนตามความแม่นยำ และมีหน้าจออินเทอร์เฟซที่แสดงผลทั้งสถานะเริ่มต้น (Home), หน้าจอขณะเล่น (Play) และหน้าจอสรุปคะแนน (Game Over)

โปรเจกต์นี้เหมาะสำหรับศึกษาเรื่อง **Collision Detection**, **Game State Management**, **Audio Library Integration** และการทำ **Real-time Rendering**

---

## 🛠️ เทคโนโลยีที่ใช้

- **Development Environment**: Processing IDE
- **Language**: Java (Processing Language)
- **Audio Library**: Minim (สำหรับจัดการไฟล์เพลงและการวิเคราะห์จังหวะ)
- **Graphic Assets**: PNG images & PImage class

---

## 📂 โครงสร้างโปรเจกต์โดยย่อ

```text
game/
├── Project.pde           # โค้ดหลักของเกม (Setup, Draw, Game Logic)
├── data/                 # แหล่งเก็บทรัพยากรที่ใช้ในเกม
│   ├── 01.png - 04.png   # ภาพประกอบ Background และ UI
│   ├── BIRDS OF A FEATHER.mp3 # ไฟล์เพลงประกอบ
│   ├── About You.mp3     # ไฟล์เพลงประกอบ
│   └── Thats So True.mp3 # ไฟล์เพลงประกอบ
└── README.md             # ไฟล์อธิบายโปรเจกต์
```
