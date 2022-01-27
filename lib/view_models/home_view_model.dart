import 'dart:developer';
import 'dart:io';

import 'package:firebase_image_upload/models/image_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'baseview_model.dart';

class HomeViewModel extends BaseViewModel {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  final List<ImageItem> items = [];

  fromCamera() {
    _pickImage(ImageSource.camera);
  }

  fromGalley() {
    _pickImage(ImageSource.gallery);
  }

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedImage;
    try {
      // pick image from gallery
      pickedImage = await picker.pickImage(source: source, maxWidth: 1920);
      // stop excution if no image was picked
      if (pickedImage == null) return;
      //upload picked file
      final String fileName = path.basename(pickedImage.path);
      File imageFile = File(pickedImage.path);
      await _uploadImage(fileName, imageFile);
    } catch (err) {
      //Todo display error
      log(err.toString());
    }
  }

  _uploadImage(String fileName, File imageFile) async {
    try {
      //set loading state
      setSecondaryBusy(ViewState.Busy);
      // Uploading the selected image with some custom meta data
      final TaskSnapshot upload = await storage.ref(fileName).putFile(
          imageFile,
          SettableMetadata(customMetadata: {
            'uploaded_by': 'Emmanuel',
            'description': 'Some description...'
          }));
      await _addUploadedItem(upload.ref);
      //Todo display success message
    } on FirebaseException catch (error) {
      //Todo display error
      log(error.message.toString());
    }
    // Refresh the UI
    setSecondaryBusy(ViewState.Idle);
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<void> _addUploadedItem(Reference item) async {
    //get [files]  data
    final String fileUrl = await item.getDownloadURL();
    final FullMetadata fileMeta = await item.getMetadata();
    // create ImageItem model and
    // add item to list of other images
    items.add(
      ImageItem(
        url: fileUrl,
        path: item.fullPath,
        author: fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        description:
            fileMeta.customMetadata?['description'] ?? 'No description',
      ),
    );
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<void> fetchImages() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      setBusy(ViewState.Busy);

      // get list of images form firebase storage
      final ListResult result = await storage.ref().list();
      // get all items
      final List<Reference> allFiles = result.items;
      //populate [files] image data
      await Future.forEach<Reference>(
        allFiles,
        (file) async {
          final String fileUrl = await file.getDownloadURL();
          final FullMetadata fileMeta = await file.getMetadata();
          // create ImageItem model and
          // add item to images list
          items.add(
            ImageItem(
              url: fileUrl,
              path: file.fullPath,
              author: fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
              description:
                  fileMeta.customMetadata?['description'] ?? 'No description',
            ),
          );
        },
      );
    } catch (e) {
      //todo show error
      log(e.toString());
    }
    setBusy(ViewState.Idle);
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> delete(ImageItem image) async {
    setSecondaryBusy(ViewState.Busy);
    try {
      await storage.ref(image.path).delete();
      items.removeWhere((element) => element == image);
      //todo: show indicator for successful delete
    } catch (e) {
      //todo: Show error
      log(e.toString());
    }
    // Rebuild the UI
    setSecondaryBusy(ViewState.Idle);
  }
}
