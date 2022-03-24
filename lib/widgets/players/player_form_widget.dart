import 'package:flutter/material.dart';

class PlayerFormWidget extends StatelessWidget {
  final bool? isParticipant;
  final int? classification;
  final String? name;
  final ValueChanged<bool> onChangedParticipant;
  final ValueChanged<int> onChangedClassification;
  final ValueChanged<String> onChangedName;

  const PlayerFormWidget({
    Key? key,
    this.isParticipant = false,
    this.classification = 0,
    this.name = '',
    required this.onChangedParticipant,
    required this.onChangedClassification,
    required this.onChangedName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildName(),
              const SizedBox(height: 16),
              Row(children: [
                Text('Will the player participate?',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Switch(
                    inactiveTrackColor: Colors.grey.shade500,
                    value: (isParticipant ?? false),
                    onChanged: onChangedParticipant,
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Player Classification:',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Expanded(
                    child: Slider(
                      value: (classification ?? 0).toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      onChanged: (classification) =>
                          onChangedClassification(classification.toInt()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget buildName() => TextFormField(
    maxLines: 1,
    initialValue: name,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Name',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (name) =>
        name != null && name.isEmpty ? 'The name cannot be empty' : null,
    onChanged: onChangedName,
  );
}
