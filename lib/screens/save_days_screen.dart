import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controller/predictions_controller.dart';
import '../generated/l10n.dart';
import '../models/prediction.dart';
import 'menu_screen.dart';


DateTime select=DateTime.now();
int selectDays=0;
bool loadData=false;
int selectMonth=1;
DateTime start=DateTime.now();
DateTime end=DateTime.now();
PredictionsController _predictionsController=PredictionsController();


class SaveDaysScreen extends StatefulWidget {
  const SaveDaysScreen({Key key}) : super(key: key);

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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.arrow_back_rounded,color: Colors.grey,),
            ),
          ),
          onPressed: (){
            Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          },
        ),
        title: Text(S.of(context).menu_save_days,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: Column(
            children: [
              Visibility(
                visible: loadData,
                child: Column(
                  children: const [
                    LinearProgressIndicator(),
                    SizedBox(height: 12,)
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: (date){
                    debugPrint('select startDate ${date.value.startDate}');
                    debugPrint('select endDate ${date.value.endDate}');
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${S.of(context).print_select_days} $selectDays',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: ElevatedButton(
                      onPressed: () async{
                        setState(() {
                          loadData=true;
                        });
                        final List<Predictions> list= await _predictionsController.getPredictionsByRange(start,end);
                        await createPdf(list);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Align(
                              child: Text(
                                S.of(context).print_save_pdf,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                    margin: const EdgeInsets.only(top: 12),
                    child: ElevatedButton(
                      onPressed: () async{
                        setState(() {
                          loadData=true;
                        });
                        final List<Predictions> list= await _predictionsController.getPredictionsByRange(start,end);
                        await printPredictions(list);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: const BorderSide(width: 2.0, color: Colors.blue),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Align(
                              child: Text(
                                S.of(context).print_print,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
    String table='';
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
    final htmlContent =
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
      $table
    </table>
  </body>
</html>
""";


    setState(() {
      loadData=false;
    });
  }
  Future<void> printPredictions(List<Predictions> list) async{
    String table='';
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
    final htmlContent =
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
      $table
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
        onLayout: (PdfPageFormat format) async =>  Printing.convertHtml(
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
