# Temple Ruins — First 3D Game (Godot 4.7.2)

แบบฝึกหัดที่ 5: First 3D Game — เกม 3D Platformer 2 ฉาก
ต่อยอดจาก **3D Platformer Starter Kit** (SD Studios, CC0)

## วิธีเปิดโปรเจค
1. เปิด Godot **4.7.2**
2. Import โปรเจคโดยเลือกไฟล์ `project.godot` ในโฟลเดอร์นี้
3. กด F5 เพื่อเล่น (ฉากเริ่มต้นคือ `Scenes/MainMenu.tscn`)

## การควบคุม
| ปุ่ม | การทำงาน |
|---|---|
| W A S D / ลูกศร | เดิน |
| SPACE | กระโดด (กดซ้ำกลางอากาศขณะเคลื่อนที่ = ตีลังกา / double jump) |
| เมาส์ | หมุนกล้อง |
| R | เริ่มด่านปัจจุบันใหม่ |
| ESC | ปลดล็อกเมาส์ |

## กติกา
เก็บ **relic (เหรียญทอง)** ในฉากให้ครบ → ประตูจะเปิด → เดินเข้าประตูเพื่อไปด่านถัดไป
ระวังกับดัก (หนาม / ใบเลื่อย / ลูกตุ้มหนาม) และอย่าตกลงไปข้างล่าง

- **Level 1 — Temple Courtyard (ลานวัดร้าง)** : relic 10 ชิ้น
- **Level 2 — Deep Jungle (ป่าลึก)** : relic 12 ชิ้น

## โครงสร้างโปรเจค
```
Assets/
  Models/Character/Hero.glb        โมเดลผู้เล่นใหม่จาก Poly Pizza (Quaternius)
  Models/Character/HeroAnimations.tres  AnimationLibrary ที่ map ชื่อท่าใหม่ -> ชื่อเดิมของ Starter Kit
  Models/Nature/  Models/Props/    โมเดล low-poly จาก Poly Pizza (ย่อ texture เหลือ 256px)
  Models/Kit/                      โมเดลที่ติดมากับ Starter Kit
  Resources/mat_*.tres             วัสดุกลางของฉาก
Scenes/
  MainMenu.tscn  Level1.tscn  Level2.tscn  WinScreen.tscn
  Player.tscn  Collectible.tscn  Door.tscn  Checkpoint.tscn
  Spikes.tscn  SpikeTrap.tscn  SawBlade.tscn  SpikyBall.tscn
  MovingPlatform.tscn  DeadZone.tscn  GameUI.tscn
Scripts/                           GDScript ทั้งหมด
```

## การเปลี่ยนตัวละคร + ปรับ Animation (ข้อกำหนดของแบบฝึกหัด)
โมเดลเดิมของ Starter Kit คือ `gobot` ซึ่งมีท่า `Idle / Run / Jump / Flip`
โมเดลใหม่จาก Poly Pizza มีท่าชื่อ `HumanArmature|Man_*` จึงทำการ map ใหม่เป็น
AnimationLibrary (`Assets/Models/Character/HeroAnimations.tres`) ดังนี้

| ชื่อท่าเดิม (Starter Kit) | ท่าที่ map มาจากโมเดลใหม่ |
|---|---|
| Idle  | HumanArmature\|Man_Idle |
| Run   | HumanArmature\|Man_Run |
| Jump  | HumanArmature\|Man_Jump |
| Flip  | HumanArmature\|Man_RunningJump |
| Walk  | HumanArmature\|Man_Walk |
| Death | HumanArmature\|Man_Death |
| Cheer | HumanArmature\|Man_Clapping |

ทำให้ `Scripts/player.gd` เดิมที่เรียก `animation.play("Run")` ฯลฯ ใช้งานได้เหมือนเดิม

## Export เป็น Web
มี preset ชื่อ **Web** เตรียมไว้แล้ว (ปิด thread support เพื่อให้รันบน GitHub Pages ได้โดยไม่ต้องตั้ง header COOP/COEP)
Project > Export > Web > Export Project  →  ได้ไฟล์ `index.html` + `index.wasm` + `index.pck`
โฟลเดอร์ `build/web/` ในไฟล์แนบคือผลลัพธ์ที่ export ไว้แล้ว อัปโหลดขึ้น GitHub Pages ได้เลย

## เครดิตทรัพยากร (ทั้งหมดเป็น CC0)
- 3D Platformer Starter Kit — SD Studios (CC0)
- Animated Men Pack, Stylized Nature MegaKit, Ultimate Platformer Pack — Quaternius / poly.pizza (CC0)
