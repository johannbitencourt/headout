import 'package:flutter/material.dart';
import 'package:headout/model/player.dart';
import 'package:headout/widgets/rating.dart';

final _customColors = [
  const Color(0xFF1e1e1e)
];

class PlayerCardWidget extends StatelessWidget {
  const PlayerCardWidget({
    Key? key,
    required this.player,
    required this.index,
  }) : super(key: key);

  final Player player;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _customColors[index % _customColors.length];

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: 100),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 13.0),
                      child: Text(player.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (player.isParticipant) Container(
                    padding: EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFbc85f6)
                      ),
                    child: InkWell(
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 35, top: 10),
              child: Rating(player.classification, 5),
            ),
          ],
        ),
      ),
    );
  }
}
