/*
 * Copyright (c) 2020 Mochamad Nizwar Syafuan
 * Distributed under the GNU GPL v2 with additional terms. For full terms see the file doc/LICENSE.txt
 */
import 'package:flutter/cupertino.dart';

import 'model.dart';

class VpnConfig extends Model {
  VpnConfig({
    required this.name,
    this.username ="vpn",
    this.password = "vpn",
    required this.config,
    this.premium= false,
    this.isSlected= false,
    this.flag = "assets/src/performance.png",
  });

  String name;
  String username;
  String password;
  String config;
  bool premium;
  bool isSlected;
  String flag;
  factory VpnConfig.fromJson(Map<String, dynamic> json) => VpnConfig(
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        premium: json["premium"] == null ? null : json["premium"],
        isSlected: json["isSlected"] == null ? null : json["isSlected"],
        password: json["password"] == null ? null : json["password"],
        config: json["config"] == null ? null : json["config"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "username": username == null ? null : username,
        "password": password == null ? null : password,
        "config": config == null ? null : config,
        "isSlected": isSlected == false ? null : isSlected,
        "premium": premium == false ? null : premium,

  };
}
