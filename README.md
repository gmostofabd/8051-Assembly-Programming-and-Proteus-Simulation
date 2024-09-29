<p align="center">
   <h1>⚙️ 8051 Microcontroller Tutorials: Assembly Programming and Proteus Simulation ⚙️</h1>
</p>

<p align="justify">
Welcome to the **8051 Microcontroller Tutorials** repository! This repository contains a collection of tutorials and practical examples focused on programming **ATMEL 8051 Series Microcontrollers** (AT89C51/AT89S51/AT89S52...) using **Assembly Language**. The examples are simulated in **Proteus** and verified on real hardware in most cases. This repository helps **beginners** and **enthusiasts** learn the fundamentals of 8051 programming, circuit simulation and adjust their custom needs.
</p>

<br/>

<p align="center"><strong>An example for interfacing an LCD to 8051 microcontrollers bellow: </strong></p>
<br/>

| ![Proteus ISIS](https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/f54f0f805807fdc7c9aaaccc91daf914335589d8/assets/images/89S52_400x400.png?raw=true) | ![Proteus ARES](https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/f54f0f805807fdc7c9aaaccc91daf914335589d8/assets/images/asmCode.png?raw=true) | ![3D CAD Models](https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/f54f0f805807fdc7c9aaaccc91daf914335589d8/assets/images/8051LCDx1.png?raw=true) |
| :--: | :--: | :--: |
| **8051 Microntroller** | **Assembly Code** | **Circuit Schematic** |

---

<br/>
<br/>

## 🚀 **Overview**

<p align="justify">
8051 microcontroller is designed by Intel in 1981. It is an 8-bit microcontroller. It is built with 40 pins DIP (dual inline package), 4kb of ROM storage and 128 bytes of RAM storage, 2 16-bit timers. It consists of are four parallel 8-bit ports, which are programmable as well as addressable as per the requirement.
</p>

##   PROGRAMMING LANGUAGE FOR THE 8051:

It depends on you which one you choose to program 8051 family of micro controllers as they can be programmed in assembly language as well as in “C” or we can say “Embedded C”


Assembly Language is a pseudo-English representation of the Machine Language. The 8051 Microcontroller Assembly Language is a combination of English like words called Mnemonics and Hexadecimal codes. It is also a low level language and requires extensive understanding of the architecture of the Microcontroller.

The best languages for programming the 8051 microcontroller are:

Assembly Language:
- Pros: Direct control over hardware, efficient use of memory and processing power, and fast execution speed.
- Cons: Steeper learning curve and more complex code management.
C Language:
- Pros: Easier to write and maintain than assembly, good level of abstraction, and widely supported with various libraries and tools.
- Cons: Slightly less efficient than assembly in terms of speed and memory usage.
C++:
- Pros: Object-oriented features can help in managing larger projects, and it still allows for low-level hardware access.
- Cons: More complex than C, and might not be supported by all compilers for 8051.
Recommendation

For most applications, C is often recommended due to its balance of efficiency, ease of use, and maintainability. However, if you need maximum performance and control, Assembly Language is the way to go.

<p align="justify">
Each example in this repository is a folder containing the necessary files for programming the **8051 microcontroller** in Assembly, simulating it using **Proteus**, and downloading the compiled program to hardware via **avrdudes**.
</p>

---
For Example, assume that an LED is connected to 8051 microcontroller on an I/O pin (e.g., P1.0), then here is the code for blinking the LED  of the 8051 microcontroller in both Assembly and C language shown below:

### **Assembly Code (8051)**

```asm
ORG 00H           ; Start at address 0
MAIN:             ; Main program label
    SETB P1.0     ; Set P1.0 (Turn LED off assuming active low)
    ACALL DELAY   ; Call delay subroutine
    CLR P1.0      ; Clear P1.0 (Turn LED on)
    ACALL DELAY   ; Call delay subroutine
    SJMP MAIN     ; Jump back to main (infinite loop)

; Delay subroutine
DELAY:    
    MOV R1, #250  ; Load R1 with 250
DELAY_LOOP1:
    MOV R2, #250  ; Load R2 with 250
DELAY_LOOP2:
    DJNZ R2, DELAY_LOOP2  ; Decrement R2 and jump if not zero
    DJNZ R1, DELAY_LOOP1  ; Decrement R1 and jump if not zero
    RET                     ; Return to the main program

END                ; End of program
```

