import "dart:math" show sqrt;
import 'package:flutter/material.dart';

class Point {
  double x = 0.0;
  double y = 0.0;

  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }

  Point clone() {
    return Point(this.x, this.y);
  }

  void copy(dynamic p) {
    this.x = p.x;
    this.y = p.y;
  }

  Point set(double x, [double y = 0]) {
    this.x = x;
    this.y = y;

    return this;
  }

  double get length {
    return sqrt(this.x * this.x + this.y * this.y);
  }

  double getLength() {
    return this.length;
  }

  Point operator +(Point p) {
    this.x += p.x;
    this.y += p.y;
    return this;
  }

  Point operator -(Point p) {
    this.x -= p.x;
    this.y -= p.y;
    return this;
  }

  Point reset() {
    return this.set(0, 0);
  }

  Map<String, double> toMap() {
    return {"x": this.x, "y": this.y};
  }

  Offset toOffset() {
    return Offset(this.x, this.y);
  }

  String toString() {
    return '[ x:${x.toString()} y:${y.toString()} ]';
  }
}
