import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pictures_app/common_widgets/custom_button.dart';
import 'package:pictures_app/common_widgets/custom_notification/overlay.dart';
import 'package:pictures_app/common_widgets/custom_text_field.dart';
import 'package:pictures_app/common_widgets/spacing.dart';
import 'package:pictures_app/constants/app_colors.dart';
import 'package:pictures_app/models/image_model.dart';
import 'package:pictures_app/services/firebase_helper.dart';
import 'package:pictures_app/states/auth_state.dart';
import 'package:pictures_app/utils/app_utils.dart';
import 'package:pictures_app/utils/size_helper.dart';
import 'package:provider/provider.dart';

class AddPicture extends StatefulWidget {
  const AddPicture({Key? key}) : super(key: key);

  @override
  _AddPictureState createState() {
    return _AddPictureState();
  }
}

class _AddPictureState extends State<AddPicture> {
  final _text = TextEditingController();
  final _hashTags = TextEditingController();
  Asset? imageFile;
  final FirebaseHelper _db = FirebaseHelper();
  late OverlaySupportEntry _progress;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _text.dispose();
    _hashTags.dispose();
    super.dispose();
  }

  Future getImage() async {
    List<Asset> resultList = [];
    List<Asset> images = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "CureAssist",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;

    setState(() {
      imageFile = resultList[0];
    });
  }

  void _savePic() async {
    _progress = AppUtils.showProgress();
    AuthState state = Provider.of<AuthState>(context, listen: false);

    String imhUrl = await FirebaseHelper.uploadImage(
        imageFile!, "images", "${DateTime.now().toString()}.jpg");

    ImageModel model = ImageModel();

    model.name = _text.text;
    model.hashTag = _hashTags.text;
    model.url = imhUrl;
    model.uploadDate = Timestamp.now();
    model.userId = state.getAppUser()?.id;
    model.userName = state.getAppUser()?.fullName;
    await _db.savePicture(model);
    _progress.dismiss(animate: false);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add picture"),
      ),
      body: ListView(
        children: [
          if (imageFile != null)
            AssetThumb(
              asset: imageFile!,
              width: int.parse(displayWidth(context).toStringAsFixed(0)),
              height:
                  int.parse((displayHeight(context) * 0.35).toStringAsFixed(0)),
            ),
          if (imageFile == null)
            InkWell(
              onTap: getImage,
              child: Container(
                alignment: Alignment.center,
                width: displayWidth(context),
                height: displayHeight(context) * 0.35,
                color: Colors.grey[300],
                child: const Text("Select picture"),
              ),
            ),
          SPH(15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomTextField(
                  controller: _text,
                  hintText: "text",
                ),
                SPH(15),
                CustomTextField(
                  controller: _hashTags,
                  hintText: "Hashtags",
                ),
                SPH(15),
                CustomButton(
                  color: AppColors.cbut,
                  onTap: _savePic,
                  buttonText: 'Save',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
