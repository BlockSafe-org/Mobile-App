import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ProviderState extends StatefulWidget {
  final Widget child;
  const ProviderState({Key? key, required this.child}) : super(key: key);

  @override
  State<ProviderState> createState() => _ProviderStateState();
}

class _ProviderStateState extends State<ProviderState> {
  late LocalStorage storage = LocalStorage("userAddress");
  List<dynamic> balances = [];
  // ignore: avoid_init_to_null
  late dynamic balance = null;
  late BuildContext buildContext;
  dynamic stakeBalance = 0;

  void setStorage(LocalStorage storage) {
    storage = storage;
  }

  void setBalances(List<dynamic> balances) {
    balances = balances;
  }

  void setBalance(dynamic balance) {
    balance = balance;
  }

  void setStakeBalance(dynamic amount) {
    setState(() {
      stakeBalance = amount;
    });
  }

  @override
  Widget build(BuildContext context) => Provider(
      stateWidget: this,
      storage: storage,
      balances: balances,
      stakeBalance: stakeBalance,
      balance: balance,
      child: widget.child);
}

class Provider extends InheritedWidget {
  final _ProviderStateState stateWidget;
  List<dynamic> balances;
  LocalStorage storage;
  dynamic balance;
  dynamic stakeBalance;

  Provider(
      {required Widget child,
      required this.stateWidget,
      Key? key,
      required this.balances,
      required this.stakeBalance,
      required this.balance,
      required this.storage})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static _ProviderStateState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>()!.stateWidget);
}
