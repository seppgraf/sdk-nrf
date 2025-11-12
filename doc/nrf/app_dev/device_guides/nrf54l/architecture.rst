.. _nrf54lm20_architecture:

nRF54LM20 Software Architecture
###############################

.. contents::
   :local:
   :depth: 2

This page provides an overview of the software architecture available for the nRF54LM20 System-on-Chip (SoC) in the |NCS|.
The nRF54LM20 is part of the nRF54L Series and features a dual-core architecture with an Arm Cortex-M33 application core and a RISC-V VPR (Fast Lightweight Peripheral Processor - FLPR) core.

Architecture overview
*********************

The software architecture for the nRF54LM20 is organized into distinct layers, each providing specific functionality and services.
The following diagram illustrates the layered architecture:

.. figure:: /images/nrf54lm20_software_architecture.svg
   :alt: nRF54LM20 Software Architecture Diagram

   nRF54LM20 Software Architecture

The architecture consists of the following layers:

* **Applications Layer** - End-user applications and protocol-specific implementations
* **Libraries & Services Layer** - Reusable software components and frameworks
* **Middleware & RTOS Layer** - Real-time operating system and core services
* **Hardware Abstraction Layer** - Device drivers and hardware interfaces
* **Hardware Layer** - Physical nRF54LM20 SoC components

Applications layer
******************

The applications layer contains protocol-specific applications and samples that demonstrate the capabilities of the nRF54LM20.

Bluetooth
=========

The nRF54LM20 supports Bluetooth Low Energy applications with **experimental** maturity level.
Key features include:

* Bluetooth Low Energy (BLE) applications
* 2 Mbps PHY support (experimental)
* Low Latency Packet Mode (experimental)
* Fast Pair integration
* BLE-based services and profiles

For more information, see the :ref:`ug_ble` documentation.

Thread
======

Thread protocol support on the nRF54LM20 is available at **experimental** maturity level, providing:

* Full Thread Device (FTD) support
* IPv6-based mesh networking
* Thread border router capabilities
* Seamless integration with Thread networks

For more information, see the :ref:`ug_thread` documentation.

Matter
======

Matter protocol support on the nRF54LM20 enables smart home applications with **experimental** maturity level:

* Matter device implementation
* OTA DFU over Bluetooth LE
* Integration with major smart home ecosystems
* Built on Thread networking

For more information, see the :ref:`ug_matter` documentation.

NFC
===

The nRF54LM20 provides NFC-A Tag support with **experimental** maturity level:

* NFC Type 2 Tag (read-only)
* NDEF message formatting
* Tag emulation
* Pairing and data exchange applications

For more information, see the :ref:`ug_nfc` documentation.

Libraries and services layer
****************************

This layer provides reusable software components organized into three main categories:

Protocol libraries
==================

Protocol-specific libraries that implement communication stacks:

* **Bluetooth Host Stack** - Full Bluetooth LE host implementation
* **OpenThread Stack** - Thread networking protocol stack
* **Matter Framework** - Matter application layer and device types
* **NFC Libraries** - T2T and NDEF message handling
* **Low Latency Packet Mode** - Optimized Bluetooth packet handling

Application libraries
=====================

General-purpose libraries for application development:

* **DFU Target** - Device Firmware Update target implementation
* **Flash Patch** - Runtime code patching capabilities
* **Event Manager** - Event-driven architecture support
* **Common Application Framework (CAF)** - Reusable application components
* **nRF RPC** - Remote Procedure Call for inter-processor communication

Utilities and services
======================

Supporting utilities and system services:

* **Settings Storage** - Persistent configuration storage
* **Secure Storage** - Protected data storage using :ref:`ug_secure_storage`
* **Shell** - Command-line interface for debugging
* **Logging** - System-wide logging framework
* **Tracing** - Performance analysis and debugging

Middleware and RTOS layer
**************************

This layer provides the real-time operating system and core system services.

Zephyr RTOS
===========

The nRF54LM20 runs on the :ref:`Zephyr RTOS <zephyr:index>`, which provides:

* **Kernel** - Multithreading, scheduling, and synchronization primitives
* **Device Drivers** - GPIO, UART, SPI, I2C, and other peripheral drivers
* **Bluetooth Controller** - Link Layer implementation for Bluetooth LE
* **Network Stack** - IPv6 networking and socket APIs
* **File Systems** - File system support for storage devices
* **Power Management** - System and device power management

Security and boot
=================

Security features and secure boot capabilities:

