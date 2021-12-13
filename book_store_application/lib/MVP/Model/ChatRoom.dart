class ChatRoom {

  late String chatRoomID;
  late String userName;
  late bool isSeenByAdmin;
  late String latestMessage;
  late int latestMessageTime;

  ChatRoom(String ID, String NAME, bool isSeen, String Message, int Time) {
    this.chatRoomID = ID;
    this.userName = NAME;
    this.isSeenByAdmin = isSeen;
    this.latestMessage = Message;
    this.latestMessageTime = Time;
  }

  String getID() {return this.chatRoomID;}
  void setID(String ID) {this.chatRoomID = ID;}

  String getNAME() {return this.userName;}
  void setNAME(String NAME) {this.userName = NAME;}

  bool getIsSeen() {return this.isSeenByAdmin;}
  void setIsSeen(bool isSeen) {this.isSeenByAdmin = isSeen;}

  String getLatestMessage() {return this.latestMessage;}
  void setLatestMessage(String Message) {this.latestMessage = Message;}

  int getlatestMessageTime() {return this.latestMessageTime;}
  void setLatestMessageTime(int Time) {this.latestMessageTime = Time;}


}