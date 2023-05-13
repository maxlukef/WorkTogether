class Message {
  String messageText = "";
  int senderID = -1;
  String senderName = "";

  Message(String text, String sender, int userID) {
    messageText = text;
    senderID = userID;
    senderName = sender;
  }
}
