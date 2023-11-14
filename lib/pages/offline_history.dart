import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/shared/shared.dart';

class OfflineHistory extends StatefulWidget {
  const OfflineHistory({Key? key,}) : super(key: key);

  @override
  OfflineHistoryState createState() => OfflineHistoryState();
}

class OfflineHistoryState extends State<OfflineHistory> with TickerProviderStateMixin {

  late TabController tabController;

  List<Transaction> items = [];
  bool isLoading = true;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    fetchItems();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              final controller = Get.find<KuepayOfflineController>();
              controller.home();
            },
            icon: SVG(
                'assets/icons/back_arrow.svg',
                height: 24,
                width: 24,
                color: CustomColors.dynamicColor(
                    colorScheme: ColorThemeScheme.accent
                ),
                semanticsLabel: "Back"
            ),
          ),
          title: CustomText(
            "Offline History",
            style: TextStyles(
                color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.primaryHeader)
            ).displayTitleSmall,
          ),
          backgroundColor: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.background),
          elevation: 0,
        ),
        backgroundColor: CustomColors.dynamicColor(
            colorScheme: ColorThemeScheme.background
        ),
        body: Container(
          color: CustomColors.dynamicColor(
              colorScheme: ColorThemeScheme.background
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 46,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(7)
                    ),
                    color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.greyAccentThree)
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 36,
                      child: TabBar(
                        controller: tabController,
                        indicator: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(6)
                          ),
                          color: CustomColors.dynamicColor(
                              colorScheme: ColorThemeScheme.background
                          ),
                        ),
                        labelColor: CustomColors.dynamicColor(
                            colorScheme: ColorThemeScheme.primaryHeader
                        ),
                        labelStyle: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                        unselectedLabelColor: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.greyAccentTwo),
                        unselectedLabelStyle: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                        onTap: (index) {},///for taps alone
                        tabs: const [
                          Tab(
                            text: "All",
                          ),
                          Tab(
                            text: "Money In",
                          ),
                          Tab(
                            text: "Money Out",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 1.5),
                    child: _List(tabController, isLoading: isLoading, items: items),
                  )
              )
            ],
          ),
        )
    );
  }

  Future<void> fetchItems() async {
    List<Transaction> newItems = [];
    
    final stringTransactions = await OfflineTransactions.transactions;
    
    for (String encrypted in stringTransactions) {
      final decrypted = await Utils.decryptVariable(encrypted);
      final Map<String, dynamic> data = jsonDecode(decrypted) as Map<String, dynamic>;


      final value = num.parse(data[Constants.value] ?? "0").ceil();

      String amount = (value).toString();
      String currency = data[Constants.currency] ?? Constants.nairaSign;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(data[Constants.time] ?? 0);
      String description = data[Constants.description] ?? "";
      String senderID = data[Constants.senderID] ?? "";
      String senderName = data[Constants.senderName] ?? "";
      String senderWalletAddress = data[Constants.senderWalletAddress];
      String receiverID = data[Constants.receiverID];
      String receiverName = data[Constants.receiverName] ?? "";
      String receiverWalletAddress = data[Constants.receiverWalletAddress];
      bool isInflow = receiverID == Get.find<KuepayOfflineController>().data["userId"];

      final transaction = Transaction(
        id: "PROCESSING",
        uID: isInflow ? receiverID : senderID,
        value: amount,
        currency: currency,
        time: time,
        title: isInflow ? "Receive - $senderName" : "Send - $receiverName",
        type: isInflow ? 'RCV' : 'WTRF',
        imagePath: isInflow ? "assets/icons/in_transaction.svg" : "assets/icons/out_transaction.svg",
        colors: isInflow ? [CustomColors.primary[3]!] : [CustomColors.error[3]!],
        isInFlow: isInflow,
        name: isInflow ? senderName : receiverName,
        //todo TBD
        fee: 0.0,
        detail: isInflow ? senderWalletAddress : receiverWalletAddress,
        description: description,
        walletID: "1",
      );

      transaction.updateStatus("Pending");

      newItems.add(transaction);
    }
    
    if(mounted) {
      setState(() {
        items = newItems;
        
        isLoading = false;
      });
    }
  }
}

class _List extends StatelessWidget {
  final TabController tabController;
  final List<Transaction> items;
  final bool isLoading;
  const _List(this.tabController, {Key? key, required this.items, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        controller: tabController,
        children: [
          _transactionsBox(items, isLoading, null),
          _transactionsBox(items, isLoading, true),
          _transactionsBox(items, isLoading, false),
        ]
    );
  }
  
  Widget _transactionsBox(List<Transaction> items, bool isLoading, bool? isInflow){
    
    final filteredItems = filterTransactions(items, isInflow);
    
    return Align(
      alignment: Alignment.topCenter,
      child: Builder(
          builder: (context) {
            if(filteredItems.isEmpty){
              return Stack(
                alignment: Alignment.center,
                children: [
                  if(!isLoading)
                    SizedBox(
                      width: Dimen.width(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SVG(
                              'assets/images/empty_fund_history.svg',
                              height: 150,
                              width: 220,
                              semanticsLabel: "No Transaction"
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            height: 20,
                            child: CustomText(
                              'No transaction yet',
                              style: TextStyles(
                                color: CustomColors.dynamicColor(
                                    colorScheme: ColorThemeScheme.accent
                                ).withOpacity(0.4),
                              ).textBodyExtraLarge,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if(isLoading)
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(bottom: Dimen.verticalMarginHeight(context) * 3),
                        itemBuilder: (BuildContext context, int index) {
                          return const DefaultTransactionItem();
                        }
                    )
                ],
              );
            }
            else {
              final int length = filteredItems.length;

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: length,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(bottom: Dimen.verticalMarginHeight(context) * 3),
                      itemBuilder: (BuildContext context, int index) {
                        return TransactionItem(transaction: filteredItems[index], isOfflineTransaction: true);
                      }
                  ),
                ],
              );
            }

          }
      ),
    );
  }

  List<Transaction> filterTransactions(List<Transaction> items, bool? isInflow) {
    final List<Transaction> output = [];
    
    if(isInflow == null){
      return items;
    } else {
      for(Transaction transaction in items) {
        if(transaction.isInFlow == isInflow) {
          output.add(transaction);
        }
      }
      
      return output;
    }
  }
}
