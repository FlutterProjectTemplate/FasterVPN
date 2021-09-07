import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/services.dart';
import '../core/models/ServerList.dart';
import '../core/models/dnsConfig.dart';
import '../core/models/vpnConfig.dart';
import '../core/utils/nizvpn_engine.dart';
import '../screens/server_list_page.dart';
import 'package:flutter/material.dart';

import 'shared_widgets/server_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  String _vpnState = NizVpn.vpnDisconnected;
  late List<VpnConfig> listVpn;
  VpnConfig selectedVpn = new VpnConfig(name: "VietNam", config: "none");
  List<VpnConfig> serverList =  <VpnConfig>[];
  late ServerList serverListInit;
  late ServerListPage serverListPage;
  bool isconnect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    ///Add listener to update vpnstate
    NizVpn.vpnStageSnapshot().listen((event) {
      setState(() {
        _vpnState = event;
      });
    });

    ///Call initVpn
    serverListInit = new ServerList(serverList: serverList,selectVPN: selectedVpn);
    //selectedVpn = serverListInit.initSelectVPN();
    serverListInit.InitialServerList();
    serverListPage = ServerListPage(serverList: serverList, selectedVPN: selectedVpn);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Faster VPN',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          leading: Image.asset(
            'assets/src/logo.png',
            width: 35,
            height: 35,
          ),
        ),
        body: Stack(
          children: [
            Positioned(
                top: 50,
                child: Opacity(
                    opacity: .1,
                    child: Image.asset(
                      'assets/src/background.png',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height / 1.5,
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Center(
                      child: Text(
                    '${connectionState(state: _vpnState)}',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                  SizedBox(height: 8),
                  Center(
                      child: Text(
                    '192.168.1.20',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Color.fromRGBO(37, 112, 252, 1),
                        fontWeight: FontWeight.w600),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: AvatarGlow(
                      glowColor: _vpnState == NizVpn.vpnDisconnected ? Colors.transparent : Color.fromRGBO(37, 112, 252, 1),
                      endRadius: 100.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: _vpnState == NizVpn.vpnDisconnected ? false :true,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      shape: BoxShape.circle,
                      child: Material(
                        elevation: 2,
                        shape: CircleBorder(),
                        color: _vpnState == NizVpn.vpnDisconnected ? Colors.grey : Color.fromRGBO(37, 112, 252, 1),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: GestureDetector(
                            onTap: _connectClick,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.power_settings_new,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${connectionButtonState(state: _vpnState)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                          )

                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    '00.00.01',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(37, 112, 252, 1)),
                  )),
                  SizedBox(
                    height: 25,
                  ),
                  ServerItemWidget(
                    flagAsset: selectedVpn.flag,
                    label: selectedVpn.name,
                    icon: Icons.arrow_forward_ios,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return serverListPage;
                      }));
                    },
                  ),
                  Spacer(),
                  RaisedButton.icon(
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: MediaQuery.of(context).size.width / 4.5),
                    color: Color.fromRGBO(37, 112, 252, 1),
                    onPressed: () {},
                    icon: Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Get Premium',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(height: 35),
                ],
              ),
            ),
          ],
        ));
  }

  String connectionState({required String state}) {
    switch (state) {
      case NizVpn.vpnDisconnected:
        return 'You are disconnected';
      case NizVpn.vpnPrepare:
        return 'Prepare connect';
      case NizVpn.vpnWaitConnection:
        return 'Wait connecting';
      case NizVpn.vpnConnecting:
        return 'You are connecting';
      case NizVpn.vpnAuthenticating:
        return 'Authenticating';
      case NizVpn.vpnDenied:
        return 'Connection denied';
      case NizVpn.vpnConnected:
        return 'You are connected';
      case NizVpn.vpnNoConnection:
        return 'No connection';
      case NizVpn.vpnReconnect:
        return 'Reconnect vpn';
      default:
        return 'Getting connection status';
    }
  }

   String connectionButtonState({required String state}) {
    switch (state) {
      case NizVpn.vpnDisconnected:
        return 'Disconnected';
      case NizVpn.vpnPrepare:
        return 'Preparing';
      case NizVpn.vpnWaitConnection:
        return 'Wait connecting';
      case NizVpn.vpnConnecting:
        return 'Connecting';
      case NizVpn.vpnAuthenticating:
        return 'Authenticating';
      case NizVpn.vpnDenied:
        return 'Connection denied';
      case NizVpn.vpnConnected:
        return 'Connected';
      case NizVpn.vpnNoConnection:
        return 'No connection';
      case NizVpn.vpnReconnect:
        return 'Reconnect';
      default:
        return 'Disconnected';
    }
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    selectedVpn = serverListPage.GetSelectServer();
    if (selectedVpn == null)
      return;

    if (_vpnState == NizVpn.vpnDisconnected) {
      ///Start if stage is disconnected
      NizVpn.startVpn(
        selectedVpn,
        dns: DnsConfig("23.253.163.53", "198.101.242.72"), bypassPackages: [],
      );
    } else {
      ///Stop if stage is "not" disconnected
      NizVpn.stopVpn();
    }
  }
  // Future<void> initPlatformState() async {
  //   await FlutterOpenvpn.lunchVpn(
  //     "assets/vpn/korean.ovpn",
  //         (isProfileLoaded) {
  //       print('isProfileLoaded : $isProfileLoaded');
  //     },
  //         (vpnActivated) {
  //       print('vpnActivated : $vpnActivated');
  //     },
  //     user: 'vpn',
  //     pass: 'vpn',
  //     onConnectionStatusChanged:
  //         (duration, lastPacketRecieve, byteIn, byteOut) => print("by in: "+ byteIn),
  //     expireAt: DateTime.now().add(
  //       Duration(
  //         seconds: 180,
  //       ),
  //     ),
  //   );
  // }
}
