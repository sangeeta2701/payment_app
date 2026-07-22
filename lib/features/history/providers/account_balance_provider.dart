import 'package:flutter_riverpod/legacy.dart';

enum BalanceState { initial, loading, fetched }

class AccountBalanceData {
  final String accountId;
  final String bankName;
  final String accountNumber; // e.g. "0106"
  final BalanceState state;
  final double? balance;

  AccountBalanceData({
    required this.accountId,
    required this.bankName,
    required this.accountNumber,
    this.state = BalanceState.initial,
    this.balance,
  });

  AccountBalanceData copyWith({
    BalanceState? state,
    double? balance,
  }) {
    return AccountBalanceData(
      accountId: accountId,
      bankName: bankName,
      accountNumber: accountNumber,
      state: state ?? this.state,
      balance: balance ?? this.balance,
    );
  }
}

class AccountBalanceNotifier extends StateNotifier<Map<String, AccountBalanceData>> {
  AccountBalanceNotifier()
      : super({
          'sbi': AccountBalanceData(accountId: 'sbi', bankName: 'SBI Bank', accountNumber: '0106'),
          'hdfc': AccountBalanceData(accountId: 'hdfc', bankName: 'HDFC Bank', accountNumber: '3291'),
        });

  void startLoading(String accountId) {
    if (!state.containsKey(accountId)) return;
    state = {
      ...state,
      accountId: state[accountId]!.copyWith(state: BalanceState.loading),
    };
  }

  void setBalance(String accountId, double newBalance) {
    if (!state.containsKey(accountId)) return;
    state = {
      ...state,
      accountId: state[accountId]!.copyWith(
        state: BalanceState.fetched,
        balance: newBalance,
      ),
    };
  }
}

final accountBalanceProvider =
    StateNotifierProvider<AccountBalanceNotifier, Map<String, AccountBalanceData>>(
  (ref) => AccountBalanceNotifier(),
);