library scrolling_buttons_bar;

import 'package:flutter/material.dart';

class ScrollingButtonBar extends StatefulWidget {
  final List<ButtonsItem> children;
  final double childWidth;
  final double childHeight;
  final Color foregroundColor;
  final int selectedItemIndex;
  final ScrollController scrollController;

  final double radius;
  final Curve curve;
  final Duration animationDuration;

  const ScrollingButtonBar({
    Key? key,
    required this.children,
    required this.childWidth,
    required this.childHeight,
    required this.foregroundColor,
    required this.scrollController,
    required this.selectedItemIndex,
    this.radius = 0.0,
    this.curve = Curves.easeIn,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _ScrollingButtonBarState createState() => _ScrollingButtonBarState();
}

class _ScrollingButtonBarState extends State<ScrollingButtonBar> {
  int _index = -1;
  GlobalKey selectedBottomBarItemKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (selectedBottomBarItemKey.currentContext != null) {
        widget.scrollController.position.ensureVisible(
          selectedBottomBarItemKey.currentContext!.findRenderObject()!,
          alignment: 0.5, // Aligns the image in the middle.
          curve: widget.curve,
          duration: widget.animationDuration, // So it does not jump.
        );
      }
    });

    return SizedBox(
      height: widget.childHeight,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        bool isScrollable = widget.children.length * widget.childWidth < constraints.maxWidth;
        return CustomScrollView(scrollDirection: Axis.horizontal, controller: widget.scrollController, slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                AnimatedPositioned(
                  top: 0,
                  bottom: 0,
                  left: isScrollable
                      ? constraints.maxWidth / widget.children.length * (_index)
                      : widget.childWidth * _index,
                  right: isScrollable
                      ? (constraints.maxWidth / (widget.children.length)) * (widget.children.length - _index - 1)
                      : widget.childWidth * (widget.children.length - _index - 1),
                  duration: widget.animationDuration,
                  curve: widget.curve,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.foregroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: widget.children
                        .asMap()
                        .map((i, sideButton) => MapEntry(
                      i,
                      Expanded(
                        key: widget.selectedItemIndex == i
                            ? selectedBottomBarItemKey
                            : ValueKey("toolbar_item_$i"),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                try {
                                  sideButton.onTap();
                                } catch (e) {
                                  print('onTap implementation is missing');
                                }
                                setState(() {
                                  _index = i;
                                });
                              },
                              child: SizedBox(
                                  width: widget.childWidth,
                                  height: widget.childHeight,
                                  child: sideButton.child),
                            ),
                          ),
                        ),
                      ),
                    ))
                        .values
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ]);
      }),
    );
  }

  @override
  void didUpdateWidget(covariant ScrollingButtonBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_index != widget.selectedItemIndex) {
      _index = widget.selectedItemIndex;
      setState(() {});
    }
  }
}

class ButtonsItem {
  final Widget child;
  final VoidCallback onTap;

  ButtonsItem({required this.child, required this.onTap});
}
