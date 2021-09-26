import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictures_app/common_widgets/custom_notification/overlay.dart';
import 'package:pictures_app/common_widgets/spacing.dart';
import 'package:pictures_app/models/image_model.dart';
import 'package:pictures_app/screens/add_picture.dart';
import 'package:pictures_app/services/firebase_helper.dart';
import 'package:pictures_app/states/auth_state.dart';
import 'package:pictures_app/utils/app_utils.dart';
import 'package:pictures_app/utils/size_helper.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard>
    with AfterLayoutMixin<Dashboard> {
  late OverlaySupportEntry _progress;
  List<ImageModel> _images = [];
  final FirebaseHelper _db = FirebaseHelper();
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _getImages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getImages() async {
    _progress = AppUtils.showProgress();

    try {
      _images = await _db.getAllImages();
      debugPrint(_images.length.toString());
    } catch (e) {
      debugPrint(e.toString());
    }

    _progress.dismiss(animate: false);
    setState(() {});
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _getImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pictures app"),
        actions: [
          TextButton(
              onPressed: () {
                AuthState state =
                    Provider.of<AuthState>(context, listen: false);

                state.signOut();
              },
              child: const Icon(
                Icons.login_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _images.length,
        controller: _controller,
        itemBuilder: (context, i) {
          ImageModel item = _images[i];

          return InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => MatchDetails(
              //               match: item,
              //             )));
            },
            child: Card(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.lightBlueAccent),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: displayWidth(context) * 0.12,
                          ),
                        ),
                        SPW(7),
                        SizedBox(
                          width: displayWidth(context) * 0.75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.userName ?? "",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    timeago.format(item.uploadDate!.toDate()),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              SPH(7),
                              Text(item.name ?? ""),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SPH(10),
                    Text(AppUtils.getHashTags(item.hashTag ?? "")),
                    SPH(10),
                    CachedNetworkImage(
                      imageUrl: item.url!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: displayWidth(context),
                        height: displayHeight(context) * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => SizedBox(
                        width: displayWidth(context),
                        height: displayHeight(context) * 0.4,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return const AddPicture();
            },
          ).then((value) => _getImages());
        },
        label: const Text("Upload Picture"),
        // child: const Icon(Icons.add),
      ),
    );
  }
}
