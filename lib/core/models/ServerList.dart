import 'package:flutter/cupertino.dart';

import 'vpnConfig.dart';

import 'package:flutter/services.dart';
class ServerList {

  List<VpnConfig> serverList = <VpnConfig>[];
  VpnConfig selectVPN;
  ServerList({ required this.serverList, required this.selectVPN});

  List<VpnConfig> GetServerList(){
    return this.serverList;
  }
  void AddServerItem(VpnConfig serverInfo){
    serverList.add(serverInfo);
  }
  // VpnConfig initSelectVPN() async{
  //   VpnConfig selectedVpn = new VpnConfig(name: "VietNam", flag:'assets/src/vietnam.png' , config: await rootBundle.loadString("assets/vpn/vietnam.ovpn"));
  //   return selectedVpn;
  // }
  void InitialServerList() async{
    serverList.add(VpnConfig(
        flag: 'assets/src/japan.png',
        config: await rootBundle.loadString("assets/vpn/japan.ovpn"),
        name: "Japan"));
    serverList.add(VpnConfig(
        flag: 'assets/src/usa.jpg',
        config: await rootBundle.loadString("assets/vpn/us.ovpn"),
        name: "United State"));
    serverList.add(VpnConfig(
        flag: 'assets/src/vietnam.png',
        config: await rootBundle.loadString("assets/vpn/vietnam.ovpn"),
        name: "VietNam"));
    serverList.add(VpnConfig(
        flag: 'assets/src/korea.png',
        config: await rootBundle.loadString("assets/vpn/korean.ovpn"),
        name: "Korean"));
    selectVPN = serverList.first;
  }
}
