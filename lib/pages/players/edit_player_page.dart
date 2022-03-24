import 'package:flutter/material.dart';
import 'package:headout/db/players_database.dart';
import 'package:headout/model/player.dart';
import 'package:headout/widgets/players/player_form_widget.dart';

class AddEditPlayerPage extends StatefulWidget {
  final Player? player;

  const AddEditPlayerPage({
    Key? key,
    this.player,
  }) : super(key: key);
  @override
  _AddEditPlayerPageState createState() => _AddEditPlayerPageState();
}

class _AddEditPlayerPageState extends State<AddEditPlayerPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isParticipant;
  late int classification;
  late String name;

  @override
  void initState() {
    super.initState();

    isParticipant = widget.player?.isParticipant ?? false;
    classification = widget.player?.classification ?? 0;
    name = widget.player?.name ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: PlayerFormWidget(
        isParticipant: isParticipant,
        classification: classification,
        name: name,
        onChangedParticipant: (isParticipant) => setState(() => this.isParticipant = isParticipant),
        onChangedClassification: (classification) => setState(() => this.classification = classification),
        onChangedName: (name) => setState(() => this.name = name),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = name.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: TextButton(
        child: Text('Save'), 
        style: TextButton.styleFrom(
          primary: isFormValid ? null : Colors.grey.shade700
        ), 
        onPressed: addOrUpdatePlayer
      ),
    );
  }

  void addOrUpdatePlayer() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.player != null;

      if (isUpdating) {
        await updatePlayer();
      } else {
        await addPlayer();
      }
      Navigator.of(context).pop();
    }
  }

  Future updatePlayer() async {
    final player = widget.player!.copy(
      isParticipant: isParticipant,
      classification: classification,
      name: name,
    );
    await PlayersDatabase.instance.update(player);
  }

  Future addPlayer() async {
    final player = Player(
      name: name,
      isParticipant: isParticipant,
      classification: classification,
      createdTime: DateTime.now(),
    );
    await PlayersDatabase.instance.create(player);
  }
}
