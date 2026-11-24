import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/cubit/mistake_box_cubit.dart';

sealed class QuizState extends Equatable {
  const QuizState();
}

final class QuizLoading extends QuizState {
  const QuizLoading();

  @override
  List<Object?> get props => const [];
}

final class QuizLoadFailure extends QuizState {
  const QuizLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class QuizInProgress extends QuizState {
  const QuizInProgress({
    required this.session,
    required this.index,
    required this.selectedAnswerIds,
    required this.showingResult,
  });

  final QuizSession session;
  final int index;
  final Map<int, int> selectedAnswerIds;
  final bool showingResult;

  Question get current => session.questions[index];

  bool answeredCorrectly(Question question) {
    final selected = selectedAnswerIds[question.id];
    if (selected == null) {
      return false;
    }
    return question.answers.any(
      (answer) => answer.id == selected && answer.isCorrect,
    );
  }

  int get correctCount {
    var count = 0;
    for (final question in session.questions) {
      if (answeredCorrectly(question)) {
        count += 1;
      }
    }
    return count;
  }

  QuizInProgress copyWith({
    int? index,
    Map<int, int>? selectedAnswerIds,
    bool? showingResult,
  }) {
    return QuizInProgress(
      session: session,
      index: index ?? this.index,
      selectedAnswerIds: selectedAnswerIds ?? this.selectedAnswerIds,
      showingResult: showingResult ?? this.showingResult,
    );
  }

  @override
  List<Object?> get props => [session, index, selectedAnswerIds, showingResult];
}

final class QuizCubit extends Cubit<QuizState> {
  QuizCubit(this._startQuiz, {this._mistakes}) : super(const QuizLoading());

  final StartQuiz _startQuiz;
  final MistakeRecord? _mistakes;
  QuizRequest? _request;

  Future<void> load(QuizRequest request) async {
    _request = request;
    emit(const QuizLoading());
    final result = await _startQuiz(request);
    switch (result) {
      case Success(:final value):
        if (value.questions.isEmpty) {
          emit(const QuizLoadFailure('В наборе нет вопросов.'));
          return;
        }
        emit(
          QuizInProgress(
            session: value,
            index: 0,
            selectedAnswerIds: const <int, int>{},
            showingResult: false,
          ),
        );
      case FailureResult(:final failure):
        emit(QuizLoadFailure(failure.message));
    }
  }

  Future<void> retry() async {
    final request = _request;
    if (request == null) {
      return;
    }
    await load(request);
  }

  void selectAnswer(int answerId) {
    final current = state;
    if (current is! QuizInProgress || current.showingResult) {
      return;
    }
    final question = current.current;
    if (current.selectedAnswerIds.containsKey(question.id)) {
      return;
    }
    final known = question.answers.any((answer) => answer.id == answerId);
    if (!known) {
      return;
    }
    final selected = Map<int, int>.of(current.selectedAnswerIds);
    selected[question.id] = answerId;
    emit(current.copyWith(selectedAnswerIds: selected));
    final correct = question.answers.any(
      (answer) => answer.id == answerId && answer.isCorrect,
    );
    if (correct) {
      _mistakes?.forget(question.id);
    } else {
      _mistakes?.remember(question.id);
    }
  }

  void selectAnswerAt(int index) {
    final current = state;
    if (current is! QuizInProgress || current.showingResult) {
      return;
    }
    final answers = current.current.answers;
    if (index < 0 || index >= answers.length) {
      return;
    }
    selectAnswer(answers[index].id);
  }

  void openQuestion(int index) {
    final current = state;
    if (current is! QuizInProgress) {
      return;
    }
    final questions = current.session.questions;
    if (index < 0 || index >= questions.length) {
      return;
    }
    final allAnswered = current.selectedAnswerIds.length == questions.length;
    if (!allAnswered) {
      final targetId = questions[index].id;
      final answered = current.selectedAnswerIds.containsKey(targetId);
      final firstOpen = questions.indexWhere(
        (question) => !current.selectedAnswerIds.containsKey(question.id),
      );
      if (!answered && index != firstOpen) {
        return;
      }
    }
    emit(current.copyWith(index: index, showingResult: false));
  }

  void next() {
    final current = state;
    if (current is! QuizInProgress || current.showingResult) {
      return;
    }
    if (!current.selectedAnswerIds.containsKey(current.current.id)) {
      return;
    }
    final last = current.index == current.session.questions.length - 1;
    if (last) {
      showResult();
      return;
    }
    emit(current.copyWith(index: current.index + 1));
  }

  void previous() {
    final current = state;
    if (current is! QuizInProgress || current.index == 0) {
      return;
    }
    openQuestion(current.index - 1);
  }

  void showResult() {
    final current = state;
    if (current is! QuizInProgress) {
      return;
    }
    if (current.selectedAnswerIds.length != current.session.questions.length) {
      return;
    }
    emit(current.copyWith(showingResult: true));
  }

  void reviewMistakes() {
    final current = state;
    if (current is! QuizInProgress) {
      return;
    }
    final index = current.session.questions.indexWhere(
      (question) => !current.answeredCorrectly(question),
    );
    openQuestion(index < 0 ? 0 : index);
  }
}
