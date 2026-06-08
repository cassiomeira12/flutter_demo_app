// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final void Function(String url, Object? error)? onError;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.onError,
  });

  Widget get fallback {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(AppAssets.logo)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    developer.log('ImageWidget $imageUrl', name: 'Rebuild');
    if (imageUrl.isEmpty) return fallback;
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
      progressIndicatorBuilder: (_, _, _) => fallback,
      errorWidget: (_, _, _) => fallback,
      errorListener: (error) {
        Log.warning(
          '$runtimeType - $imageUrl \n$error',
          throwsCrashlytics: false,
        );
        onError?.call(imageUrl, error);
      },
    );
  }
}
