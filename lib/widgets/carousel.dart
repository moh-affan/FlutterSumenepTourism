import 'dart:async';

import 'package:flutter/material.dart';

///This class created based on flutter_carousel_slidr created by serenader2014
///https://github.com/serenader2014/flutter_carousel_slider

class Carousel extends StatefulWidget {
  Carousel(
      {@required this.items,
      this.height,
      this.aspectRatio: 16 / 9,
      this.viewportFraction: 0.8,
      this.initialPage: 0,
      int realPage: 10000,
      this.enableInfiniteScroll: true,
      this.reverse: false,
      this.withIndicator: false,
      this.autoPlay: false,
      this.autoPlayInterval: const Duration(seconds: 4),
      this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
      this.autoPlayCurve: Curves.fastOutSlowIn,
      this.pauseAutoPlayOnTouch,
      this.enlargeCenterPage = false,
      this.onPageChanged,
      this.scrollDirection: Axis.horizontal})
      : this.realPage =
            enableInfiniteScroll ? realPage + initialPage : initialPage,
        this.pageController = PageController(
          viewportFraction: viewportFraction,
          initialPage:
              enableInfiniteScroll ? realPage + initialPage : initialPage,
        );

  final List<Widget> items;
  final double height;
  final double aspectRatio;
  final double viewportFraction;
  final num initialPage;
  final num realPage;
  final bool enableInfiniteScroll;
  final bool reverse;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;
  final Curve autoPlayCurve;
  final Duration pauseAutoPlayOnTouch;
  final bool enlargeCenterPage;
  final Axis scrollDirection;
  final Function(int index) onPageChanged;
  final PageController pageController;
  final bool withIndicator;

  Future<void> nextPage({Duration duration, Curve curve}) {
    return pageController.nextPage(duration: duration, curve: curve);
  }

  Future<void> previousPage({Duration duration, Curve curve}) {
    return pageController.previousPage(duration: duration, curve: curve);
  }

  void jumpToPage(int page) {
    final index =
        _getRealIndex(pageController.page.toInt(), realPage, items.length);
    return pageController
        .jumpToPage(pageController.page.toInt() + page - index);
  }

  Future<void> animateToPage(int page, {Duration duration, Curve curve}) {
    final index =
        _getRealIndex(pageController.page.toInt(), realPage, items.length);
    return pageController.animateToPage(
        pageController.page.toInt() + page - index,
        duration: duration,
        curve: curve);
  }

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with TickerProviderStateMixin {
  Timer timer;
  int currentPageValue = 0;

  @override
  void initState() {
    super.initState();
    timer = _getTimer();
  }

  Timer _getTimer() => Timer.periodic(widget.autoPlayInterval, (_) {
        if (widget.autoPlay)
          widget.pageController.nextPage(
              duration: widget.autoPlayAnimationDuration,
              curve: widget.autoPlayCurve);
      });

  void _pauseOnTouch() {
    timer.cancel();
    timer = Timer(widget.pauseAutoPlayOnTouch, () {
      timer = _getTimer();
    });
  }

  Widget _getWrapper(Widget child) {
    if (widget.height != null) {
      final Widget wrapper = Container(height: widget.height, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    } else {
      final Widget wrapper =
          AspectRatio(aspectRatio: widget.aspectRatio, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    }
  }

  Widget addGestureDetection(Widget child) =>
      GestureDetector(onPanDown: (_) => _pauseOnTouch(), child: child);

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 5 : 5,
      width: isActive ? 20 : 5,
      decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        _getWrapper(
          PageView.builder(
            scrollDirection: widget.scrollDirection,
            controller: widget.pageController,
            reverse: widget.reverse,
            itemCount: widget.enableInfiniteScroll ? null : widget.items.length,
            onPageChanged: (int index) {
              int currentPage =
                  _getRealIndex(index, widget.realPage, widget.items.length);
              if (widget.onPageChanged != null) {
                widget.onPageChanged(currentPage);
              }
              setState(() {
                currentPageValue = currentPage;
              });
            },
            itemBuilder: (BuildContext context, int i) {
              final int index = _getRealIndex(
                  i + widget.initialPage, widget.realPage, widget.items.length);

              return AnimatedBuilder(
                animation: widget.pageController,
                child: widget.items[index],
                builder: (BuildContext context, child) {
                  if (widget.pageController.position.minScrollExtent == null ||
                      widget.pageController.position.maxScrollExtent == null) {
                    Future.delayed(Duration(microseconds: 1), () {
                      setState(() {});
                    });
                    return Container();
                  }
                  double value = widget.pageController.page - i;
                  value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);

                  final double height = widget.height ??
                      MediaQuery.of(context).size.width *
                          (1 / widget.aspectRatio);
                  final double distortionValue = widget.enlargeCenterPage
                      ? Curves.easeOut.transform(value)
                      : 1.0;

                  if (widget.scrollDirection == Axis.horizontal) {
                    return Center(
                        child: SizedBox(
                            height: distortionValue * height, child: child));
                  } else {
                    return Center(
                      child: SizedBox(
                          width: distortionValue *
                              MediaQuery.of(context).size.width,
                          child: child),
                    );
                  }
                },
              );
            },
          ),
        ),
        widget.withIndicator
            ? Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < widget.items.length; i++)
                          if (i == currentPageValue) ...[circleBar(true)] else
                            circleBar(false),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: width,
              )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}

int _getRealIndex(int position, int base, int length) {
  final int offset = position - base;
  return _remainder(offset, length);
}

int _remainder(int input, int source) {
  final int result = input % source;
  return result < 0 ? source + result : result;
}
