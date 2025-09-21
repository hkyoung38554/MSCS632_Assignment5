# MSCS632 Assignment 5: Class-Based Ride Sharing System

This project implements a ride sharing system in C++ and Smalltalk to demonstrate encapsulation, inheritance, and polymorphism.

## Files and Folders
- cpp/main.cpp                C++ implementation
- cpp/rides                   C++ compiled binary (macOS)
- cpp/sample_output_cpp.txt   C++ sample run output
- smalltalk/rides.st          Smalltalk implementation (GNU Smalltalk)
- smalltalk/sample_output_smalltalk.txt  Smalltalk sample run output
- Assignment5_Haeri Kyoung.pages
- Assignment5_Haeri Kyoung.pdf

## How to Run (C++)
1) `cd cpp`
2) `./rides`
3) Output matches sample_output_cpp.txt`

## How to Run (Smalltalk)
1) `cd smalltalk`
2) `gst rides.st`
3) Output matches sample_output_smalltalk.txt

## OOP Principles Shown
- Encapsulation: Driver and Rider keep internal ride lists private and expose methods to modify them
- Inheritance: StandardRide and PremiumRide inherit from Ride
- Polymorphism: Collections store different ride types, calls to fare and rideDetails dispatch to the correct subclass
