import 'package:equatable/equatable.dart';

class PushMessage extends Equatable {
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const PushMessage({this.title, this.body, this.data = const {}});

  @override
  List<Object?> get props => [title, body, data];
}
