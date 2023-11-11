class Constants {

  //QR abbreviations
  static const String value = "v";
  static const String currency = 'c';
  static const String time = "t";
  static const String description = "des";
  static const String receiverID = "r_ID";
  static const String receiverName = 'r_N';
  static const String receiverWalletAddress = 'r_WA';
  static const String senderID = "s_ID";
  static const String senderName = 's_N';
  static const String senderWalletAddress = "s_WA";
  static const String isOnlineReceive = 'is_R';

  static const int largeScreenSize = 1368;
  static const int mediumScreenSize = 1024;
  static const int smallScreenSize = 720;
  static const int extraSmallScreenSize = 500;

  static const String nairaSign = "N";

  static Map<String, String> transactionType = {
    "TRF" : "Bank Transfer",
    "FND" : "Wallet Fund",
    "ARTM" : "Airtime Purchase",
    "DTPRCHS" : "Data Purchase",
    "CTV" : "Cable TV Purchase",
    "ELCT" : "Electricity Purchase",
    "WTRF" : "Wallet Transfer",
    "CRDFND" : "Card Fund",
    "RCV" : "Funds Received",
    "PRCHS" : "Merchant Purchase",
  };
}