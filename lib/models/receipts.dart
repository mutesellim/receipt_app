class Receipts {
  int receiptID;
  int pictureID;
  String receiptTitle;
  String receiptDescription;
  String videoURL;

  Receipts(this.receiptTitle,
      this.receiptDescription, this.videoURL);

  Map<String,dynamic>toMap(){
    var map = Map<String,dynamic>();
    map["receiptID"]=receiptID;
    map["pictureID"]=pictureID;
    map["receiptTitle"]=receiptTitle;
    map["receiptDescription"]=receiptDescription;
    map["videoURL"]=videoURL;
    return map;
  }

  Receipts.fromMap(Map<String, dynamic> map) {
    this.receiptID = map["receiptID"];
    this.pictureID = map["pictureID"];
    this.receiptTitle = map["receiptTitle"];
    this.receiptDescription = map["receiptDescription"];
    this.videoURL = map["videoURL"];
  }

  @override
  String toString() {
    return 'Receipts{receiptID: $receiptID, pictureID: $pictureID, receiptTitle: $receiptTitle, receiptDescription: $receiptDescription, videoURL: $videoURL}';
  }
}
