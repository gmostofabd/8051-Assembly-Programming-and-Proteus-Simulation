<p align="justify">
  <h1>⚙️ 8051 Microcontroller Tutorials: Assembly Programming and Proteus Simulation ⚙️</h1>
</p>

<p align="center">
  <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/50abc7df1a1c73bb041c7264b61e53264fb06102/assets/images/ATMEL%208051%20Tutorials_Banner_x8.gif" alt="8051 Microcontroller Tutorials Banner" width="90%">
</p>

<div style="font-size: 1.5em; text-align: justify;">
  <strong>Welcome to the 8051 Microcontroller Tutorials Repository!</strong><br>
  This repository offers a comprehensive collection of tutorials and practical examples focused on programming <a href="https://www.microchip.com/en-us/product/AT89S51" style="color: blue;">ATMEL 8051 Series Microcontrollers</a> such as <strong>AT89C51</strong>, <strong>AT89S51</strong>, and <strong>AT89S52</strong>, using <strong>Assembly Language</strong>. Each example is simulated in<a href="https://www.labcenter.com/" style="color: blue;">Proteus</a> and, in most cases, verified on real hardware, making it ideal for both 
  <strong>beginners</strong> and <strong>enthusiasts</strong> looking to learn the fundamentals of 8051 programming, circuit simulation, and customization.
</div>

<br/>

---

<br/>
<br/>

<p align="center">
  <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/d64485f4fdac3459c1e21645996f41fdb1fb79ff/assets/images/8051_Assembly_Tutorials.png" alt="8051 Microcontroller Tutorials Banner" width="80%">
</p>

<br/>
<br/>

<hr/>

## ✨ **Features of this Repository**

<table>
  <tr>
    <td width="30%" align="center">
      <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/d64485f4fdac3459c1e21645996f41fdb1fb79ff/assets/images/8051_Assembly_Tutorials.png" alt="8051 Microcontroller Tutorials Banner" width="90%">
    </td>
    <td width="70%" style="vertical-align: top; padding-left: 20px;">
      <h3>Features:</h3>
      <ul>
        <li><strong>8051 Series Microcontrollers:</strong> Learn to program <strong>AT89C51</strong>, <strong>AT89S51</strong>, and <strong>AT89S52</strong> microcontrollers.</li>
        <li><strong>Assembly Language Programming:</strong> Tutorials are written in <strong>Assembly Language</strong> (.asm), providing hands-on experience with low-level programming.</li>
        <li><strong>Proteus Simulation:</strong> Simulate circuits and test the code before deploying it on real hardware using <strong>Proteus</strong> (.pdsprj).</li>
        <li><strong>Hardware Verification:</strong> Many examples are tested on real hardware to ensure the simulations' accuracy.</li>
        <li><strong>Beginner-Friendly:</strong> Perfect for <strong>beginners</strong> and enthusiasts looking to grasp the fundamentals of 8051 microcontroller programming and simulation.</li>
        <li><strong>Links and Guides:</strong> Includes essential references and links to help <strong>learners</strong> and enthusiasts further explore and learn from the best resources.</li>
        <li><strong>Multiple Versions for Learning:</strong> Some folders may contain multiple versions of the same files, showcasing alternative methods, cross-logic explanations, or feature variations to enhance understanding.</li>
      </ul>
    </td>
  </tr>
</table>

<br/>
 <br/>
<br/>


---


## 📄 **Included Files:**


<br/>

- 🔧 **Assembly Code**: Source code for each specific **8051 example**, available in `.asm` format for hands-on learning.

- 🖥️ **Proteus Simulation Files**: Pre-built simulation files in `.pdsprj` format, allowing you to **test** and **visualize** the circuit before hardware implementation.

- 📦 **HEX File**: Precompiled **HEX** file (`.hex`), ready for direct upload to the **microcontroller**.

- 📸 **Screenshots & Photos**: Visual documentation, showcasing successful testing on both **Proteus** and real hardware, typically available in `.png` or `.jpg` formats.


