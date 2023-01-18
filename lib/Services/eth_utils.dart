import 'dart:convert';
import 'package:blocksafe_mobile_app/Services/cloud_functions.dart';
import 'package:blocksafe_mobile_app/Services/provider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:currency_formatter/currency_formatter.dart';

class EthUtils {
  late http.Client httpClient;
  late Web3Client web3Client;
  final LocalStorage storage = LocalStorage("userAddress");
  dynamic balances;
  CurrencyFormatterSettings settings = CurrencyFormatterSettings(
    // formatter settings for euro
    symbol: 'UGX',
    symbolSide: SymbolSide.right,
    thousandSeparator: ',',
    decimalSeparator: '.',
    symbolSeparator: ' ',
  );
  CurrencyFormatterSettings settings1 = CurrencyFormatterSettings(
    // formatter settings for euro
    symbol: 'GCN',
    symbolSide: SymbolSide.right,
    thousandSeparator: ',',
    decimalSeparator: '.',
    symbolSeparator: ' ',
  );

  void initialSetup() async {
    httpClient = http.Client();
    const String infura =
        "https://sepolia.infura.io/v3/e6ef64d22a5f4e45a5fd5ccae89551c1";
    web3Client = Web3Client(infura, httpClient);
    storage.setItem(
        "mainSafeAddress", "0x7459715E56791bcEFb5D1F7c93f6DF582Bb371b5");
    storage.setItem(
        "tetherAddress", "0xf0F3D73f42f5138379A442fc705C1301081330b4");
    storage.setItem(
        "gencoinAddress", "0xDA00325388287b8A469b646B2488eFAd67613530");
    storage.setItem("balances", [
      CurrencyFormatter.format(0, settings, decimal: 2),
      CurrencyFormatter.format(0, settings1, decimal: 2)
    ]);
  }

  // Function to check whether the email is valid and registered in mainsafe.
  Future<String> checkEmail(String email) async {
    var response = await callMainSafe("checkEmail", [email]);
    return response;
  }

  // Function to create a user account.
  Future<String> addUser(String email) async {
    await storage.ready;
    EthereumAddress rewardTokenAddress =
        EthereumAddress.fromHex(storage.getItem("gencoinAddress"));
    var response = await callMainSafe("addUser", [email, rewardTokenAddress]);
    await Future.delayed(const Duration(seconds: 5));
    return response;
  }

