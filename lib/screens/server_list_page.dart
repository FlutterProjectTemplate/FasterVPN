//import 'package:circular_check_box/circular_check_box.dart';
import '../core/models/vpnConfig.dart';
import 'shared_widgets/server_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class ServerListPage extends StatefulWidget {
  late List<VpnConfig> serverList;
  VpnConfig selectedVPN ;
  ServerListPage({required this.serverList, required this.selectedVPN});
  late _ServerListPageState _serverListPageState;
  @override
  _ServerListPageState createState() {
    _serverListPageState = new _ServerListPageState(serverList: serverList,selectedVPN: selectedVPN);
    return _serverListPageState;
  }
  VpnConfig GetSelectServer(){
    selectedVPN = _serverListPageState.selectedVPN;
    return _serverListPageState.selectedVPN;
  }
  void SetSelectServer(VpnConfig selectedVPN){
    this.selectedVPN = selectedVPN;
  }

}

class _ServerListPageState extends State<ServerListPage> {
  late List<VpnConfig> serverList;
  VpnConfig selectedVPN;
  _ServerListPageState({required this.serverList, required this.selectedVPN});
  List<VpnConfig> premiumServers = <VpnConfig>[];
  List<VpnConfig> freeServers = <VpnConfig>[];
  @override
  Widget build(BuildContext context) {
    premiumServers = serverList;
    freeServers = serverList;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Servers',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        children: [
          RichText(
              text: TextSpan(
                  text: 'Premuim ',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w700),
                  children: [
                TextSpan(
                    text: 'Servers',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.normal))
              ])),
          SizedBox(
            height: 20,
          ),
          Container(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: premiumServers.length,
              itemBuilder: (_, index) {
                return ServerItemWidget(
                  isFaded: true,
                    label: premiumServers[index].name,
                    icon: Icons.lock,
                    flagAsset: premiumServers[index].flag,
                    onTap: () {});
              },
              separatorBuilder: (_, index) => SizedBox(height: 10),
            ),
          ),
          SizedBox(height: 30),
          RichText(
              text: TextSpan(
                  text: 'Free ',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w700),
                  children: [
                TextSpan(
                    text: 'Servers',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.normal))
              ])),
          SizedBox(
            height: 20,
          ),
          Container(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: freeServers.length,
              itemBuilder: (_, index) {
                return Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              backgroundImage: ExactAssetImage(
                                freeServers[index].flag,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              freeServers[index].name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        RoundCheckBox(
                          checkedColor: Color.fromRGBO(37, 112, 252, 1),
                            isChecked: freeServers[index].isSlected,
                            onTap: (select) {
                              setState(() {
                                freeServers[index].isSlected = !freeServers[index].isSlected;
                                selectedVPN =freeServers[index];
                                freeServers.forEach((element) {
                                  if(!element.name.toString().contains(freeServers[index].name.toString()))
                                    {
                                      element.isSlected = false;
                                    }
                                  // else{
                                  //   selectedVPN = element;
                                  // }
                                });
                              });
                            },
                          animationDuration: Duration(seconds: 1,),

                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => SizedBox(height: 10),
            ),
          )
        ],
      ),
    );
  }
}
