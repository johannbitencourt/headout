import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:headout/db/players_database.dart';
import 'package:headout/model/player.dart';
import 'package:headout/pages/players/edit_player_page.dart';
import 'package:headout/pages/players/player_detail_page.dart';
import 'package:headout/widgets/players/player_card_widget.dart';

class PlayersPage extends StatefulWidget {
  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  late List<Player> players;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshPlayers();
  }

  @override
  void dispose() {
    PlayersDatabase.instance.close();

    super.dispose();
  }

  Future refreshPlayers() async {
    setState(() => isLoading = true);

    players = await PlayersDatabase.instance.readAllPlayers();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Players',
        style: TextStyle(fontSize: 24),
      ),
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : players.isEmpty
              ? const Text(
                  'No Players',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )
              : buildPlayers(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Color(0xFF00dac6),
      child: const Icon(Icons.add, color: Colors.black,),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const AddEditPlayerPage()),
        );
        refreshPlayers();
      },
    ),
  );

  Widget buildPlayers() => StaggeredGridView.countBuilder(
    padding: const EdgeInsets.all(8),
    itemCount: players.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final player = players[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PlayerDetailPage(playerId: player.id!),
          ));
          refreshPlayers();
        },
        child: PlayerCardWidget(player: player, index: index),
      );
    },
  );
}
