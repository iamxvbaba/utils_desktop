import 'package:flutter/material.dart';
import 'package:skeleton_desktop/ui/widgets/poker/model.dart';

class PokerCard extends StatelessWidget {
  final Rank rank;
  final Suit suit;
  final GestureTapCallback? callback;
  final double height;
  final double width;
  final bool available;

  const PokerCard(
      {required this.rank,
      required this.suit,
      this.available = false,
      this.height = 80,
      this.width = 60,
      this.callback,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: callback,
        child: HighlightContainer(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height, width: width),
            child: AspectRatio(
              aspectRatio: 2.25 / 3.5,
              child: LayoutBuilder(
                builder: (_, constraints) => DecoratedBox(
                  decoration: BoxDecoration(
                    color: available ? Colors.lime : Colors.black12,
                    borderRadius:
                        BorderRadius.circular(constraints.maxWidth * 0.1),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          rank.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: suit.color(),
                            fontSize: constraints.maxHeight * 0.475,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: constraints.maxHeight * 0.05,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(
                              suit.icon(),
                              color: suit.color(),
                              size: constraints.maxHeight * 0.475,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class HighlightContainer extends StatefulWidget {
  final Widget child;

  const HighlightContainer({Key? key, required this.child}) : super(key: key);

  @override
  State<HighlightContainer> createState() => _HighlightContainerState();
}

class _HighlightContainerState extends State<HighlightContainer> {
  bool _isHovered = false;

  void _onEnter(PointerEvent event) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _isHovered ? Colors.blue : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
