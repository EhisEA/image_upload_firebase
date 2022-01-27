import 'package:firebase_image_upload/view_models/home_view_model.dart';
import 'package:firebase_image_upload/models/image_item.dart';
import 'package:firebase_image_upload/widgets/image_item.dart';
import 'package:firebase_image_upload/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeViewModel>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, model, _) {
        return LoaderPage(
          busy: model.isSecondaryBusy,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Gym image app"),
            ),
            floatingActionButton: InkWell(
              onTap: () => showImageSelectionBottomSheet(
                context,
                onCamera: model.fromCamera,
                onUpload: model.fromGalley,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 130,
                decoration: BoxDecoration(
                  color: ThemeData().primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Add Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            body: model.isBusy
                //when fetching items
                ? const Center(child: CircularProgressIndicator())
                : //after fetching items
                Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10,
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: model.items.length,
                      itemBuilder: (context, index) {
                        ImageItem item = model.items[index];
                        return ImageItemWidget(
                          item: item,
                          onDelete: () => model.delete(item),
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }

// bottom sheet for image seletion
  showImageSelectionBottomSheet(context,
      {Function()? onCamera, Function()? onUpload}) {
    // showBottomSheet(context)
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      // clipBehavior: Clip,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text("Select a way to add images"),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () {
                    if (onCamera != null) {
                      Navigator.pop(context);
                      onCamera();
                    }
                  },
                  title: const Text("Take a photo"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    if (onUpload != null) {
                      Navigator.pop(context);
                      onUpload();
                    }
                  },
                  title: const Text("Upload from device"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
