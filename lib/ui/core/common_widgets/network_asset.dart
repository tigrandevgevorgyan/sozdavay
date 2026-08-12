import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders a remote image URL and transparently switches to
/// [SvgPicture.network] when the URL looks like an SVG. Use this instead of
/// [Image.network] for admin-managed icons whose format Nikita chooses at
/// upload time (Gohar ships SVG icon packs).
///
/// A tiny wrapper — same public shape as `Image.network` for the fields
/// gamification screens actually pass (url, fit, width, height, and an
/// optional error/loading fallback).
class NetworkAsset extends StatelessWidget {
  const NetworkAsset(
    this.url, {
    super.key,
    this.fit,
    this.width,
    this.height,
    this.color,
    this.placeholder,
    this.errorWidget,
  });

  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;

  /// Applied to the SVG or Image if the format supports tinting.
  final Color? color;

  /// Widget while the asset loads. When null, a neutral empty box is used.
  final Widget? placeholder;

  /// Widget shown when loading/decoding fails. When null the SVG/Image
  /// default is used (broken-image icon for raster, empty for SVG).
  final Widget? errorWidget;

  bool get _isSvg {
    final u = url.toLowerCase();
    final q = u.indexOf('?');
    final path = q >= 0 ? u.substring(0, q) : u;
    return path.endsWith('.svg') || path.endsWith('.svgz');
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return placeholder ?? SizedBox(width: width, height: height);
    }

    if (_isSvg) {
      return SvgPicture.network(
        url,
        fit: fit ?? BoxFit.contain,
        width: width,
        height: height,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        placeholderBuilder: (_) =>
            placeholder ?? SizedBox(width: width, height: height),
      );
    }

    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      color: color,
      errorBuilder: (context, error, stack) =>
          errorWidget ?? const Icon(Icons.broken_image_outlined, size: 24),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder ??
            Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
      },
    );
  }
}
