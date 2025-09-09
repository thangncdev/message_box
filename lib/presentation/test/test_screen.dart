import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:ui';

class TutorialExample extends StatefulWidget {
  const TutorialExample({super.key});

  @override
  State<TutorialExample> createState() => _TutorialExampleState();
}

class _TutorialExampleState extends State<TutorialExample> {
  final GlobalKey _editButtonKey = GlobalKey();
  final GlobalKey _settingsButtonKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _createTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo app'),
        actions: [
          IconButton(
            key: _editButtonKey,
            onPressed: () {
              // Do nothing
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            key: _settingsButtonKey,
            onPressed: () {
              // Do nothing
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Expanded(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                key: _buttonKey,
                onPressed: () {}, child: Text("data")),
            ),
          ],
        ),
      ),
      
    );
  }

  Future<void> _createTutorial() async {
    final targets = [
     TargetFocus(
        identify: 'centerButton',
        keyTarget: _buttonKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Text(
              'Configure the app in the settings screen',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'editButton',
        keyTarget: _editButtonKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Text(
              'You can edit the entries by pressing on the edit button',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'settingsButton',
        keyTarget: _settingsButtonKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Text(
              'Configure the app in the settings screen',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      )
    ];

    final tutorial = TutorialCoachMark(targets: targets);


    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });
  }
}
