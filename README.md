<p align="center">
   <h1>⚙️ <strong>8051 Microcontroller Tutorials: Assembly Programming & Proteus Simulation</strong> ⚙️</h1>
</p>

---
Welcome to the **8051 Microcontroller Tutorials** repository! This repository contains a collection of tutorials and practical examples focused on programming **ATMEL 8051 Series Microcontrollers** (AT89C51/AT89S51/AT89S52...) using **Assembly language**. The examples are simulated in **Proteus** and verified on real hardware in most cases.

<br/>
This repository helps **beginners** and **enthusiasts** learn the fundamentals of 8051 programming and circuit simulation.

---

## 🚀 **Overview**

![8051_Assembly_Tutorials_Banner](https://github.com/user-attachments/assets/678d0c2d-5013-42d0-b386-b5f26191e00a)

Each example is a folder containing the necessary files for programming the **8051 microcontroller** in Assembly, simulating it using **Proteus**, and downloading the compiled program to hardware via **avrdudes**.

---

## ✨ **Features**

- **Comprehensive 8051 Assembly Examples** for various peripherals
- Ready-to-use **Proteus simulation files**
- Well-commented **Assembly code** for easier learning
- Practical interfacing examples like LEDs, motors, sensors and displays
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

The **USBasp** is a widely-used, open-source programmer that enables seamless interfacing between a computer and various microcontrollers, including the **8051 series**. It was developed by Thomas Fischl and is known for being **affordable, easy-to-use**, and **compatible with multiple microcontroller architectures**.

#### Key Features:
- **Supports ISP (In-System Programming)**: The USBasp programmer allows you to program the microcontroller directly on the development board without needing to remove it.
- **Open-source and customizable**: Both the hardware and firmware are open-source, making it an accessible choice for hobbyists and developers who may want to modify or customize their programming environment.
- **Fast data transfer**: USBasp provides high-speed data transfer to quickly upload your compiled programs to the microcontroller.
- **Cross-platform support**: USBasp is compatible with **Windows, Linux, and macOS**, making it highly flexible for different development environments.
- **Wide microcontroller support**: While it was initially developed for AVR microcontrollers, the USBasp can be used with 8051 microcontrollers through tools like **AVRDude**.

#### Setup and Use:
To use USBasp with 8051 microcontrollers, you'll need:
1. **USBasp Programmer**: The physical device to connect your PC to the microcontroller.
2. **AVRDude**: A command-line tool to upload the compiled Assembly or C code (.hex files) to the microcontroller.
3. **Driver Installation**: Tools like **Zadig** can help install the necessary USB drivers for Windows systems.

### Open-source Resources:
1. **USBasp Official Page**: [Fischl's USBasp](https://www.fischl.de/usbasp/) – The official project page, with firmware, schematics, and documentation.
2. **USBasp on GitHub**: [USBasp Repository](https://github.com/bperrybap/usbasp) – Source code, firmware updates, and project development files.
3. **AVRDude**: [AVRDude on GitHub](https://github.com/avrdudes/avrdude) – The programming tool used to upload hex files to microcontrollers using USBasp.

By using the USBasp programmer, you can easily load your programs onto the 8051 microcontroller, allowing you to focus more on learning and experimenting with embedded systems.

Here are some helpful open-source resources and references for using the **USBasp** programmer with 8051 microcontrollers:


### 2. **USBasp Driver Installation Guide**
   - **Zadig Tool**: [Zadig Driver Installer](https://zadig.akeo.ie/)
   - This tool helps you install the necessary USB drivers for the USBasp programmer on Windows systems.

### 3. **AVRDude**
   - **GitHub**: [avrdude Project](https://github.com/avrdudes/avrdude)
   - USBasp is compatible with **AVRDude**, a powerful command-line utility for programming microcontrollers. You can use it to upload your HEX files to the 8051.

### 4. **USBasp Documentation and Source Code**
   - **GitHub**: [USBasp on GitHub](https://github.com/bperrybap/usbasp)
   - This GitHub repository provides the USBasp firmware and related software for custom programming and modifications.

### 5. **AVR USBasp Programmer Tutorial**
   - **Tutorial**: [AVR USBasp Programmer Tutorial](https://www.electronicwings.com/avr-atmega/usbasp-programmer)
   - A step-by-step tutorial on how to use the USBasp programmer with microcontrollers, including setup and troubleshooting.

These resources will help you set up and use the USBasp programmer efficiently for your 8051 microcontroller projects.





























### 6. **Basic Hardware Setup**
   - **Development Kit**: Understanding how to use an 8051 development board or a **MK-51S** kit.
   - **USBasp Programmer**: For uploading programs to the hardware, basic knowledge of how to connect and use a programmer.

### 7. **General Embedded Systems Concepts**
   - **Digital I/O**: How microcontrollers interface with components like LEDs, motors, and sensors.
   - **Understanding of peripherals**: Familiarity with common microcontroller peripherals such as **UART**, **timers**, **counters**, and **interrupts**.
   - **Interfacing basics**: How to connect and control external devices like LCDs, stepper motors, and sensors.

### 8. **Basic Troubleshooting**
   - Being able to diagnose issues such as incorrect wiring, faulty simulations, or programming errors.
   - Familiarity with **debugging techniques** in both software and hardware environments.

These prerequisites will provide a strong foundation for beginners to dive into the tutorials and examples in your repository.



















### **Requirements:**




#### **Software:**

- **[MIDE-51](https://www.opcube.com/)** – A powerful IDE for writing and compiling Assembly code for the 8051 microcontroller.
- **[avrdudes](http://savannah.nongnu.org/projects/avrdude)** – A tool for uploading compiled programs to the hardware.
- **[Proteus Design Suite](https://www.labcenter.com/downloads/)** – A professional-grade circuit simulation software.

#### **Hardware:**

- **MK-51S Microcontroller Development Kit** – A dedicated development board for the AT89S51/52 microcontroller series.

> **Note:** You can still follow along by using a **USBasp Programmer** and basic **components** for hands-on practice with the examples.

---

### **Installation**

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/8051-microcontroller-tutorials.git
   ```

2. Open Assembly files in **MIDE-51** and compile.
3. Use **avrdudes** to download the program to the hardware.
4. Open Proteus simulation files to visualize the circuit.

---






### Steps to Use AVRDude with USBasp:
Here’s a guide on how to use **AVRDude** with the **USBasp** programmer to upload code to the 8051 microcontroller.

---

#### 1. **Install AVRDude**:
   - **Windows**: Download AVRDude and install it by following the instructions from [AVRDude on GitHub](https://github.com/avrdudes/avrdude) or using a package manager like [WinAVR](https://sourceforge.net/projects/winavr/).
   - **Linux/macOS**: Use a package manager (e.g., `apt-get install avrdude` for Ubuntu/Debian or `brew install avrdude` for macOS).

#### 2. **Install USBasp Driver (for Windows)**:
   - Download and install **Zadig** from [Zadig Installer](https://zadig.akeo.ie/).
   - Open Zadig, select your **USBasp** device from the list, and install the **libusbK** driver.

#### 3. **Prepare Your Code**:
   - Write your **Assembly** code using a tool like **MIDE-51**.
   - Compile the Assembly code into a `.hex` file.

#### 4. **Connect Your USBasp to the 8051 Microcontroller**:
   - Make sure the USBasp is properly connected to your development board or the microcontroller's ISP pins. You'll need to connect the following pins:
     - **MOSI**, **MISO**, **SCK**, **RST**, **VCC**, **GND**.

#### 5. **Use AVRDude Command to Upload Code**:
   AVRDude uses the following syntax to program microcontrollers:

   ```bash
   avrdude -c usbasp -p <device> -U flash:w:<your_hex_file.hex>
   ```

   - `-c usbasp`: Specifies that you're using a USBasp programmer.
   - `-p <device>`: Specify your microcontroller (e.g., `-p m8051` for the AT89S51/AT89C51 microcontroller).
   - `-U flash:w:<your_hex_file.hex>`: This tells AVRDude to write the `.hex` file to the microcontroller's flash memory.

   Example command:

   ```bash
   avrdude -c usbasp -p m89s52 -U flash:w:myprogram.hex
   ```

#### 6. **Check for Errors**:
   After running the command, AVRDude will communicate with the USBasp programmer to upload the program to the 8051 microcontroller. You should see a success message if the upload was completed without any issues.

#### 7. **Verifying the Flash**:
   To verify that the code was successfully written to the 8051’s memory, you can use:

   ```bash
   avrdude -c usbasp -p m89s52 -U flash:v:myprogram.hex
   ```

   This will read the flash memory and compare it with your `.hex` file.

---

### Example Workflow:

1. **Write and compile your Assembly code** in MIDE-51 or any other IDE.
2. **Connect the USBasp programmer** to the 8051 development board.
3. **Use AVRDude** to upload the compiled `.hex` file:

   ```bash
   avrdude -c usbasp -p m89s52 -U flash:w:mycode.hex
   ```

4. **Verify the upload** (optional):

   ```bash
   avrdude -c usbasp -p m89s52 -U flash:v:mycode.hex
   ```

Now, the microcontroller should be programmed and running your uploaded code.

### Additional Resources:
- [AVRDude Documentation](https://www.nongnu.org/avrdude/user-manual/avrdude_16.html) – Official manual with detailed command explanations.
- [AVRDude GitHub](https://github.com/avrdudes/avrdude) – Source and updates for AVRDude.










## ⚗️ **Experiments Section**

### Experiment 1: LED Blink
<p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LED/assets/images/LED_8051_Ckt.png?raw=true" alt="LED Blink" width="700" height="400"> </p> [8051 LED Blink](https://gmostofabd.github.io/8051-LED/) This experiment demonstrates how to blink an LED using the 8051 microcontroller.
---

### Experiment 2: Push Button Interfacing
<p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20SSD%20Up%20Dn%20Counter/UP_DN_COUNTER.png?raw=true" alt="Push Button Interfacing" width="700" height="300"> </p> [8051 Push Button Interfacing](https://gmostofabd.github.io/8051-Push-Button/) Learn how to interface a push button with the 8051 to control outputs.
---

### Experiment 3: Seven Segment Display
<p align="center"> <img src="https://github.com/gmostofabd/melab-store/blob/main/8051%20Examples%20Simulation%20ScrnShots/8051%20Traffic%20Lights2.png?raw=true" alt="Seven Segment Display" width="700" height="450"> </p> [8051 Seven Segment Display Interfacing](https://gmostofabd.github.io/8051-7Segment/) Discover how to interface and display numbers on a seven-segment display.
---

### Experiment 4: LED Dot Matrix
<p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20DOT%20Matrix%20LED/8051%20DOT%20Matrix%20LED.png?raw=true" alt="LED Dot Matrix" width="700" height="400"> </p> [8051 LED Dot Matrix Display Interfacing](https://gmostofabd.github.io/8051-LED-Matrix/) Interface an LED Dot Matrix to display patterns or scrolling text.

---

### Experiment 5: LCD Interfacing
<p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20LCD/AT89C51_8_BIT_LCD_(RW_PIN_TO_GND).png?raw=true" alt="LCD Interfacing" width="700" height="300"> </p> [8051 LCD Interfacing](https://gmostofabd.github.io/8051-LCD/) Interface an LCD with the 8051 to display characters and messages.
---

### Experiment 6: Analog Reading
<p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/AD0804%20LED/Schematic.png?raw=true" alt="Analog Reading" width="700" height="200"> </p> [8051 Potentiometer (Analog) Reading](https://gmostofabd.github.io/8051-Analog/) Learn how to read analog signals from a potentiometer using the 8051.
---

### Experiment 7: Keypad Interfacing
<p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Basic%20Calculator/8051%20Basic%20calculator.png?raw=true" alt="Keypad Interfacing" width="700" height="450"> </p> [8051 Keypad Interfacing](https://gmostofabd.github.io/8051-Keypad/) Interface a 4x4 keypad to take user input as a two digit calculator.
---

### Experiment 8: DC Motor Interfacing
<p align="center"> <img src="https://github.com/gmostofabd/melab-store/blob/main/8051%20Examples%20Simulation%20ScrnShots/8051%20L293D%20DC%20Motor.png?raw=true" alt="DC Motor Interfacing" width="700" height="450"> </p> [8051 DC Motor Interfacing](https://gmostofabd.github.io/8051-DC-Motor/) Control the speed and direction of a DC motor using the 8051 microcontroller.
---

### Experiment 9: Stepper Motor Interfacing
<img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Stepper%20Motors/8051%20Stepper%20Motor.png?raw=true" alt="Stepper Motor Interfacing" width="700" height="400">
[8051 Stepper Motor Interfacing](https://gmostofabd.github.io/8051-Stepper-Motor/)  
Interface a stepper motor to control its motion in discrete steps.

---

### Experiment 10: RTC Interfacing
<p align="center"> <img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/aceb06c4975f29b3eb4b97681455b6ac34920d15/8051%20RTC%20DS1307/8051%20RTC%20DS1307%20LCD.png?raw=true" alt="RTC Interfacing" width="700" height="450"> </p> [8051 RTC Interfacing](https://gmostofabd.github.io/8051-RTC/) Interface a real-time clock (RTC) module to display time and date on an LCD.
---

### Experiment 11: Serial Communication
<img src="https://github.com/gmostofabd/8051-Assembly-Programming-and-Proteus-Simulation/blob/8343a9874e5530a658bd2e023b0df2a4dee0359f/8051%20Serial%20Communication/8051_Serial_UART.png?raw=true" alt="8051 Serial Communication" width="700" height="450">
[8051 Serial Communication](https://gmostofabd.github.io/8051-Tutorial-Home/)  
Learn how to communicate between two serial device using the 8051 microcontrollers.

---



## 🏆 **Acknowledgments**

A huge **thank you** to the following incredible tools and teams for making this repository possible:

- **[MIDE-51](https://www.opcube.com/)** – for providing a feature-rich, user-friendly IDE that simplifies 8051 Assembly programming.
  
- **[avrdudes](http://savannah.nongnu.org/projects/avrdude)** – for the essential programmer tool that effortlessly bridges simulation and hardware deployment.
  
- **[Atmel (Microchip)](https://www.microchip.com/)** – for their legendary **8051 microcontroller series**, which remains an integral part of embedded systems learning.
  
- **[Proteus Design Suite](https://www.labcenter.com/downloads/)** – for their excellent circuit simulation platform that brings designs to life before hitting the hardware stage.

---
