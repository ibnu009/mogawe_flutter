import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:mogawe/core/flutter_flow/flutter_flow_theme.dart';
import 'package:mogawe/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:mogawe/modules/generator/audio_record.dart';
import 'package:mogawe/modules/generator/webview_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FunctionForm extends StatefulWidget {
  const FunctionForm({Key? key}) : super(key: key);

  @override
  _FunctionFormState createState() => _FunctionFormState();
}

class _FunctionFormState extends State<FunctionForm> {

  late File filer;
  final FileType pickingType = FileType.any;
  List<File> files =[];
  var fileType;
  bool _loadingButton = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final recorder = AudioRecordFunc();
  bool isRecord = false;
  bool isplay = false;
  File? videofile;
  final ImagePicker _picker = ImagePicker();

  Widget munculingambar(BuildContext context){
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return ListView.builder(
        itemCount: files.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index){

          filer = files[index];
          String? mimeStr = lookupMimeType(filer.path);
          fileType = mimeStr!.split('/');
          print('file type ${fileType}');
          if (fileType[0] == 'image'){
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  FullScreenWidget(
                    child: SafeArea(
                      child: Image.file(File(filer.path), height: 150, fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 3.0,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle_rounded,
                        size: 20,
                        color: Colors.red,
                      ),
                      // This is where the _image value sets to null on tap of the red circle icon
                      onTap: () {
                        setState(
                              () {
                            files.removeAt(index);
                          },
                        );
                      },
                    ),
                  ),

                ],
              ),
            );
          }
          else if (fileType[0] == 'video')
          {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset('assets/mp4.png', width: 80, height: 50, fit: BoxFit.fill,),

                ),
                Positioned(
                  right: 3.0,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle_rounded,
                      size: 20,
                      color: Colors.red,
                    ),
                    // This is where the _image value sets to null on tap of the red circle icon
                    onTap: () {
                      setState(
                            () {
                          files.removeAt(index);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
                children: [
                  Image.asset(
                    'assets/file.png', width: 80,  height: 50, fit: BoxFit.fill,),
                  Positioned(
                    right: 3.0,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle_rounded,
                        size: 20,
                        color: Colors.red,
                      ),
                      // This is where the _image value sets to null on tap of the red circle icon
                      onTap: () {
                        setState(
                              () {
                            files.removeAt(index);
                          },
                        );
                      },
                    ),
                  ),
                ]),
          );

        });

  }

  Future<void> openfilemanager() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: pickingType);

    if(result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
    if (!mounted) return;
    var data = files.length;
    print('data: $data');
    setState(() {
      files != null ? files.map((e) => e.toString()).toString() : 'error';

    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  videoPick() async{
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera
    );
    if(video != null){
      setState(() {
        File file = File( video.path );
        videofile = file;
      });
    }
  }

  Widget buttonrecord(){

    isRecord = recorder.isRecord;
    final icon = isRecord ? Icons.stop : Icons.mic;
    final text = isRecord ? 'Stop' : 'Start';

    return Column(
      children: [
        Container(
          width: 136,
          height: 44,
          child: RaisedButton(
            onPressed: () async{
              final isRecord = await recorder.switchrecord();
              setState(() {
                isRecord;
              });
            },
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon),
                Text(
                    text, style: FlutterFlowTheme.title3
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget buttonPlay(){

    isplay= recorder.isPlay;
    final icon = isplay ? Icons.stop : Icons.not_started;
    final text = isplay ? 'Stop' : 'Play Sound';

    return Column(
      children: [
        Container(
          width: 200,
          height: 44,
          child: RaisedButton(
            onPressed: () async{
              final isplay = await recorder.switchplay(whenfinished: ()=> setState(() {

              }));
              setState(() {
                isRecord;
                isplay;
              });
            },
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon),
                Text(
                    text, style: FlutterFlowTheme.title3
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recorder.init();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(height: 40,),
                Text('upload from galery'),
                GestureDetector(
                  onTap: (){openfilemanager();},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xffbfbfbf)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Browse',
                          ),
                          Icon(
                            Icons.open_in_browser,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300, height: 150,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: munculingambar(context)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 28),
                  child: FFButtonWidget(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebviewFlutter(),
                        ),
                      );
                    },
                    text: 'webview',
                    options: FFButtonOptions(
                      width: 130,
                      height: 48,
                      color: FlutterFlowTheme.primaryColor,
                      textStyle: FlutterFlowTheme.title3.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: 12,
                    ),
                    loading: _loadingButton,
                  ),
                ),
                buttonrecord(),
                isRecord ? Center(child: Text('Merekam ... ')) : Container(),
                SizedBox(height: 20,),
                buttonPlay(),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){videoPick();},
                  child: Column(
                    children: [
                      Container(
                       width: 200,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.video_call),
                            Text(
                                'Record Video', style: FlutterFlowTheme.title3
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                videofile != null ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: mounted ? Chewie(controller: ChewieController(
                      videoPlayerController: VideoPlayerController.file(videofile!),
                      aspectRatio: 3/2,
                      autoPlay: true
                    )
                    ) : Container()
                  ),
                ) : Container(),
                SizedBox(height: 20,),
                Text('Qr'),
                Container(
                  height: 300,
                  child: Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
