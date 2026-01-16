import 'package:flutter/material.dart';

enum TutorialStep {
  welcome,
  roleAssignment,
  roleReveal,
  nightIntro,
  werewolfAction,
  seerAction,
  dayIntro,
  discussion,
  voting,
  conclusion,
}

class TutorialMessage {
  final String title;
  final String content;
  final String? actionLabel;
  final VoidCallback? onAction;

  TutorialMessage({
    required this.title,
    required this.content,
    this.actionLabel,
    this.onAction,
  });
}

class TutorialManager extends ChangeNotifier {
  TutorialStep _currentStep = TutorialStep.welcome;

  TutorialStep get currentStep => _currentStep;

  TutorialMessage get currentMessage {
    switch (_currentStep) {
      case TutorialStep.welcome:
        return TutorialMessage(
          title: 'Willkommen zum Training',
          content:
              'Lerne die Grundlagen von Werwolf in diesem interaktiven Tutorial. Wir spielen eine simulierte Runde.',
          actionLabel: 'Starten',
        );
      case TutorialStep.roleAssignment:
        return TutorialMessage(
          title: 'Rollenverteilung',
          content:
              'Zu Beginn des Spiels erhält jeder Spieler eine geheime Rolle. Deine Rolle bestimmt dein Ziel und deine Fähigkeiten.',
          actionLabel: 'Weiter',
        );
      case TutorialStep.roleReveal:
        return TutorialMessage(
          title: 'Deine Rolle',
          content:
              'Du bist ein Dorfbewohner. Dein Ziel ist es, die Werwölfe zu finden und zu eliminieren.',
          actionLabel: 'Verstanden',
        );
      case TutorialStep.nightIntro:
        return TutorialMessage(
          title: 'Die Nacht',
          content:
              'In der Nacht schlafen alle Dorfbewohner. Nur bestimme Rollen (wie Werwölfe) wachen auf, um Aktionen auszuführen.',
          actionLabel: 'Weiter',
        );
      case TutorialStep.werewolfAction:
        return TutorialMessage(
          title: 'Werwolf Phase',
          content:
              'Die Werwölfe wählen gemeinsam ein Opfer aus, das eliminiert werden soll.',
          actionLabel: 'Beobachten',
        );
      case TutorialStep.seerAction:
        return TutorialMessage(
          title: 'Seherin Phase',
          content: 'Die Seherin darf die Identität eines Spielers überprüfen.',
          actionLabel: 'Weiter',
        );
      case TutorialStep.dayIntro:
        return TutorialMessage(
          title: 'Der Tag',
          content:
              'Der Tag beginnt. Wenn jemand gestorben ist, wird es verkündet.',
          actionLabel: 'Weiter',
        );
      case TutorialStep.discussion:
        return TutorialMessage(
          title: 'Diskussion',
          content:
              'Diskutiere mit anderen Spielern (oder Bots), um verdächtiges Verhalten zu identifizieren.',
          actionLabel: 'Weiter',
        );
      case TutorialStep.voting:
        return TutorialMessage(
          title: 'Abstimmung',
          content:
              'Jeder Spieler hat eine Stimme. Wer die meisten Stimmen erhält, wird aus dem Dorf verbannt.',
          actionLabel: 'Abstimmen',
        );
      case TutorialStep.conclusion:
        return TutorialMessage(
          title: 'Abschluss',
          content:
              'Das Spiel endet, wenn alle Werwölfe eliminiert sind oder die Werwölfe die Überzahl haben.',
          actionLabel: 'Training Beenden',
        );
    }
  }

  void nextStep() {
    if (_currentStep.index < TutorialStep.values.length - 1) {
      _currentStep = TutorialStep.values[_currentStep.index + 1];
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep.index > 0) {
      _currentStep = TutorialStep.values[_currentStep.index - 1];
      notifyListeners();
    }
  }

  void reset() {
    _currentStep = TutorialStep.welcome;
    notifyListeners();
  }
}
