import 'package:blind_typing/features/typing/const/keyboard.dart';
import 'package:blind_typing/features/typing/countdown_timer_widget.dart';
import 'package:blind_typing/features/typing/utils/extension/random_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum GameStateType {
  beforeStart,
  playing,
  finished;

  @override
  String toString() {
    return name;
  }
}

class TypingGame extends HookWidget {
  const TypingGame({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = useState(GameStateType.beforeStart);

    final targetKeyState = useState(qwertyKeyboard.all.getRandom());
    final pressingKeyState = useState<String?>(null);
    final lastPressed = useState<String>('');

    final warnCountState = useState(0);
    final successCountState = useState(0);

    final isCountDown = useMemoized(
        () => gameState.value == GameStateType.playing, [gameState.value]);

    useEffect(() {
      HardwareKeyboard.instance.addHandler((event) {
        keyboardDetector(event, pressingKeyState.value, onPressedChanged: () {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            pressingKeyState.value = 'Space';
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            pressingKeyState.value = 'Escape';
          } else {
            pressingKeyState.value = event.character?.toUpperCase();
          }
        }, onRelease: () {
          pressingKeyState.value = null;
        });

        return true;
      });
      return null;
    }, []);

    useEffect(() {
      if (pressingKeyState.value == null) return;

      if (pressingKeyState.value == 'Escape') {
        gameState.value = GameStateType.beforeStart;
      }

      if (gameState.value == GameStateType.beforeStart) {
        if (pressingKeyState.value == "Space") {
          gameState.value = GameStateType.playing;
          warnCountState.value = 0;
          successCountState.value = 0;
        }
      }

      if (gameState.value == GameStateType.playing) {
        lastPressed.value = pressingKeyState.value!;

        if (pressingKeyState.value == targetKeyState.value) {
          successCountState.value++;
          targetKeyState.value = qwertyKeyboard.all.getRandom();
        } else {
          warnCountState.value++;
        }
      }
      return;
    }, [pressingKeyState.value]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (gameState.value == GameStateType.beforeStart) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "[ ???????????? ]?????????",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const Text('[ Esc ] ???????????????')
            ],
            if (gameState.value == GameStateType.playing) ...[
              CountdownTimerWidget(
                  timeLimit: const Duration(seconds: 40),
                  tick: const Duration(milliseconds: 10),
                  onEndedCallback: () {
                    gameState.value = GameStateType.finished;
                  },
                  isCountdown: isCountDown),
              Text(
                targetKeyState.value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 150,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text('???????????????????????????: '),
                  Text(
                    lastPressed.value,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Score: '),
                  Text(
                    successCountState.value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.green),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Miss: '),
                  Text(
                    warnCountState.value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.red),
                  ),
                ],
              )
            ],
            if (gameState.value == GameStateType.finished) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Score: ',
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    successCountState.value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.green),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Miss: ',
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    warnCountState.value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.red),
                  ),
                ],
              ),
              const Text('[ Esc ] ???????????????'),
            ]
          ],
        ),
      ),
    );
  }

  void keyboardDetector(final KeyEvent event, final String? pressingKey,
      {required VoidCallback onPressedChanged,
      required VoidCallback onRelease}) {
    if (event is KeyUpEvent) {
      onRelease();
      return;
    }
    if (pressingKey == null) {
      onPressedChanged();
    }
  }
}