> **Note:**  
> Ensure that you have the correct versions of:
> - **[Proteus](https://www.labcenter.com/downloads/)** 
> - **ATMEL 8051 Microcontroller Toolchain**  
> installed on your system for smooth simulation and compilation.
>  
> You can find the setup instructions and download links in the repository's **[Setup Instructions](#setup-instructions)** section.



<p align="center"><strong>An example for interfacing an LCD to 8051 microcontrollers below: </strong></p>
<br/>

| ![Proteus ISIS](https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/f54f0f805807fdc7c9aaaccc91daf914335589d8/assets/images/89S52_400x400.png?raw=true) | ![Proteus ARES](https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/f54f0f805807fdc7c9aaaccc91daf914335589d8/assets/images/asmCode.png?raw=true) | ![3D CAD Models](https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/f54f0f805807fdc7c9aaaccc91daf914335589d8/assets/images/8051LCDx1.png?raw=true) |
| :--: | :--: | :--: |
| **8051 Microntroller** | **Assembly Code** | **Circuit Schematic** |

<br/>
<br/>
<br/>

---




## 🚀 **8051 Overview**
<p align="justify" style="background-color: white; color: black;">
The <a href="https://en.wikipedia.org/wiki/8051" target="_blank"><strong>8051 microcontroller</strong></a> was designed by Intel in 1981. It is an <a href="https://en.wikipedia.org/wiki/8-bit" target="_blank"><strong>8-bit microcontroller</strong></a> built with a <a href="https://en.wikipedia.org/wiki/Dual-inline_package" target="_blank"><strong>40-pin DIP (dual inline package)</strong></a>, 4KB of <a href="https://en.wikipedia.org/wiki/Read-only_memory" target="_blank"><strong>ROM storage</strong></a>, and 128 bytes of <a href="https://en.wikipedia.org/wiki/Random-access_memory" target="_blank"><strong>RAM storage</strong></a>. It consists of <a href="https://en.wikipedia.org/wiki/Timer" target="_blank"><strong>two 16-bit timers</strong></a> and four parallel <a href="https://en.wikipedia.org/wiki/Port_(computing)" target="_blank"><strong>8-bit ports</strong></a>, which are programmable and addressable as per the requirement.
</p>

<br/>

## 📊 **8051 Microcontroller Pin Diagram and Architecture**

<div align="center">

<table style="table-layout: fixed; width: 100%; border-collapse: collapse;">
  <tr>
    <th style="width: 50%; text-align: center;">**Pin Diagram**</th>
    <th style="width: 50%; text-align: center;">**Description**</th>
  </tr>
  <tr>
    <td style="text-align: center;">
      <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/5de037b5ac643153ca76238f1a3bf84399f4a651/assets/images/8051_Pinout.png" alt="Pin Diagram" style="width: 90%; max-width: 300px; height: auto;">
    </td>
    <td style="text-align: left;">
      <strong>Pin Number</strong><br>
      1. <strong>P1.0</strong> to <strong>P1.7</strong>: I/O pins.<br>
      2. <strong>RST</strong>: Reset pin.<br>
      3. <strong>P3.0</strong> to <strong>P3.7</strong>: I/O pins.<br>
      4. <strong>XTAL1, XTAL2</strong>: Oscillator pins.<br>
      5. <strong>GND</strong>: Ground.<br>
      6. <strong>P2.0</strong> to <strong>P2.7</strong>: I/O pins.<br>
      7. <strong>PSEN</strong>: Program Store Enable.<br>
      8. <strong>ALE</strong>: Address Latch Enable.<br>
      9. <strong>EA</strong>: External Access.<br>
      10. <strong>P0.0</strong> to <strong>P0.7</strong>: I/O pins.<br>
      11. <strong>VCC</strong>: Power supply.
    </td>
  </tr>
  <tr>
    <td style="text-align: center;">
      <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8c91f06977be065d33401416ffc6ee5ed12fe402/assets/images/8051_Architecture.png" alt="8051 Architecture" style="width: 90%; max-width: 300px; height: auto;">
    </td>
    <td style="text-align: left;">
      <strong>Architecture Overview</strong><br>
      The <strong>8051 microcontroller architecture</strong> consists of a CPU, memory (both RAM and ROM), I/O ports, and timer/counter modules, allowing for a versatile and efficient design. The key components include:<br>
      1. <strong>ALU</strong>: Performs operations.<br>
      2. <strong>Registers</strong>: Temporary storage.<br>
      3. <strong>Control Unit</strong>: Manages execution.<br>
      4. <strong>Bus System</strong>: Component communication.<br>
      5. <strong>Timer/Counters</strong>: Timing and counting operations.
    </td>
  </tr>
</table>

</div>

<br/>

---

### ✨ Minimum Circuit to Activate 8051 Microcontroller ✨

| **Circuit Diagram**                                                                                                                                                                                                                                      | **Key Components**                                                                                                                                                                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/f4d9c4baa06fa41dd1303054b56519bc5a94f184/assets/images/8051%20minimum%20ckt.png" alt="8051 Microcontroller Tutorials Banner" width="70%"> </p> | - **VCC**: Power supply to the 8051 microcontroller. <br> - **GND**: Ground connection. <br> - **XTAL1, XTAL2**: Connected to an **11.0592 MHz crystal oscillator**. <br> - **33 pF capacitors**: Connected between the crystal and ground. <br> - **RST (Reset pin)**: Connected to a **10kΩ pull-up resistor** and a **10 µF capacitor** to handle reset operations. <br> - **EA (External Access)**: Tied to **VCC** to use internal memory. <br> - **ALE (Address Latch Enable)** and **PSEN (Program Store Enable)**: Connected to **VCC** for normal operation. |

<hr/>

<br/>



## <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/072eeff0c330a1aa9c9341f81307fd85a18b9706/assets/images/prg2.png" alt="Programming Icon" width="48" height="48" /> PROGRAMMING LANGUAGE FOR THE 8051

<p align="justify">
If you're interested in programming, you've likely already used a <a href="https://en.wikipedia.org/wiki/Programming_language" target="_blank"><strong>programming language</strong></a> to write or compile code. If not, it's a good idea to start with the basics before diving into microcontrollers. Writing code for the <a href="https://en.wikipedia.org/wiki/Intel_MCS-51" target="_blank"><strong>8051 Microcontroller</strong></a> is similar to general programming. Once you’ve chosen a language, you set up the development environment, and you're good to go!
</p>


### Programming Options for the 8051 Microcontroller:

Traditionally, you can program the 8051 microcontroller using two main languages:
- <a href="https://en.wikipedia.org/wiki/Assembly_language" target="_blank"><strong>Assembly Language</strong></a>
- <a href="https://en.wikipedia.org/wiki/C_(programming_language)" target="_blank"><strong>C Language</strong></a> (or Embedded C)

However, **advanced microcontrollers** now support a wider range of languages.

---

### <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/072eeff0c330a1aa9c9341f81307fd85a18b9706/assets/images/asm3.png" alt="Assembly Icon" width="48" height="48" /> **Assembly Language:**

- **Pros**: Direct control over hardware, highly efficient use of memory and processing.
- **Cons**: Harder to learn and manage due to its complexity.

<p align="justify">
<a href="https://en.wikipedia.org/wiki/Assembly_language" target="_blank"><strong>Assembly Language</strong></a> is a low-level programming language closely tied to the hardware. It uses <strong>mnemonics</strong> and hexadecimal codes to control the microcontroller’s actions. While it’s powerful, it can be more complex to write and understand.
</p>

---

### <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/072eeff0c330a1aa9c9341f81307fd85a18b9706/assets/images/c2.png" alt="C Programming Icon" width="48" height="48" /> **C Language:**

- **Pros**: Easier to write, more flexible, and widely supported.
- **Cons**: Less control over hardware compared to Assembly.

<p align="justify">
<a href="https://en.wikipedia.org/wiki/C_(programming_language)" target="_blank"><strong>C Language</strong></a> is a high-level language often used for microcontroller programming due to its balance between flexibility and performance. It's also supported by many **8051** development tools. If you’re already familiar with C++ or any high-level language, transitioning to C for microcontrollers is relatively simple.
</p>

---

### **Other Languages for Advanced Microcontrollers:**

Modern microcontrollers, especially advanced ones, can be programmed in languages beyond just Assembly and C. Some common options include:

1. **Python** (via **MicroPython**):
   - Python is now used on platforms like the **ESP32** and **Raspberry Pi Pico**. It’s great for quick prototyping and high-level control over hardware.
   - **Pros**: Easy to learn and write, widely supported.
   - **Cons**: Not as efficient as C or Assembly, especially for performance-critical applications.
   - Learn more about **MicroPython** [here](https://micropython.org/).

2. **JavaScript** (via **Node.js**):
   - JavaScript can be used to program microcontrollers, especially with **NodeMCU** boards that run on the **ESP8266** and **ESP32** platforms.
   - **Pros**: A well-known language for web developers.
   - **Cons**: Requires more overhead compared to C or Assembly.
   - Explore **Node.js for microcontrollers** [here](https://www.espruino.com/).

3. **Rust**:
   - Rust is gaining popularity in embedded systems due to its memory safety features and performance.
   - **Pros**: Safe, fast, and increasingly used for low-level programming.
   - **Cons**: Still developing support for some microcontroller platforms.
   - Discover **Rust for embedded systems** [here](https://www.rust-lang.org/what/embedded).

4. **Arduino** (using C++):
   - Arduino is a popular platform for beginners, using a simplified version of **C++**.
   - **Pros**: Simplifies hardware interaction with rich library support.
   - **Cons**: Less efficient than lower-level programming languages.
   - Get started with **Arduino programming** [here](https://www.arduino.cc/).

---

<br/>

### **Which Language Should You Choose for 8051?**

<p align="justify">
For the <a href="https://en.wikipedia.org/wiki/8051" target="_blank"><strong>8051 microcontroller</strong></a>, you’ll likely stick with <a href="https://en.wikipedia.org/wiki/Assembly_language" target="_blank"><strong>Assembly</strong></a> or <a href="https://en.wikipedia.org/wiki/C_(programming_language)" target="_blank"><strong>C</strong></a> for most applications. However, if you’re working with more advanced microcontrollers, consider using languages like <a href="https://www.python.org/" target="_blank"><strong>Python</strong></a> or <a href="https://www.rust-lang.org/" target="_blank"><strong>Rust</strong></a> for added flexibility and ease.
</p>

- <a href="https://en.wikipedia.org/wiki/Assembly_language" target="_blank"><strong>Assembly Language</strong></a>: Best if you need full control over the microcontroller’s resources and performance.
- <a href="https://en.wikipedia.org/wiki/C_(programming_language)" target="_blank"><strong>C Language</strong></a>: Ideal for most projects due to its ease of use and balanced performance.
- <a href="https://www.python.org/" target="_blank"><strong>Python</strong></a> and Other High-Level Languages: Great for rapid development, but less efficient in low-level control.

#### **Recommendation:**

<p align="justify">
If you’re new to microcontroller programming, start with <a href="https://en.wikipedia.org/wiki/Assembly_language" target="_blank"><strong>Assembly</strong></a> to understand the basics, then move to <a href="https://en.wikipedia.org/wiki/C_(programming_language)" target="_blank"><strong>C</strong></a> for more complex projects. For advanced platforms, explore other languages like <a href="https://www.python.org/" target="_blank"><strong>Python</strong></a> or <a href="https://www.rust-lang.org/" target="_blank"><strong>Rust</strong></a> for faster development with high-level features.
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

   **Both codes will blink an LED connected to P1.0 of the 8051 microcontroller.**


<hr/>



## 📦 **Getting Started**

<p align="justify">
Each example in this repository is a folder containing the necessary files for programming the **8051 microcontroller** in Assembly, simulating it using **Proteus**, and downloading the compiled program to hardware via **avrdudes**.
</p>

---

<br/>


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


 <br/>
<br/>
<br/>



---

### ⚗️ Best Assembler for 8051: MIDE-51

**MIDE-51** is widely regarded as one of the best assemblers for programming the **8051 microcontroller** family. Here are some key reasons why MIDE-51 stands out:

1. **User-Friendly Interface**: MIDE-51 features an intuitive graphical user interface that simplifies the coding process, making it accessible for both beginners and experienced programmers. It provides easy navigation through the code and quick access to various features.

2. **Integrated Debugging Tools**: One of MIDE-51's strongest points is its integrated debugging capabilities. Users can simulate their programs, step through the code, and monitor register and memory values in real-time, which greatly enhances the debugging experience.

3. **Support for Multiple Devices**: MIDE-51 supports various 8051 microcontroller variants, including the **AT89C51**, **AT89S51**, and **AT89S52**. This flexibility allows developers to write code that can be easily adapted for different microcontrollers within the 8051 family.

4. **Rich Documentation and Examples**: MIDE-51 comes with comprehensive documentation and numerous example projects that help users learn quickly. The availability of tutorials and sample code accelerates the learning curve for new users.

5. **Assembly Language and C Support**: While MIDE-51 is primarily an assembler, it also supports the C programming language through integration with **Keil C51**. This allows users to choose the programming paradigm that best suits their project requirements.

6. **Cost-Effective**: MIDE-51 is available as a free version with essential features, making it an economical choice for hobbyists and educational purposes. The professional version offers additional features at a reasonable price, ensuring value for money.

Overall, MIDE-51 is an excellent choice for programming 8051 microcontrollers. Its user-friendly design, robust debugging tools, and support for multiple devices make it suitable for both beginners and advanced users. Whether you're working on a simple project or a complex application, MIDE-51 can meet your development needs effectively.


<br/>
<br/>
<br/>

---

## ✨ **Requirements:**

### **Software:**
- **[MIDE-51](https://www.opcube.com/)** – IDE for writing and compiling Assembly code for 8051.
- **[avrdudes](http://savannah.nongnu.org/projects/avrdude)** – Uploads compiled programs to hardware.
- **[Proteus Design Suite](https://www.labcenter.com/downloads/)** – Circuit simulation software.

### ✨ **Hardware:**
- **MK-51S Microcontroller Development Kit**

> **Note:** You can still follow along by using a **USBasp Programmer** and basic **components** for hands-on practice.

<br/>
<br/>
<br/>

---




## ⚗️ **Experiments Gallery**

<table>
  <tr>
    <td align="center" style="vertical-align: bottom;">
      <a href="https://gmostofabd.github.io/8051-LED/">
        <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LED/assets/images/LED_8051_Ckt.png?raw=true" alt="LED Blink" style="max-width: 100%; height: auto;">
      </a>
      <p><strong>Exp. 1: 8051 LED</strong></p>
      <p>This experiment demonstrates how to blink an LED using the 8051 microcontroller.</p>
    </td>
    <td align="center" style="vertical-align: center;">
      <a href="https://gmostofabd.github.io/8051-Push-Button/">
        <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20SSD%20Up%20Dn%20Counter/UP_DN_COUNTER.png?raw=true" alt="Push Button Interfacing" style="max-width: 100%; height: auto;">
      </a>
      <p><strong>Exp. 2: Push Button Interfacing</strong></p>
      <p>Learn how to interface a push button with the 8051 to control outputs.</p>
    </td>
    <td align="center" style="vertical-align: bottom;">
      <a href="https://gmostofabd.github.io/8051-7Segment/">
        <img src="https://github.com/gmostofabd/melab-store/blob/main/8051%20Examples%20Simulation%20ScrnShots/8051%20Traffic%20Lights2.png?raw=true" alt="Seven Segment Display" style="max-width: 100%; height: auto;">
      </a>
      <p><strong>Exp. 3: Seven Segment Display</strong></p>
      <p>Discover how to interface and display numbers on a seven-segment display.</p>
    </td>
  </tr>
</table>


| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20DOT%20Matrix%20LED/8051%20DOT%20Matrix%20LED.png">  8051 LED |  <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LCD/AT89C51_8_BIT_LCD_(RW_PIN_TO_GND).png"> 8051 Push Button | <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Stepper%20Motors/8051%20Stepper%20Motor.png?raw=true"> 8051 Stepper Motor|
|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/AD0804%20LED/Schematic.png?raw=true">  |  <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Basic%20Calculator/8051%20Basic%20calculator.png?raw=true">|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/melab-store/blob/main/8051%20Examples%20Simulation%20ScrnShots/8051%20L293D%20DC%20Motor.png?raw=true">|
|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Stepper%20Motors/8051%20Stepper%20Motor.png?raw=true">  |  <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LCD/AT89C51_8_BIT_LCD_(RW_PIN_TO_GND).png?raw=true">|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20DOT%20Matrix%20LED/8051%20DOT%20Matrix%20LED.png?raw=true">|


<br/>
<br/>

---

## 🏆 **Acknowledgments**

A huge **thank you** to the following incredible tools and teams for making this repository possible:

- **[MIDE-51](https://www.opcube.com/)** – for providing a feature-rich, user-friendly IDE that simplifies 8051 Assembly programming.
  
- **[avrdudes](http://savannah.nongnu.org/projects/avrdude)** – for the essential programmer tool that effortlessly bridges simulation and hardware deployment.
  
- **[Atmel (Microchip)](https://www.microchip.com/)** – for their legendary **8051 microcontroller series**, which remains an integral part of embedded systems learning.
  
- **[Proteus Design Suite](https://www.labcenter.com/downloads/)** – for their excellent circuit simulation platform that brings designs to life before hitting the hardware stage.


<br/>
<br/>

---

## 📝 **Upcoming Tasks**

- Verify the connections based on the schematic.
- Modify the code to display different messages.
- Experiment with the contrast and observe its effects.

---

# ⚙️ **Additional Informations**

### 🔗 **Resources**

- **8051 Microcontroller Reference**: [Datasheet](https://www.atmel.com/products/microcontrollers/8051.aspx)

<br/>
<br/>

---



### 🔗 **References:**

1. [8051 Microcontroller Overview](https://www.electronics-tutorials.ws/microcontroller/8051-microcontroller.html)
2. [Assembly Language Basics](https://en.wikipedia.org/wiki/Assembly_language)
3. [C Language for Embedded Systems](https://en.wikipedia.org/wiki/C_(programming_language))
4. [Microcontroller Programming Languages](https://en.wikipedia.org/wiki/Microcontroller#Programming_languages)
5. [MicroPython for Embedded Systems](https://micropython.org/)
6. [Rust for Embedded Systems](https://www.rust-lang.org/what/embedded)

---


## 🔗 **Connect with Me**

- GitHub: [gmostofabd](https://github.com/gmostofabd)
- LinkedIn: [Your LinkedIn Profile](https://www.linkedin.com/in/yourprofile)
- Website: [melab BD](https://www.melabbd.com)

<br/>
<br/>

---

## 📜 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 **Contributing**

Contributions, issues, and feature requests are welcome! Feel free to check out the [issues page](https://github.com/gmostofabd/your-repo/issues).

## ⭐ **Show Support**

If you find this project helpful, please give it a ⭐ to show your support!

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/gmostofabd">gmostofabd</a>
</p>
