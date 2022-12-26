import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prastuti_23/animations/home_view_animation.dart';
import 'package:prastuti_23/config/color_palette.dart';
import 'package:prastuti_23/config/image_paths.dart';
import 'package:prastuti_23/config/screen_config.dart';
import 'package:prastuti_23/views/profile/profile_view_content.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../config/Status.dart';
import '../eventsPage/events_view_content.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig.init(context);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme().secondaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme().backgroundColor,
          body: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled)=>[
              SliverAppBar(
                pinned: true,
                backgroundColor: AppTheme().secondaryColor,
                expandedHeight: SizeConfig.heightPercent*35,
                leading: Center(
                  child: InkWell(
                    onTap: _onDrawerTapped,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      color: Colors.white,
                      size: 33,
                      progress: drawerAnimationController.view,
                    ),
                  ),
                ),
                title: Text("Your Profile"),
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground
                  ],
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(ImagePaths.temp_pic),
                          ),
      
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sriraj",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              Text("palakurthi.sriraj.eee20@itbhu.ac.in",
                                style: AppTheme().headText2,
                              ),
                              Text("IIT BHU Varanasi",
                                style: AppTheme().headText2,
                              ),
                              Text("+91 8074821478",
                                style: AppTheme().headText2,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                  child: Container(
                    width: double.maxFinite,
                    color: AppTheme().backgroundColor,
                    child: Center(
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: const [
                          Tab(
                            text: "Events", 
                          ),
                          Tab(
                            text: "Teams",
                          ),
                          Tab(
                            text: "Requests",
                          ),
                        ],
                        //labelPadding: const EdgeInsets.only(right: 23),
                        
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
                        indicator: MaterialIndicator(
                          color: AppTheme().primaryColor,
                          height: 4,
                          topLeftRadius: 8,
                          topRightRadius: 8,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          tabPosition: TabPosition.bottom,
                        ),
                        labelColor: AppTheme().primaryColor,
                        unselectedLabelColor: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ]),
            body: TabBarView(
              controller: _tabController,
              children: [
                regEvent(regEvents),
                teamsList(regTeams),
                buildList(requests)
              ]
            )
          ),
        ),
      ),
    );
  }

  Widget buildList(List<String> list) {

    if(list.isEmpty){
      return const Center(
        child: Text("You have no pending requests"),
      );
    }

    return ListView.separated(
      itemBuilder: (context,index){
        return ListTile(
          title: Text(list[index]),
        );
      },
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) =>Center(
          child: Container(
            height: 0,
            width: SizeConfig.widthPercent*90,
            color: Colors.grey,
          )
      ),
      itemCount: list.length,
    );
  }

  bool isExpanded = false;

  Widget teamsList(List<List<String>> teamsList) {

    if(teamsList.isEmpty){
      return const Center(
        child: Text("You have no registered event"),
      );
    }

    return ListView.separated(
      itemBuilder: (context,index){
        return TeamsList(
            regTeams[index][0],
            regTeams[index][1],
            regTeams[index][2],
            regTeams[index][3],
            regTeams[index][4],
        );
      },
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) =>Center(
          child: Container(
            height: 0,
            width: SizeConfig.widthPercent*90,
            color: Colors.grey,
          )
      ),
      itemCount: regEvents.length,
    );
  }

  Widget TeamsList(
      String eventImage,
      String teamName,
      String teamMember01,
      String teamMember02,
      String teamMember03) {
    return GestureDetector(
      onTap: () {
        /// TODO: Implement onTap
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 30, 0),
        color: Colors.transparent,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 155, 181, 211),
                      boxShadow: [BoxShadow(
                          color: AppTheme().primaryColor.withOpacity(0.5),
                          blurRadius: 7.0,
                          spreadRadius: 3.0,
                          offset: Offset(7, 7)
                      )]
                  ),
                  child: ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    title: AutoSizeText(
                      teamName,
                      style: GoogleFonts.manrope(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        color: isExpanded? Colors.black : Colors.black,
                      ),
                    ),
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: AutoSizeText(
                          teamMember01,
                          style: GoogleFonts.manrope(
                            textStyle: TextStyle(
                              fontSize: 20,
                            )
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: AutoSizeText(
                            teamMember02,
                            style: GoogleFonts.manrope(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                )
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: AutoSizeText(
                            teamMember03,
                            style: GoogleFonts.manrope(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                )
                            )
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                    onExpansionChanged: (bool expanding) => setState(() => this.isExpanded = expanding),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: SizeConfig.height*0.05,
                  width: SizeConfig.height*0.05,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(eventImage),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                          color: AppTheme().secondaryColor,
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                          offset: Offset(5, 5)
                      )]
                  ),
                )
              ]
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }


  Widget regEvent(List<List<String>> regEvents) {

    if(regEvents.isEmpty){
      return const Center(
        child: Text("You have no registered event"),
      );
    }

    return ListView.separated(
      itemBuilder: (context,index){
        return RegEvents(
            regEvents[index][0],
            regEvents[index][1],
            regEvents[index][2],
            regEvents[index][3],
            regEvents[index][4],
            regEvents[index][5]
        );
      },
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) =>Center(
          child: Container(
            height: 0,
            width: SizeConfig.widthPercent*90,
            color: Colors.grey,
          )
      ),
      itemCount: regEvents.length,
    );
  }

  Widget RegEvents(
      String eventImage,
      String eventName,
      String teamName,
      String stage,
      String score,
      String date) {
    return GestureDetector(
      onTap: () {
        /// TODO: Implement onTap
      },
      child: Container(
        height: SizeConfig.height*0.2,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 45,
                child: Container(
                  height: SizeConfig.height*0.165,
                  width: SizeConfig.width*0.78,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 155, 181, 211),
                      boxShadow: [BoxShadow(
                          color: AppTheme().primaryColor.withOpacity(0.5),
                          blurRadius: 7.0,
                          spreadRadius: 3.0,
                          offset: Offset(7, 7)
                      )]
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: SizeConfig.width*0.7,
                        padding: EdgeInsets.only(top: 10, left: 55),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              eventName,
                              style: GoogleFonts.manrope(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                )
                              )
                            ),
                            AutoSizeText(
                                teamName,
                                style: GoogleFonts.manrope(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            ),
                            Row(
                              children: [

                                Container(
                                  height: SizeConfig.height*0.02,
                                  width: SizeConfig.height*0.02,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(Status.statusImage('ended')),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                AutoSizeText(
                                    stage,
                                    style: GoogleFonts.manrope(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                        )
                                    )
                                ),
                              ],
                            ),
                            // AutoSizeText(
                            //     teamMember,
                            //     style: GoogleFonts.manrope(
                            //         textStyle: TextStyle(
                            //             fontSize: 16,
                            //         )
                            //     )
                            // ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: SizeConfig.height*0.0175,
                                        width: SizeConfig.height*0.0259,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(ImagePaths.score),
                                                fit: BoxFit.cover
                                            )
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AutoSizeText(
                                          score,
                                          style: GoogleFonts.catamaran(
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                              )
                                          )
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: SizeConfig.height*0.02,
                                        width: SizeConfig.height*0.02,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(ImagePaths.calender),
                                                fit: BoxFit.cover
                                            )
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AutoSizeText(
                                          date,
                                          style: GoogleFonts.catamaran(
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                              )
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),
            Positioned(
                top: 15,
                child: Container(
                  height: SizeConfig.height*0.12,
                  width: SizeConfig.height*0.12,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(eventImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                      color: AppTheme().secondaryColor,
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      offset: Offset(5, 5)
                    )]
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  void _onDrawerTapped() {
    if (drawerAnimationController.isCompleted) {
      drawerAnimationController.reverse();
    } else {
      drawerAnimationController.forward();
    }
  }
}