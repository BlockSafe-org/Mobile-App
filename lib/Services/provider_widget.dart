import 'package:flutter/material.dart';

class ProviderState extends StatefulWidget {
  final Widget child;
  const ProviderState({Key? key, required this.child}) : super(key: key);

  @override
  State<ProviderState> createState() => _ProviderStateState();
}

class _ProviderStateState extends State<ProviderState> {
  var userContractAddress = "";

  void setUserAddress(String userAddress) {
    setState(() {
      userContractAddress = userAddress;
    });
  }

  @override
  Widget build(BuildContext context) => Provider(
      stateWidget: this,
      userContractAddress: userContractAddress,
      child: widget.child);
}

class Provider extends InheritedWidget {
  final userContractAddress;
  final _ProviderStateState stateWidget;

  Provider(
      {required Widget child,
      required this.stateWidget,
      required this.userContractAddress,
      Key? key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static _ProviderStateState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>()!.stateWidget);
}
