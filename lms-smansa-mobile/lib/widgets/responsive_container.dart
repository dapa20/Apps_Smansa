import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

/// Wrapper yang membatasi lebar konten & centering-nya.
/// Berguna untuk tampilan lebar (tablet/desktop) agar tidak stretched.
///
/// Contoh pakai:
/// ```dart
/// body: ResponsiveContainer(
///   child: MyContent(),
/// )
/// ```
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = AppConstants.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding == null
            ? child
            : Padding(padding: padding!, child: child),
      ),
    );
  }
}

/// Widget helper untuk membatasi konten SingleChildScrollView / Column
/// dengan lebar maksimal tertentu dan padding responsif.
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? verticalPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = AppConstants.responsivePadding(width);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: verticalPadding?.vertical ?? 0,
      ),
      child: child,
    );
  }
}

/// Spacer vertikal yang scale dengan lebar layar.
class ResponsiveGap extends StatelessWidget {
  final double small;
  final double medium;

  const ResponsiveGap({super.key, this.small = 16, this.medium = 24});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gap = width < AppConstants.mobileMedium ? small : medium;
    return SizedBox(height: gap);
  }
}
