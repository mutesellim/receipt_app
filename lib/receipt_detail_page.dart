import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height / 3;
    double myWidth = MediaQuery.of(context).size.width * (5 / 6);
    return Scaffold(
        appBar: AppBar(
          title: Text("Lahmacun"),
        ),
        body: Center(
          child: Container(
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/lahmacun.jpg",
                        width: myWidth,
                        height: myHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "  Tavada lahmacun yapılışı",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Öncelikle hamuru hazırlamak için derin bir kabın içine sütü koyun. Üzerine sıvı yağ tuz ekleyin ve yavaş yavaş unu katın. Daha sonra kıvam bulana kadar yavaşça suyu ekleyin. Ele yapışmaz bir kıvam alana kadar yoğurun. Daha sonra tezgahı unlayın ve bütün hamuru küçük parçalara yırın. Daha sonra dinlenmesi için üzerine bir bez örtün ve bekletin. Bu arada harç için kıymayı derin bir kaseye alın. Rondoya soğanı yeşil biberi koyun ve ince bir hal alana kadar çekin. Bunu kıymanın içine ilave edin. Daha sonra domates ve maydanozu da aynı şekilde çekin ve onu da kıymaya ilave edin. Salçasını, tuzunu, sıvı yağ da katıp karıştırın. Pişirme aşamasında kapaklı yanmaz bir tava kullanabilirsiniz. Tavayı ocağa alın ve ilk hamur parçasını tabak büyüklüğünde açın. Üzerine aralıklı bir şekilde elinizle iç harcı yayın. Bunu ısınmış olan tavaya yerleştirin. Ocağı önce yüksek ateşte daha sonra kısık ateşte tutun. Kapağı kapatmadan önce üzerine ıslak bir bez kapatın. Altı kızarınca alabilirsiniz. Diğer tüm parçalara aynı işlemi yapın. Afiyet olsun. ",style: TextStyle(fontSize: 12),),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
