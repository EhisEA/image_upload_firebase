import 'package:flutter/material.dart';

class LoaderPage extends StatelessWidget {
  final Widget child;
  final bool busy;
  final Widget loader;
  const LoaderPage({
    Key? key,
    required this.child,
    required this.busy,
  })  : loader = const Center(child: CircularProgressIndicator()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: child,
          ),
          busy
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.75),
                  child: loader)
              : const SizedBox()
        ],
      ),
    );
  }
}