  // Preparing a contract transaction call.
  Future<String> callMainSafe(String functionName, List<dynamic> args) async {
    String mainsafeAddress = storage.getItem("mainSafeAddress");
    String gencoinAddress = storage.getItem("gencoinAddress");
    String tetherAddress = storage.getItem("tetherAddress");
    await storage.ready;
    final privateKey = await CloudFunctions().getCredentials();
    EthPrivateKey cred = EthPrivateKey.fromHex(privateKey);
    final DeployedContract contract = await getContract(
        "assets/mainsafeAbi.json", "MainSafe", mainsafeAddress);
    final ethFunction = contract.function(functionName);
    final result = await web3Client.sendTransaction(
        cred,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
        ),
        chainId: 11155111,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  // Function to load contract from Abi.
  Future<DeployedContract> getContract(
      String path, String name, String address) async {
    String mainsafeAbi = await rootBundle.loadString(path);
    final contract = DeployedContract(ContractAbi.fromJson(mainsafeAbi, name),
        EthereumAddress.fromHex(address));
    return contract;
  }

  // Gets the users contract address and stores it locally.
  Future<void> getUserContract(String email) async {
    String mainsafeAddress = storage.getItem("mainSafeAddress");
    final _mainSafeContract = await getContract(
        "assets/mainsafeAbi.json", "MainSafe", mainsafeAddress);
    final ContractEvent event = _mainSafeContract.event("ShowContractAddress");
    FilterOptions options = FilterOptions(
      address: _mainSafeContract.address,
      fromBlock: const BlockNum.genesis(),
      toBlock: const BlockNum.current(),
      topics: [
        [bytesToHex(event.signature, padToEvenLength: true, include0x: true)],
      ],
    );
    var events = web3Client.events(options);
    events.listen((e) async {
      if (storage.getItem("userAddress") == null) {
        this.storage.setItem("userAddress", "0x${e.data?.substring(26)}");
        balances = await loadBalances();
        storage.setItem("balances", balances);
      }
    });
    balances = await loadBalances();
    storage.setItem("balances", balances);
    await callMainSafe("checkEmail", [email]);
  }

  Future<String> callUserContact(
      String functionName, List<dynamic> args) async {
    final privateKey = await CloudFunctions().getCredentials();
    EthPrivateKey cred = EthPrivateKey.fromHex(privateKey);
    await storage.ready;
    DeployedContract userContract = await getContract(
        "assets/userAbi.json", "User", storage.getItem("userAddress"));
    final ethFunction = userContract.function(functionName);
    final result = await web3Client.sendTransaction(
        cred,
        Transaction.callContract(
            contract: userContract, function: ethFunction, parameters: args),
        chainId: 11155111,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<String> userStake(
      BuildContext context, int amount, String email) async {
    await storage.ready;
    DeployedContract _userContract = await getContract(
        "assets/userAbi.json", "User", storage.getItem("userAddress"));
    String url =
        'https://openexchangerates.org/api/latest.json?app_id=a0b1ffe3d063455db6f29cda92b93977&base=USD&symbols=UGX&prettyprint=false&show_alternative=false';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    var monBalance = (amount / data["rates"]["UGX"]) * 1000000000000000000;
    String txnHash =
        await callUserContact("stakeTokens", [BigInt.from(monBalance), email]);
    final ContractEvent event = _userContract.event("stakeToken");
    FilterOptions options = FilterOptions(
      address: _userContract.address,
      fromBlock: const BlockNum.genesis(),
      toBlock: const BlockNum.current(),
      topics: [
        [bytesToHex(event.signature, padToEvenLength: true, include0x: true)],
      ],
    );
    var events = web3Client.events(options);
    events.listen((e) {
      var stakevalue = hexToBytes(e.data!);
      print(stakevalue);
      Provider.of(context).setStakeBalance(stakevalue[0]);
    });
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userUnstake(
      BuildContext context, int amount, String email) async {
    await storage.ready;
    DeployedContract _userContract = await getContract(
        "assets/userAbi.json", "User", storage.getItem("userAddress"));
    String url =
        'https://openexchangerates.org/api/latest.json?app_id=a0b1ffe3d063455db6f29cda92b93977&base=USD&symbols=UGX&prettyprint=false&show_alternative=false';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    var monBalance = (amount / data["rates"]["UGX"]) * 1000000000000000000;

    String txnHash = await callUserContact(
        "unstakeTokens", [BigInt.from(monBalance), email]);
    final ContractEvent event = _userContract.event("stakeToken");
    FilterOptions options = FilterOptions(
      address: _userContract.address,
      fromBlock: const BlockNum.genesis(),
      toBlock: const BlockNum.current(),
      topics: [
        [bytesToHex(event.signature, padToEvenLength: true, include0x: true)],
      ],
    );
    var events = web3Client.events(options);
    events.listen((e) {
      var stakevalue = hexToBytes(e.data!);
      print(stakevalue);
      Provider.of(context).setStakeBalance(int.parse(stakevalue.join("")));
    });
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userDeposit(int amount, String email) async {
    String url =
        'https://openexchangerates.org/api/latest.json?app_id=a0b1ffe3d063455db6f29cda92b93977&base=USD&symbols=UGX&prettyprint=false&show_alternative=false';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    double rate = data["rates"]["UGX"];
    double monBalance = (amount / rate) * 1000000000000000000;
    EtherAmount _amount =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(monBalance));
    print((_amount.getInWei.toInt() / 1000000000000000000) *
        data["rates"]["UGX"]);
    String txnHash =
        await callUserContact("deposit", [BigInt.from(monBalance), email]);
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userWithdraw(int amount, String email) async {
    String txnHash = await callUserContact("withdraw", [amount, email]);
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userBorrow(int amount, String email) async {
    String txnHash = await callUserContact("borrowTokens", [amount, email]);
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userTransferEmail(
      int amount, int charge, String receiverEmail, String email) async {
    String txnHash = await callUserContact(
        "sendTokensEmail", [amount, charge, receiverEmail, email]);
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userTransferAddress(int amount, int charge,
      EthereumAddress receiverAddress, String email) async {
    String txnHash = await callUserContact(
        "sendTokensAddress", [amount, charge, receiverAddress, email]);
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userRepay(int amount, int charge) async {
    String txnHash = await callUserContact("repay", [amount, charge]);
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<List<dynamic>> loadBalances() async {
    await storage.ready;
    DeployedContract tether = await getContract(
        "assets/TetherAbi.json", "Tether", storage.getItem("tetherAddress"));
    DeployedContract gencoin = await getContract(
        "assets/GencoinAbi.json", "Gencoin", storage.getItem("gencoinAddress"));
    EthereumAddress userAddress =
        EthereumAddress.fromHex(storage.getItem("userAddress"));
    final tetherBalance = await web3Client.call(
        contract: tether,
        function: tether.function("balanceOf"),
        params: [userAddress]);
    var val = EtherAmount.fromUnitAndValue(EtherUnit.wei, tetherBalance[0]);
    String url =
        'https://openexchangerates.org/api/latest.json?app_id=a0b1ffe3d063455db6f29cda92b93977&base=USD&symbols=UGX&prettyprint=false&show_alternative=false';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    var monBalance =
        (val.getInWei.toInt() / 1000000000000000000) * data["rates"]["UGX"];
    String val1 = CurrencyFormatter.format(monBalance, settings, decimal: 2);

    final gencoinBalance = await web3Client.call(
        contract: gencoin,
        function: tether.function("balanceOf"),
        params: [userAddress]);
    var genCoin =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, gencoinBalance[0]);
    var val2 = CurrencyFormatter.format(
        genCoin.getValueInUnit(EtherUnit.ether), settings1,
        decimal: 2);
    return [val1, val2];
  }
}