* **TF-M (Trusted Firmware-M)** - :ref:`Trusted execution environment <ug_tfm>` for secure processing (experimental support on nRF54LM20)
* **PSA Crypto API** - Platform Security Architecture cryptographic APIs
* **nRF Security** - mbedTLS integration with hardware acceleration
* **MCUboot** - :ref:`Secure bootloader <mcuboot:mcuboot_ncs>` with image verification
* **Firmware Info** - Firmware metadata and versioning
* **Immutable/Upgradable Bootloader** - Multi-stage boot architecture

Hardware abstraction layer
***************************

The HAL provides low-level hardware access and peripheral management.

HAL and drivers
===============

Hardware abstraction and peripheral drivers:

* **CRACEN Crypto Driver** - Hardware-accelerated cryptography using the :ref:`Crypto Accelerator Engine <ug_nrf54l_cryptography>`
* **GRTC** - Global Real-Time Counter for timing operations
* **GPIOTE** - GPIO Task and Event support
* **UARTE, TWIM** - Serial communication interfaces
* **nrfx Peripheral Drivers** - Low-level peripheral access

Multi-core support
==================

The nRF54LM20 features dual-core capabilities:

* **VPR/FLPR Core Support** - :ref:`RISC-V VPR core <vpr_flpr_nrf54l>` for peripheral processing
* **IPC** - Inter-Processor Communication between cores
* **FLPR SRAM/RRAM Execution** - Execute FLPR code from SRAM or RRAM
* **Memory Management** - Shared memory and resource allocation
* **Core Bootstrapping** - Automatic FLPR core initialization

For information on building applications for the FLPR core, see :ref:`building_nrf54l_app_flpr_core`.

Memory and storage
==================

Storage and key management:

* **RRAM** - :ref:`Resistive RAM <zms>` for non-volatile storage
* **KMU** - :ref:`Key Management Unit <ug_nrf54l_developing_basics_kmu>` for secure key storage (256 slots of 128 bits each)
* **ZMS** - :ref:`Zephyr Memory Storage <zms>` for persistent data
* **Flash Management** - Flash memory operations and wear leveling
* **Partition Manager** - Memory region management and allocation

Hardware layer
**************

The hardware layer represents the physical nRF54LM20A SoC components.

CPU cores
=========

The nRF54LM20A features two processing cores:

* **Arm Cortex-M33** - Application core running at up to 128 MHz with TrustZone support
* **RISC-V VPR (FLPR)** - Fast Lightweight Peripheral Processor for offloading tasks

Cryptography
============

Hardware cryptographic acceleration:

* **CRACEN** - Crypto Accelerator Engine for AES, ECC, and other algorithms
* **IKG** - Isolated Key Generator for deriving hardware-bound keys
* **KMU** - Hardware Key Management Unit with 256 key slots

Wireless capabilities
=====================

Radio and wireless connectivity:

* **2.4 GHz Radio** - Support for Bluetooth LE, Thread, and Matter protocols
* **NFC-A Tag** - Near Field Communication Tag emulation

Memory
======

On-chip memory resources:

* **RRAM** - Resistive RAM for code and data storage
* **SRAM** - Static RAM divided into RAM_00 and RAM_01 regions for optimal performance

  .. note::
     When using FLPR, allocate time-critical data to RAM_00 to avoid latency issues.
     See :ref:`vpr_flpr_nrf54l` for memory allocation guidelines.

Building applications for nRF54LM20
************************************

To build applications for the nRF54LM20, use the following board targets:

* ``nrf54lm20dk/nrf54lm20a/cpuapp`` - Application core
* ``nrf54lm20dk/nrf54lm20a/cpuapp/ns`` - Application core with TF-M (non-secure)
* ``nrf54lm20dk/nrf54lm20a/cpuflpr`` - FLPR core (SRAM execution)
* ``nrf54lm20dk/nrf54lm20a/cpuflpr/xip`` - FLPR core (RRAM execution)

For detailed build instructions, see :ref:`building_nrf54l`.

Software maturity
*****************

The nRF54LM20 support in the |NCS| is under active development.
Most features are currently at **experimental** maturity level, which means:

* Suitable for prototyping and evaluation
* Not recommended for production deployment
* APIs and features may change in future releases
* Limited verification compared to supported features

For the latest maturity levels of specific features, refer to the :ref:`software_maturity` documentation.

Related documentation
*********************

For more information about developing with the nRF54LM20, see the following pages:

* :ref:`ug_nrf54l` - General nRF54L Series development guide
* :ref:`building_nrf54l` - Building and programming instructions
* :ref:`ug_nrf54l_cryptography` - Cryptography and security features
* :ref:`vpr_flpr_nrf54l` - Working with the FLPR core
* :ref:`kmu_basics` - Key Management Unit usage
* :ref:`ug_nrf54l_developing_fota_update` - Firmware over-the-air updates
