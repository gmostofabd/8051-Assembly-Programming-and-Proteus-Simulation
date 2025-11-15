# 🔟 Interfacing a Seven Segment Display with 8051 Microcontroller  
A Complete Step-by-Step Tutorial (Assembly + Proteus Simulation)

---

## 📘 Introduction

Seven-segment displays are widely used to show decimal numbers in embedded systems.  
In this tutorial, you will learn:

- How a seven-segment display works  
- How to interface it with the **8051 microcontroller**  
- How to write **Assembly code** to display digits  
- How to simulate the circuit in **Proteus**  
- Tested output photos & video demonstration  
- Reference links for further learning  

This guide is suitable for **beginners**, **students**, and **hobbyists**.

---

## 🧰 Requirements

### 🔹 Hardware  
- AT89C51 / AT89S51 Microcontroller  
- Common Cathode Seven-Segment Display  
- 10kΩ Resistor Pack (optional)  
- 330Ω Current-limiting resistors  
- Breadboard / PCB  
- +5V Power Supply  

### 🔹 Software  
- **Keil uVision** (for Assembly programming)  
- **Proteus 8 Professional** (for simulation)  

---

## 🔤 Seven Segment Display Pin Mapping

| Segment | Pin | Description |
|--------|-----|-------------|
| a | 10 | Top segment |
| b | 9 | Upper right |
| c | 8 | Lower right |
| d | 7 | Bottom |
| e | 6 | Lower left |
| f | 5 | Upper left |
| g | 4 | Middle |
| dp | 3 | Decimal point |

💡 **We will use Port-1 of 8051** to drive segments:  
`P1.0 → a`, `P1.1 → b`, … `P1.6 → g`

---

## 🧮 Seven Segment HEX Codes (Common Cathode)

| Number | Segments ON | HEX Code |
|--------|-------------|----------|
| 0 | a b c d e f | `0x3F` |
| 1 | b c | `0x06` |
| 2 | a b d e g | `0x5B` |
| 3 | a b c d g | `0x4F` |
| 4 | f g b c | `0x66` |
| 5 | a f g c d | `0x6D` |
| 6 | a f e d c g | `0x7D` |
| 7 | a b c | `0x07` |
| 8 | All | `0x7F` |
| 9 | a b c d f g | `0x6F` |

---

## 💻 Assembly Code for Displaying 0–9 Continuously

```asm
;==================================
; Seven Segment Display with 8051
; Displays digits 0 to 9
; Port P1 -> Seven Segment
;==================================

ORG 0000H

MAIN:
    MOV DPTR, #LOOKUP     ; Point DPTR to lookup table

LOOP:
    MOV R0, #00H          ; Start from digit 0

NEXT_DIGIT:
    MOVC A, @A+DPTR       ; Read code from lookup table
    MOV P1, A             ; Output to Port 1
    ACALL DELAY           ; Delay for visibility
    INC R0                ; Next digit
    CJNE R0, #0AH, NEXT_DIGIT

    SJMP LOOP             ; Repeat forever

; Lookup Table (HEX codes)
LOOKUP:
    DB 3FH ; 0
    DB 06H ; 1
    DB 5BH ; 2
    DB 4FH ; 3
    DB 66H ; 4
    DB 6DH ; 5
    DB 7DH ; 6
    DB 07H ; 7
    DB 7FH ; 8
    DB 6FH ; 9

;=== Delay Subroutine ===
DELAY:
    MOV R1, #255
D1: MOV R2, #255
D2: DJNZ R2, D2
    DJNZ R1, D1
    RET

END
````

---

## 🧪 Proteus Simulation

### 🔧 Steps to Create Simulation

1. Open **Proteus 8 Professional**
2. Create a new project
3. Add components:

   * AT89C51
   * Seven Segment Display (Common Cathode)
   * Resistors
4. Connect **P1.0 – P1.6** to segments:

   * P1.0 → a
   * P1.1 → b
   * ...
   * P1.6 → g
5. Load the generated `.hex` file
6. Click **Run Simulation**

---

## 🖼️ Photos of Tested Runs

> *(Insert your test photos here in GitHub later)*

```md
![Proteus Circuit](images/circuit.png)
![Output Digit](images/output.jpg)
```

---

## 🎥 Video Demonstration

> *(Insert demo video link after upload)*

```md
[▶ Watch the Demo Video](https://your-video-link.com)
```

---

## 🔗 Similar Reference Links

* [https://exploreembedded.com/wiki/Seven_segment_with_8051](https://exploreembedded.com/wiki/Seven_segment_with_8051)
* [https://www.electronicsforu.com](https://www.electronicsforu.com)
* [https://microcontrollerslab.com](https://microcontrollerslab.com)
* [https://embeddedlab.com](https://embeddedlab.com)

---

## 📝 Conclusion

In this tutorial, you learned:

* Seven segment working
* Pin configuration
* Generating correct HEX codes
* Assembly program to display 0–9
* Proteus simulation setup

This is one of the most fundamental 8051 interfacing experiments.
You can now extend this to:

✔ Multiplexed 4-digit display
✔ Stopwatch
✔ Digital counter
✔ Sensor value display

---
