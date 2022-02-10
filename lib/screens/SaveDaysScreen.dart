import 'package:astrology_app/Screens/MenuScreen.dart';
import 'package:astrology_app/controller/predictions_controller.dart';
import 'package:astrology_app/models/prediction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';


DateTime select=DateTime.now();
int selectDays=0;
bool loadData=false;
int selectMonth=1;
DateTime start=DateTime.now();
DateTime end=DateTime.now();
PredictionsController _predictionsController=PredictionsController();


class SaveDaysScreen extends StatefulWidget {
  @override
  _SaveDaysState createState() => _SaveDaysState();
}
class _SaveDaysState extends State<SaveDaysScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        leading: IconButton(
          icon: Container(
            child: Center(
              child: Icon(Icons.arrow_back_rounded,color: Colors.grey,),
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
        ),
        title: Text(S.of(context).menu_save_days,textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: Column(
            children: [
              Visibility(
                child: Column(
                  children: [
                    LinearProgressIndicator(),
                    SizedBox(height: 12,)
                  ],
                ),
                visible: loadData,
              ),
              Container(
                height: 300,
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: (date){
                    debugPrint("select startDate "+date.value.startDate.toString());
                    debugPrint("select endDate "+date.value.endDate.toString());
                    start=date.value.startDate;
                    end=date.value.endDate;
                    if(date.value.startDate!=null&&date.value.endDate!=null){
                      selectDays=date.value.endDate.difference(date.value.startDate).inDays;
                    }
                    else{
                      selectDays=0;
                      selectMonth=1;
                    }
                    selectDays+=1;
                    setState(() {

                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200]
                ),
                height: 2,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Align(
                  child: Text(
                    S.of(context).print_select_days+" "+selectDays.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: ElevatedButton(
                      onPressed: () async{
                        setState(() {
                          loadData=true;
                        });
                        List<Predictions> list= await _predictionsController.getPredictionsByRange(start,end);
                        await createPdf(list);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).print_save_pdf,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: ElevatedButton(
                      onPressed: () async{
                        setState(() {
                          loadData=true;
                        });
                        List<Predictions> list= await _predictionsController.getPredictionsByRange(start,end);
                        PrintPredictions(list);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(width: 2.0, color: Colors.blue),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).print_print,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  color: Colors.blue
                                ),

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<void> createPdf(List<Predictions> list) async{
    String table="";
    list.forEach((item) {
      table+="""
      <tr>
        <th>${DateFormat('dd.MM.yyyy').format(item.datePrediction)}</th>
        <th>${DateFormat('HH:mm').format(item.datePrediction)}</th>
        <th>${item.type}</th>
        <th>${item.title}</th>
        <th>${item.message}</th>
      </tr>
      """;
    });
    var htmlContent =
    """
<!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
  }
  th, td, p {
    padding: 5px;
    text-align: left;
  }
  </style>
</head>
  <body>
    <h2>Ваши предсказания с ${DateFormat('dd.MM.yyyy').format(start)} по ${DateFormat('dd.MM.yyyy').format(end)}</h2>
    <table style="width:100%">
      <caption></caption>
      <tr>
        <th>Дата</th>
        <th>Время</th>
        <th>Категория</th>
        <th>Заголовок</th>
        <th>Сообщение</th>
      </tr>
      ${table}
    </table>
  </body>
</html>
""";
    var dir = await getExternalStorageDirectory();
    var targetFileName = "example_pdf_file";


    setState(() {
      loadData=false;
    });
  }
  Future<void> PrintPredictions(List<Predictions> list) async{
    String table="";
    list.forEach((item) {
      table+="""
      <tr>
        <th>${DateFormat('dd.MM.yyyy').format(item.datePrediction)}</th>
        <th>${DateFormat('HH:mm').format(item.datePrediction)}</th>
        <th>${item.type}</th>
        <th>${item.title}</th>
        <th>${item.message}</th>
      </tr>
      """;
    });
    var htmlContent =
    """
<!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
  }
  th, td, p {
    padding: 5px;
    text-align: left;
  }
  </style>
</head>
  <body>
    <h2>Ваши предсказания с ${DateFormat('dd.MM.yyyy').format(start)} по ${DateFormat('dd.MM.yyyy').format(end)}</h2>
    <table style="width:100%">
      <caption></caption>
      <tr>
        <th>Дата</th>
        <th>Время</th>
        <th>Категория</th>
        <th>Заголовок</th>
        <th>Сообщение</th>
      </tr>
      ${table}
    </table>
  </body>
</html>
""";
    /*
    var dir = await getExternalStorageDirectory();
    var targetFileName = "example_pdf_file";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, dir.path, targetFileName);
    OpenFile.open(generatedPdfFile.path);

     */
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
          format: format,
          html: htmlContent,
        ));
    setState(() {
      loadData=false;
    });
  }
  @override
  void initState() {
    super.initState();
  }

}
