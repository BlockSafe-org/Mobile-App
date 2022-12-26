import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:is_first_run/is_first_run.dart';
import 'package:localstorage/localstorage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class EthUtils {
  late http.Client httpClient;
  late Web3Client web3Client;
  final LocalStorage storage = LocalStorage("userAddress");
  final mainSafeAddress = dotenv.env["MAINSAFE_SEPOLIA_ADDRESS"];
  final tetherAddress = dotenv.env["TETHER_SEPOLIA_ADDRESS"];
  final gencoinAddress = dotenv.env["GENCOIN_SEPOLIA_ADDRESS"];

  void initialSetup() async {
    httpClient = http.Client();
    String infura =
        "https://sepolia.infura.io/v3/${dotenv.env["INFURA_API_KEY"]}";
    web3Client = Web3Client(infura, httpClient);
  }

  // Function to check whether the email is valid and registered in mainsafe.
  Future<String> checkEmail(String email) async {
    var response = await callMainSafe("checkEmail", [email]);
    return response;
  }

  // Function to create a user account.
  Future<String> addUser(String email) async {
    EthereumAddress rewardTokenAddress =
        EthereumAddress.fromHex(dotenv.env["GENCOIN_SEPOLIA_ADDRESS"]!);
    var response = await callMainSafe("addUser", [email, rewardTokenAddress]);
    await Future.delayed(const Duration(seconds: 5));
    return response;
  }

  // Preparing a contract transaction call.
  Future<String> callMainSafe(String functionName, List<dynamic> args) async {
    EthPrivateKey cred = EthPrivateKey.fromHex(dotenv.env["TEST_KEY1"]!);
    final DeployedContract contract = await getContract(
        "assets/mainsafeAbi.json", "MainSafe", mainSafeAddress!);
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
    final _mainSafeContract = await getContract(
        "assets/mainsafeAbi.json", "MainSafe", mainSafeAddress!);
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
    events.listen((e) {
      // ignore: unnecessary_this
      this.storage.setItem("userAddress", "0x${e.data?.substring(26)}");
    });
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<String> callUserContact(
      String functionName, List<dynamic> args) async {
    EthPrivateKey cred = EthPrivateKey.fromHex(dotenv.env["TEST_KEY1"]!);
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

  Future<String> userStake(int amount, String email) async {
    DeployedContract _userContract = await getContract(
        "assets/userAbi.json", "User", storage.getItem("userAddress"));
    String txnHash = await callUserContact("stakeTokens", [amount, email]);
    final ContractEvent event = _userContract.event("ShowContractAddress");
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userUnstake(int amount, String email) async {
    DeployedContract _userContract = await getContract(
        "assets/userAbi.json", "User", storage.getItem("userAddress"));
    String txnHash = await callUserContact("unstakeTokens", [amount, email]);
    final ContractEvent event = _userContract.event("ShowContractAddress");
    await Future.delayed(const Duration(seconds: 5));
    return txnHash;
  }

  Future<String> userDeposit(int amount, String email) async {
    String txnHash = await callUserContact("stakeTokens", [amount, email]);
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
    DeployedContract tether =
        await getContract("assets/TetherAbi.json", "Tether", tetherAddress!);
    DeployedContract gencoin =
        await getContract("assets/GencoinAbi.json", "Gencoin", gencoinAddress!);
    EthereumAddress userAddress =
        EthereumAddress.fromHex(storage.getItem("userAddress"));
    final tetherBalance = await web3Client.call(
        contract: tether,
        function: tether.function("balanceOf"),
        params: [userAddress]);
    final gencoinBalance = await web3Client.call(
        contract: gencoin,
        function: tether.function("balanceOf"),
        params: [userAddress]);
    return [tetherBalance[0], gencoinBalance[0]];
  }
}
