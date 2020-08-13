class Picture{
  int pictureID;
  String pictureURL;

  Picture(this.pictureID,this.pictureURL);




  Map<String,dynamic>toMap(){
    var map = Map<String,dynamic>();
    map["pictureID"]=pictureID;
    map["pictureURL"]=pictureURL;
    return map;
  }
  Picture.fromMap(Map<String,dynamic>map){
    this.pictureID=map["pictureID"];
    this.pictureURL=map["pictureURL"];
  }

  @override
  String toString() {
    return 'Picture{pictureID: $pictureID, pictureURL: $pictureURL}';
  }
}