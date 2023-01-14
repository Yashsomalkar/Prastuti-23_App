import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:prastuti_23/models/eventListModel.dart';
import 'package:prastuti_23/models/teamsModel.dart';
import 'package:prastuti_23/utils/utils.dart';
import 'package:prastuti_23/view_models/auth_view_model.dart';
import 'package:prastuti_23/view_models/registration_handler.dart';

import '../../config/appTheme.dart';
import '../../config/image_paths.dart';
import '../../config/screen_config.dart';
import '../../view_models/profile_view_model.dart';

class ShowModelTeams extends StatefulWidget {
  Events event;
  int eventIndex;
  ShowModelTeams({Key? key,required this.event,required this.eventIndex}) : super(key: key);

  @override
  State<ShowModelTeams> createState() => _ShowModelTeamsState(event);
}

class _ShowModelTeamsState extends State<ShowModelTeams> {

  Events event;
  RxList<handler> isJoining = <handler>[].obs;

  _ShowModelTeamsState(this.event);

  @override
  void initState() {
    super.initState();

    currentUser.teams!.forEach((element){isJoining.add(handler.NOTREGISTERED);});
  }
  @override
  Widget build(BuildContext context) {
    if (currentUser.teams!.isEmpty) {
      return Center(
        child: Text(
          "Please create or join a team before registering",
          style: AppTheme().headText2.copyWith(
            color: selectedAppTheme.isDarkMode
                  ? Colors.white
                  : AppTheme().secondaryColor
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: selectedAppTheme.isDarkMode?
          Colors.black.withOpacity(0.5):Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(27), topRight: Radius.circular(27))
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4), color: Colors.grey),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Select a Team to register",
                  style: AppTheme().headText1.copyWith(
                      fontSize: 16,
                      color: selectedAppTheme.isDarkMode?
                      Colors.white:Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 27),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return EventsTeamsWidget(currentUser.teams![index],index);
              },
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => Center(
                  child: Container(
                    height: 0,
                    width: SizeConfig.widthPercent * 90,
                    color: Colors.grey,
                  )),
              itemCount: currentUser.teams!.length,
            ),
          )
        ],
      ),
    );
  }

  Widget EventsTeamsWidget(Teams userTeam,int index) {
    return Container(
        margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme().secondaryColorLight,
            boxShadow: [
              BoxShadow(
                  color: AppTheme().primaryColor.withOpacity(0.3),
                  blurRadius: 4.0,
                  spreadRadius: 3.0,
                  offset: Offset(4, 4))
            ]),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AutoSizeText(
            userTeam.teamName!,
            style: AppTheme().headText1.copyWith(
                color: selectedAppTheme.isDarkMode?
                Colors.white:Colors.black,
                fontWeight: FontWeight.w500, fontSize: 22),
          ),
          AcceptButton(userTeam,index)
        ]));
  }

  Widget AcceptButton(Teams userTeam,int index) {
    return ElevatedButton(
      onPressed: () async {

        isJoining[index] = handler.LOADING;
        bool isJoined = await RegistrationHandler().registereInTeamEvent(
          userId: currentUser.sId!,
          eventId: event.sId!,
          teamId: userTeam.sId!,
          context: context,
          eventIndex: widget.eventIndex
          );
        isJoining[index] = handler.NOTREGISTERED;
        if(isJoined){
          Navigator.of(context).pop();
              Utils.flushBarMessage(
              context: context, bgColor: Colors.green, message: "Registered Successfully!");
        }
      },
      child: Obx(() => FittedBox(
        child: (isJoining[index] == handler.LOADING)?
        const SpinKitWave(
          color: Colors.white,
          size: 15,
          itemCount: 5,
        )
        :AutoSizeText(
          'Join',
          style: AppTheme().headText2.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
),
        style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: AppTheme().secondaryColor,
        shadowColor: AppTheme().primaryColor,
        elevation: 5,
        fixedSize: Size(80, 30),
      ),
    );
  }

  Widget LoadingTick(bool isDone) {
    final color = isDone ? Colors.green[800] : AppTheme().primaryColor;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: isDone
            ? Icon(
          Icons.done,
          size: 30,
          color: Colors.white,
        )
            : CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
