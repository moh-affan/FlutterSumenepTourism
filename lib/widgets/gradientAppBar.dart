import 'package:flutter/material.dart';

const double kToolbarHeight = 56.0;
const double _kLeadingWidth = kToolbarHeight;

class GradientAppBar extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final Widget trailing;
  final Gradient gradient;
  final double elevation;
  final double opacity;

  GradientAppBar(
      {Key key,
      this.leading,
      this.title,
      this.trailing,
      this.gradient,
      this.opacity = 0.0,
      this.elevation = 0.0})
      : assert(opacity >= 0 && opacity <= 1),
        super(key: key);

  @override
  _GradientAppBarState createState() => _GradientAppBarState();
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    var leading = this.widget.leading;
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: _kLeadingWidth),
        child: leading,
      );
    }
    var _gradient = widget.gradient == null
        ? LinearGradient(
            colors: [Color(0xff11998e), Color(0xff38ef7d)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
        : widget.gradient;

    final double statusbarHeight = MediaQuery.of(context).padding.top;
    final preferredSize = Size.fromHeight(kToolbarHeight + statusbarHeight);
    return Material(
      color: Colors.transparent,
      elevation: widget.elevation,
      child: PreferredSize(
        preferredSize: preferredSize,
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: widget.opacity,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: kToolbarHeight + statusbarHeight,
                decoration: BoxDecoration(
                  gradient: _gradient,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: statusbarHeight),
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  leading,
                  widget.title,
                  widget.trailing == null
                      ? SizedBox(
                          width: 0,
                        )
                      : widget.trailing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
