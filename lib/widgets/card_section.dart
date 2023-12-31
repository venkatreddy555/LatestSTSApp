import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/utils/Constants.dart';
import 'package:schooltrackingsystem/widgets/custom_clipper.dart';

class CardSection extends StatelessWidget {
  final String title;
  final String value;
  final ImageProvider image;

  const CardSection(
      {Key? key,
      required this.title,
      required this.value,
      required this.image,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            margin: const EdgeInsets.only(right: 15.0),
            width: 240,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge, children: <Widget>[
                Positioned(
                    child: ClipPath(
                        clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            color: Constants.lightBlue.withOpacity(0.1),
                          ),
                          height: 220,
                          width: 220,
                        ),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image(
                            image: image,
                            width: 24,
                            height: 24,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.textPrimary
                                    ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
        ),
    );
  }
}
