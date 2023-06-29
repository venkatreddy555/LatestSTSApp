import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/utils/Constants.dart';

class CardMain extends StatelessWidget {
  final ImageProvider image;

  const CardMain(
      {Key? key,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            margin: const EdgeInsets.only(right: 65.0),
            width: (
                (MediaQuery.of(context).size.width - (Constants.paddingSide * 2 + Constants.paddingSide / 2)) /
                2),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              shape: BoxShape.rectangle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Stack(
                  clipBehavior: Clip.hardEdge, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Icon and Hearbeat
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                width: 100,
                                height: 150,
                                image: image
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                onTap: () {
                  debugPrint("CARD main clicked. redirect to details page");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DetailScreen()),
                  // );
                },
              ),
            ),
        ),
    );
  }
}
