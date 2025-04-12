import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool status,
    required int statusCode,
    String? message,
    required T data,
  }) = _ApiResponse<T>;

  // When using generics, you must include a function parameter to deserialize T.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

/// User Model
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    String? name,
    required String email,
    String? password,
    // @Default([]) List<Account> accounts,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Transaction Model
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required int amount,
    required String senderId,
    required String receiverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

/// Account Model
@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    String? name,
    required String accountNumber,
    required String userId,
    @Default(0) int balance,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<Transaction> sentTransactions,
    @Default([]) List<Transaction> receivedTransactions,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
