// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;

  const ImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(AppAssets.logo)),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      useOldImageOnUrlChange: true,
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.fitHeight),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) {
        // return CircularProgressIndicator(value: downloadProgress.progress);
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(AppAssets.logo)),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(AppAssets.logo)),
          ),
        );
      },
      errorListener: (_) {},
    );
  }
}