### **Explanation (Assembly Code):**
- **P1.0:** This is the pin on Port 1 used to control the LED.
- **SETB P1.0:** Turns the LED off (if it’s active low, i.e., LED is turned on when the pin is low).
- **CLR P1.0:** Turns the LED on.
- **DELAY:** Subroutine to provide a simple delay. The delay is implemented using two nested loops.

### **C Code (8051)**

```c
#include <reg51.h>  // Header file for 8051 microcontroller

sbit LED = P1^0;    // Define LED on P1.0

void delay(void);   // Function declaration for delay

void main() {
    while (1) {     // Infinite loop
        LED = 0;    // Turn on LED (active low)
        delay();    // Call delay function
        LED = 1;    // Turn off LED
        delay();    // Call delay function
    }
}

void delay(void) {
    unsigned int i, j;
    for (i = 0; i < 250; i++) {
        for (j = 0; j < 250; j++) {
            // Do nothing, just waste some time
        }
    }
}
```

### **Explanation (C Code):**
- **sbit LED = P1^0:** Defines the bit that controls the LED connected to pin P1.0.
- **LED = 0;** Turns the LED on (assuming it's active low).
- **LED = 1;** Turns the LED off.
- **delay():** A simple delay function that uses two nested loops to create a delay.

Both codes will blink an LED connected to P1.0 of the 8051 microcontroller.
















<br/>

![8051_Assembly_Tutorials_Banner](https://github.com/user-attachments/assets/678d0c2d-5013-42d0-b386-b5f26191e00a)

## ✨ **Features**
- **Comprehensive 8051 Assembly Examples** for various peripherals
- Ready-to-use **Proteus simulation files**
- Well-commented **Assembly code** for easier learning
- Practical interfacing examples like LEDs, motors, sensors, and displays
- Tutorials on various communications among devices and more

---

## 📄 **Included Files:**
- **Assembly Code**: The code to drive the 8x8 dot matrix display using the 8051 microcontroller.
- **Proteus Simulation Files**: Pre-built simulation to test and visualize the circuit.
- **HEX File**: Ready-to-upload HEX code for the microcontroller.
- **Screenshots & Photos**: Visual proof of successful testing on both Proteus and hardware.

---

<br/>
<br/>

## 📦 **Getting Started**

### **Prerequisites:**

For a beginner to work with the examples in your **8051 Microcontroller Tutorials** repository, the following prerequisites would be helpful:

---

### 1. **Basic Electronics Knowledge**
   - **Understanding of components** like resistors, capacitors, LEDs, transistors, etc.
   - **Familiarity with circuits**, such as series and parallel configurations, basic Ohm’s Law, and power supply management.
   - **Experience with reading schematics** and wiring diagrams.

---

### 2. **8051 Microcontroller Fundamentals**
   - **Overview of microcontrollers**: What they are and how they work.
   - **Familiarity with the 8051 architecture**: Learn about its registers, memory organization, and basic instruction set.
   - **Basic understanding of Assembly language**: Knowledge of how Assembly commands work and their relationship to hardware control.

---

### 3. **Programming Concepts**
   - **Assembly Language**: 
     - **Basic instruction set** (like `MOV`, `ADD`, `SUB`, `JMP`, etc.).
     - **Registers and addressing modes** of the 8051.
     - How to write and compile simple Assembly programs.
   - Understanding how **memory and I/O ports** work in microcontrollers.

---

### 4. **Familiarity with Simulation and Development Tools**
   - **Proteus Design Suite**:
     - Basic proficiency in using Proteus to simulate circuits.
     - How to add components, run simulations, and debug.
   - **MIDE-51 IDE**: 
     - Knowledge of how to write, compile, and debug Assembly code in MIDE-51.
     - Familiarity with HEX file generation and loading into simulators or hardware.
    
---

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
<br/>
<br/>

## **Requirements:**

### **Software:**
- **[MIDE-51](https://www.opcube.com/)** – IDE for writing and compiling Assembly code for 8051.
- **[avrdudes](http://savannah.nongnu.org/projects/avrdude)** – Uploads compiled programs to hardware.
- **[Proteus Design Suite](https://www.labcenter.com/downloads/)** – Circuit simulation software.

### **Hardware:**
- **MK-51S Microcontroller Development Kit**

> **Note:** You can still follow along by using a **USBasp Programmer** and basic **components** for hands-on practice.

---
<br/>
<br/>



## ⚗️ **Experiments Gallery**

<table>
  <tr>
    <td align="center" style="vertical-align: bottom;">
      <a href="https://gmostofabd.github.io/8051-LED/">
        <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LED/assets/images/LED_8051_Ckt.png?raw=true" alt="LED Blink" style="max-width: 100%; height: auto;">
      </a>
      <p><strong>Experiment 1: LED Blink</strong></p>
      <p>This experiment demonstrates how to blink an LED using the 8051 microcontroller.</p>
    </td>
    <td align="center" style="vertical-align: center;">
      <a href="https://gmostofabd.github.io/8051-Push-Button/">
        <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20SSD%20Up%20Dn%20Counter/UP_DN_COUNTER.png?raw=true" alt="Push Button Interfacing" style="max-width: 100%; height: auto;">
      </a>
      <p><strong>Experiment 2: Push Button Interfacing</strong></p>
      <p>Learn how to interface a push button with the 8051 to control outputs.</p>
    </td>
    <td align="center" style="vertical-align: bottom;">
      <a href="https://gmostofabd.github.io/8051-7Segment/">
        <img src="https://github.com/gmostofabd/melab-store/blob/main/8051%20Examples%20Simulation%20ScrnShots/8051%20Traffic%20Lights2.png?raw=true" alt="Seven Segment Display" style="max-width: 100%; height: auto;">
      </a>
      <p><strong>Experiment 3: Seven Segment Display</strong></p>
      <p>Discover how to interface and display numbers on a seven-segment display.</p>
    </td>
  </tr>
</table>


| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20DOT%20Matrix%20LED/8051%20DOT%20Matrix%20LED.png">  8051 LED |  <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LCD/AT89C51_8_BIT_LCD_(RW_PIN_TO_GND).png"> 8051 Push Button | <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Stepper%20Motors/8051%20Stepper%20Motor.png?raw=true"> 8051 Stepper Motor|
|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/AD0804%20LED/Schematic.png?raw=true">  |  <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Basic%20Calculator/8051%20Basic%20calculator.png?raw=true">|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/melab-store/blob/main/8051%20Examples%20Simulation%20ScrnShots/8051%20L293D%20DC%20Motor.png?raw=true">|
|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Stepper%20Motors/8051%20Stepper%20Motor.png?raw=true">  |  <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LCD/AT89C51_8_BIT_LCD_(RW_PIN_TO_GND).png?raw=true">|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20DOT%20Matrix%20LED/8051%20DOT%20Matrix%20LED.png?raw=true">|






## 🏆 **Acknowledgments**

A huge **thank you** to the following incredible tools and teams for making this repository possible:

- **[MIDE-51](https://www.opcube.com/)** – for providing a feature-rich, user-friendly IDE that simplifies 8051 Assembly programming.
  
- **[avrdudes](http://savannah.nongnu.org/projects/avrdude)** – for the essential programmer tool that effortlessly bridges simulation and hardware deployment.
  
- **[Atmel (Microchip)](https://www.microchip.com/)** – for their legendary **8051 microcontroller series**, which remains an integral part of embedded systems learning.
  
- **[Proteus Design Suite](https://www.labcenter.com/downloads/)** – for their excellent circuit simulation platform that brings designs to life before hitting the hardware stage.

---


## 📝 **Tasks**

- Verify the connections based on the schematic.
- Modify the code to display different messages.
- Experiment with the contrast and observe its effects.

---
---
# ⚙️ **Additional Informations**
## 🔗 **Resources**

- **8051 Microcontroller Reference**: [Datasheet](https://www.atmel.com/products/microcontrollers/8051.aspx)
- **LCD Datasheet**: [HD44780 LCD Controller](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)

---

### 🛠️ **Future Work**
- Adding more functionalities such as scrolling text, custom characters, and additional interfacing techniques like 4-bit mode.
---
<p align="center">
  <img src="https://github.com/gmostofabd/8051-LCD/blob/82e89081c795286c466389d6ac5c34e6ec4a8050/assets/images/LCD_4B_8051_Ckt.png" alt="4-bit LCD Circuit" width="70%">
</p>
```


