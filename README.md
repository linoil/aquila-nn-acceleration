# Neural Network Acceleration on Aquila SoC
A project for NYCU Microprocessor Systems: Principles and Implementation 2023.

The development is built on top of [Aquila SoC](https://github.com/eisl-nctu/aquila).
This project aims to accelerate the performance of a Multilayer Perceptron (MLP) for hand-written character recognition.

The methods of acceleration:
- Integrate Xilinx Floating-Point IP into the Aquila SoC to boosts the computational speed.
- Reorganizing the data transfer sequence of layer weights to improve the efficiency of data movement.