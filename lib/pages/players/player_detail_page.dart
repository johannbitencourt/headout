import 'package:flutter/material.dart';
import 'package:headout/db/players_database.dart';
import 'package:headout/model/player.dart';
import 'package:headout/pages/players/edit_player_page.dart';
import 'package:headout/widgets/rating.dart';

class PlayerDetailPage extends StatefulWidget {
  final int playerId;

  const PlayerDetailPage({
    Key? key,
    required this.playerId,
  }) : super(key: key);

  @override
  _PlayerDetailPageState createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  late Player player;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshPlayer();
  }

  Future refreshPlayer() async {
    setState(() => isLoading = true);
    this.player = await PlayersDatabase.instance.readPlayer(widget.playerId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : this.buildPlayerDetails(),
      );

  Widget buildPlayerDetails() => Center(
        heightFactor: 5,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Rating(player.classification, 5),
              ],
            ),
          ),
        ),
      );

  Widget editButton() => IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () async {
          if (isLoading) return;

          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddEditPlayerPage(player: player),
          ));

          refreshPlayer();
        },
      );

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await PlayersDatabase.instance.delete(widget.playerId);

          Navigator.of(context).pop();
        },
      );
}
