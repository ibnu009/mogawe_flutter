import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mogawe/core/data/response/profile/profile_history_response.dart';
import 'package:mogawe/core/data/response/profile/profile_response.dart';
import 'package:mogawe/core/flutter_flow/flutter_flow_theme.dart';
import 'package:mogawe/modules/profile/id_card_profile.dart';
import 'package:mogawe/modules/profile/tab_widgets/history_tab.dart';
import 'package:mogawe/modules/profile/tab_widgets/merchant_tab.dart';
import 'package:mogawe/modules/profile/tab_widgets/personal_tab.dart';
import 'package:mogawe/modules/profile/tab_widgets/setting_tab.dart';

import '../../../core/flutter_flow/flutter_flow_icon_button.dart';

class ProfilePage extends StatefulWidget {
  final ObjectData? data;
  final List<ProfileHistoryData>? histories;
  final Function(Map<String, String> map)? updateProfile;
  final Function(Map<String, dynamic> map)? updateTarget;
  final Function(File photo)? onFotoChanged;
  final Function(int p, String q)? historyPageListen;
  final Function(String f, String q)? filter;
  final Function(String q)? searchListen;
  final TextEditingController? targetCtrl;
  final TextEditingController? namaCtrl;
  final TextEditingController? emailCtrl;
  final TextEditingController? phoneCtrl;

  ProfilePage(
      {Key? key,
      this.data,
      this.updateProfile,
      this.updateTarget,
      this.onFotoChanged,
      this.histories,
      this.historyPageListen,
      this.filter,
      this.targetCtrl,
      this.namaCtrl,
      this.emailCtrl,
      this.phoneCtrl,
      this.searchListen})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currTab = 0;
  final picker = ImagePicker();
  File? photo;
  String? path;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  void handleTabSelection() {
    if (tabController.indexIsChanging ||
        tabController.index != tabController.previousIndex) {
      currTab = tabController.index;
      setState(() {});
    }
  }

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      photo = File(pickedFile.path);
      path = photo!.path.split('/').last;
      widget.onFotoChanged!(photo!);
    } else {
      Fluttertoast.showToast(msg: "Tidak ada foto yang dipilih");
    }
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      photo = File(pickedFile.path);
      path = photo!.path.split('/').last;
      widget.onFotoChanged!(photo!);
    } else {
      Fluttertoast.showToast(msg: "Tidak ada foto yang dipilih");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.primaryColor,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: Image.asset(
                  'assets/images/bg_profile_header.png',
                ).image,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () => chooseImage(),
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: widget.data == null
                          ? Container()
                          : Image.network(
                              widget.data!.profilePicture!,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data != null ? widget.data!.fullName! : "",
                          style: FlutterFlowTheme.bodyText1.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Text(
                            widget.data != null ? widget.data!.email! : "",
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.secondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: Icon(
                      Icons.qr_code_scanner_outlined,
                      color: FlutterFlowTheme.secondaryColor,
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: IdCardProfile(data: widget.data!),
                                    ),
                                  ),
                                ),
                              ));
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 4,
              initialIndex: currTab,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: FlutterFlowTheme.primaryColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: TabBar(
                      labelStyle: GoogleFonts.getFont(
                        'Roboto',
                      ),
                      // padding: EdgeInsets.fromLTRB(2, 4, 4, 2),
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.symmetric(horizontal: 2),
                      indicatorColor: Colors.transparent,
                      controller: tabController,
                      tabs: [
                        tabItem(0, "Personal", CupertinoIcons.person),
                        tabItem(1, "History", Icons.history),
                        tabItem(2, "Merchant", Icons.shop),
                        tabItem(3, "Settings", CupertinoIcons.settings)
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
                          child: PersonalTab(
                            data: widget.data,
                            updateProfile: widget.updateProfile!,
                            updateTarget: widget.updateTarget!,
                            targetCtrl: widget.targetCtrl,
                            namaCtrl: widget.namaCtrl,
                            emailCtrl: widget.emailCtrl,
                            phoneCtrl: widget.phoneCtrl,
                          ),
                        ),
                        HistoryTab(
                          histories: widget.histories!,
                          historyPageListen: widget.historyPageListen,
                          filter: widget.filter,
                          searchListen: widget.searchListen,
                        ),
                        MerchantTab(),
                        SettingTab()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tabItem(int index, String title, IconData icon) {
    Color colTab;
    Color colText;
    if (index == currTab) {
      colTab = Colors.white;
      colText = FlutterFlowTheme.primaryColor;
    } else {
      colTab = FlutterFlowTheme.primaryColor;
      colText = Colors.white;
    }
    return Container(
      width: 150,
      padding: EdgeInsets.all(8),
      decoration:
          BoxDecoration(color: colTab, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Icon(icon, size: 11, color: colText),
        SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                color: colText, fontWeight: FontWeight.w600, fontSize: 10))
      ]),
    );
  }

  void chooseImage() {
    showDialog(
        context: context,
        builder: (ctx) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => getImageCamera(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(children: [
                            Icon(Icons.photo_camera,
                                size: 24, color: Colors.black),
                            SizedBox(width: 16),
                            Text("Ambil Foto", style: TextStyle(fontSize: 16))
                          ]),
                        ),
                      ),
                      InkWell(
                        onTap: () => getImageGallery(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(children: [
                            Icon(Icons.image, size: 24, color: Colors.black),
                            SizedBox(width: 16),
                            Text("Dari Galeri", style: TextStyle(fontSize: 16))
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
