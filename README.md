<p align="center">
   <h1>⚙️ 8051 Microcontroller Tutorials: Assembly Programming and Proteus Simulation ⚙️</h1>
</p>

<p align="justify">
Welcome to the **8051 Microcontroller Tutorials** repository! This repository contains a collection of tutorials and practical examples focused on programming **ATMEL 8051 Series Microcontrollers** (AT89C51/AT89S51/AT89S52...) using **Assembly Language**. The examples are simulated in **Proteus** and verified on real hardware in most cases. This repository helps **beginners** and **enthusiasts** learn the fundamentals of 8051 programming, circuit simulation and adjust their custom needs.
</p>

---
<br/>

| ![Proteus ISIS](https://github.com/gmostofabd/Proteus-Libraries/blob/7d33b14fbae93d9d05113027c16cbb15cd9bd64c/assets/ISIS.png?raw=true) | ![Proteus ARES](https://github.com/gmostofabd/Proteus-Libraries/blob/7d33b14fbae93d9d05113027c16cbb15cd9bd64c/assets/ares.png?raw=true) | ![3D CAD Models](https://github.com/gmostofabd/Proteus-Libraries/blob/7d33b14fbae93d9d05113027c16cbb15cd9bd64c/assets/CAD.png?raw=true) |
| :--: | :--: | :--: |
| **Proteus Simulation Models** | **PCB Footprints** | **3D CAD Models** |





























## 🚀 **Overview**

![8051_Assembly_Tutorials_Banner](https://github.com/user-attachments/assets/678d0c2d-5013-42d0-b386-b5f26191e00a)

<p align="justify">
Each example is a folder containing the necessary files for programming the **8051 microcontroller** in Assembly, simulating it using **Proteus**, and downloading the compiled program to hardware via **avrdudes**.
</p>

---

## ✨ **Features**

- **Comprehensive 8051 Assembly Examples** for various peripherals
- Ready-to-use **Proteus simulation files**
- Well-commented **Assembly code** for easier learning
- Practical interfacing examples like LEDs, motors, sensors, and displays
- Tutorials on various communications among devices and more

---

## 📦 **Getting Started**

### **Prerequisites:**

For a beginner to work with the examples in your **8051 Microcontroller Tutorials** repository, the following prerequisites would be helpful:

### 1. **Basic Electronics Knowledge**
   - **Understanding of components** like resistors, capacitors, LEDs, transistors, etc.
   - **Familiarity with circuits**, such as series and parallel configurations, basic Ohm’s Law, and power supply management.
   - **Experience with reading schematics** and wiring diagrams.

### 2. **8051 Microcontroller Fundamentals**
   - **Overview of microcontrollers**: What they are and how they work.
   - **Familiarity with the 8051 architecture**: Learn about its registers, memory organization, and basic instruction set.
   - **Basic understanding of Assembly language**: Knowledge of how Assembly commands work and their relationship to hardware control.

### 3. **Programming Concepts**
   - **Assembly Language**: 
     - **Basic instruction set** (like `MOV`, `ADD`, `SUB`, `JMP`, etc.).
     - **Registers and addressing modes** of the 8051.
     - How to write and compile simple Assembly programs.
   - Understanding how **memory and I/O ports** work in microcontrollers.

### 4. **Familiarity with Simulation and Development Tools**
   - **Proteus Design Suite**:
     - Basic proficiency in using Proteus to simulate circuits.
     - How to add components, run simulations, and debug.
   - **MIDE-51 IDE**: 
     - Knowledge of how to write, compile, and debug Assembly code in MIDE-51.
     - Familiarity with HEX file generation and loading into simulators or hardware.
    
### 5. **The Programmer USBasp**

<p align="justify">
The **USBasp** is a widely-used, open-source programmer that enables seamless interfacing between a computer and various microcontrollers, including the **8051 series**. It was developed by Thomas Fischl and is known for being **affordable, easy-to-use**, and **compatible with multiple microcontroller architectures**.
</p>

#### Key Features:
- **Supports ISP (In-System Programming)**
- **Open-source and customizable**
- **Fast data transfer**
- **Cross-platform support**
- **Wide microcontroller support**

#### Setup and Use:
1. **USBasp Programmer**: Physical device to connect your PC to the microcontroller.
2. **AVRDude**: A command-line tool to upload the compiled Assembly or C code (.hex files).
3. **Driver Installation**: Use **Zadig** for Windows driver setup.

---

### **Requirements:**

#### **Software:**
- **[MIDE-51](https://www.opcube.com/)** – IDE for writing and compiling Assembly code for 8051.
- **[avrdudes](http://savannah.nongnu.org/projects/avrdude)** – Uploads compiled programs to hardware.
- **[Proteus Design Suite](https://www.labcenter.com/downloads/)** – Circuit simulation software.

#### **Hardware:**
- **MK-51S Microcontroller Development Kit**

> **Note:** You can still follow along by using a **USBasp Programmer** and basic **components** for hands-on practice.

---

## 📚 **Table of Contents**

1. [Experiment 1: LED Blink](#experiment-1-led-blink)
2. [Experiment 2: Push Button Interfacing](#experiment-2-push-button-interfacing)
3. [Experiment 3: Seven Segment Display](#experiment-3-seven-segment-display)
4. [Experiment 4: LED Dot Matrix](#experiment-4-led-dot-matrix)
5. [Experiment 5: LCD Interfacing](#experiment-5-lcd-interfacing)
6. [Experiment 6: Traffic Light Control](#experiment-6-traffic-light-control)
7. [Experiment 7: DC Motor Control](#experiment-7-dc-motor-control)
8. [Experiment 8: Ultrasonic Sensor](#experiment-8-ultrasonic-sensor)
9. [Experiment 9: Temperature Sensor](#experiment-9-temperature-sensor)
10. [Experiment 10: PWM Control](#experiment-10-pwm-control)

---

## ⚗️ **Experiments Section**

### Experiment 1: LED Blink
<p align="center">
   <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LED/assets/images/LED_8051_Ckt.png?raw=true" alt="LED Blink" width="700" height="400">
</p>
[8051 LED Blink](https://gmostofabd.github.io/8051-LED/) This experiment demonstrates how to blink an LED using the 8051 microcontroller.

---

### Experiment 2: Push Button Interfacing
<p align="center">
   <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20SSD%20Up%20Dn%20Counter/UP_DN_COUNTER.png?raw=true" alt="Push Button Interfacing" width="700" height="300">
</p>
[8051 Push Button Interfacing](https://gmostofabd.github.io/8051-Push-Button/) Learn how to interface a push button with the 8051 to control outputs.

---

### Experiment 3: Seven Segment Display
<p align="center">
   <img src="https://github.com/gmostofabd/melab-store/blob/main/8051%20Examples%20Simulation%20ScrnShots/8051%20Traffic%20Lights2.png?raw=true" alt="Seven Segment Display" width="700" height="450">
</p>
[8051 Seven Segment Display Interfacing](https://gmostofabd.github.io/8051-7Segment/) Discover how to interface and display numbers on a seven-segment display.

---

### Experiment 4: LED Dot Matrix
<p align="center">
   <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20DOT%20Matrix%20LED/8051%20DOT%20Matrix%20LED.png?raw=true" alt="LED Dot Matrix" width="700" height="400">
</p>
[8051 LED Dot Matrix Display Interfacing](https://gmostofabd.github.io/8051-LED-Matrix/) Interface an LED Dot Matrix to display patterns or scrolling text.

---

### Experiment 5: LCD Interfacing
<p align="center">
   <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LCD/AT89C51_8_BIT_LCD_(RW_PIN_TO_GND).png?raw=true" alt="LCD Interfacing" width="700" height="300">
</p>
[8051 LCD Interfacing](https://gmostofabd.github.io/8051-LCD/) Interface an LCD with the 8051 to display characters and messages.

---

### Experiment 6: Traffic Light Control
<p align="center">
   <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/main/Traffic%20Light%20Control.png?raw=true" alt="Traffic Light Control" width="700" height="400">
</p>
[8051 Traffic Light Control](

