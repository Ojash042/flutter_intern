import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget{
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const SubjectWiseReport(),
    );
  }
}

class SubjectWiseReport extends StatefulWidget{
  const SubjectWiseReport({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SubjectWiseReportState(); 
  }
}

class ResultBlock extends StatelessWidget{
  final String titleText;
  final String descriptionText;
  final Color gradientColour;
  final Color textColor;
  const ResultBlock({super.key, required this.titleText, required this.descriptionText, required this.gradientColour, required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: (MediaQuery.of(context).size.width - 45) / 3,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, gradientColour]
        )),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(titleText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor), )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(descriptionText, maxLines: 2, textAlign: TextAlign.center, style: TextStyle(color: textColor),),
            )),
        ],
      ),
    );
  }
}


class _SubjectWiseReportState extends State<SubjectWiseReport>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subject Wise Progress Report"),),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Message", style: Theme.of(context).textTheme.labelLarge,),
            const SizedBox(height: 10,),
            Text("You should review your notes and watch the videos more attentively to grasp the concepts in physics thoroughly.", maxLines: null, style: Theme.of(context).textTheme.bodyLarge,),
            const SizedBox(height: 30,),
            SizedBox(
              height: 260,
              child: GridView.count(crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                ResultBlock(titleText: "743", descriptionText: "Questions attempted", gradientColour: Colors.grey[200]!, textColor: Colors.black,),
                ResultBlock(titleText: "498", descriptionText: "Correct Attempts", gradientColour: Colors.green[100]!, textColor: Colors.green[600]!),
                ResultBlock(titleText: "245", descriptionText: "Incorrect Attempts", gradientColour: Colors.red[100]!, textColor: Colors.red[600]!),
                ResultBlock(titleText: "437", descriptionText: "Marks Obtained", gradientColour: Colors.grey[200]!, textColor: Colors.black),
                ResultBlock(titleText: "58.81%", descriptionText: "Percentage Obtained", gradientColour: Colors.green[100]!, textColor: Colors.green[600]!),
                ResultBlock(titleText: "61", descriptionText: "Negative Marking", gradientColour: Colors.red[100]!, textColor: Colors.red[600]!)
              ],
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                backgroundColor: Colors.grey[200],
                collapsedBackgroundColor: Colors.grey[200],
                title: const Row(
                  children: [
                    Text("Mechanics"),
                    Spacer(),
                    Text("60%", style: TextStyle(color: Colors.green),)
                  ],
                ), 
                children: [
                  Container(height: 10, color: Colors.white),
                  Container(
                  color: Colors.grey[200],
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(children: [Text("Correct"), Spacer(), Text("3", style: TextStyle(color: Colors.green),) ],),
                          Row(children: [Text("Incorrect"), Spacer(), Text("1", style: TextStyle(color: Colors.red),),],),
                          Row(children: [Text("Marks Obtained"), Spacer(), Text("2.75")],),
                        ],
                      ),
                    ),
                  ),
                  ],),
            ),
            const SizedBox(height: 15,),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                visualDensity: VisualDensity.comfortable,
                dense: false,
                collapsedBackgroundColor: Colors.grey[200],
                backgroundColor: Colors.grey[200],
                title: const Row(
                  children: [
                    Text("Thermodynamics"),
                    Spacer(),
                    Text("90%", style: TextStyle(color: Colors.green),)
                  ],
                ), 
                children: [
                  Container(height: 10, color: Colors.white,),
                  Container(
                    color: Colors.grey[200]!,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(children: [Text("Correct"), Spacer(), Text("3", style: TextStyle(color: Colors.green),) ],),
                          Row(children: [Text("Incorrect"), Spacer(), Text("1", style: TextStyle(color: Colors.red),),],),
                          Row(children: [Text("Marks Obtained"), Spacer(), Text("2.75")],),
                        ],
                      ),
                    ),
                  ),
                  ],),
            ),
            const SizedBox(height: 15,),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                visualDensity: VisualDensity.comfortable,
                dense: false,
                collapsedBackgroundColor: Colors.grey[200],
                backgroundColor: Colors.grey[200],
                childrenPadding: const EdgeInsets.symmetric(vertical: 8),
                title: Container(
                  color: Colors.grey[200],
                  child: const Row(
                    children: [
                      Text("Electromagnetism"), Spacer(), Text("20%", style: TextStyle(color: Colors.red),)
                    ],
                  ),
                ), 
                children: [
                  Container(height: 10, color: Colors.white,),
                  Container(
                    color: Colors.grey[200],
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(children: [Text("Correct"), Spacer(), Text("9", style: TextStyle(color: Colors.green),) ],),
                          Row(children: [Text("Incorrect"), Spacer(), Text("1", style: TextStyle(color: Colors.red),),],),
                          Row(children: [Text("Marks Obtained"), Spacer(), Text("3.7")],),
                        ],
                      ),
                    ),
                  ),
                  ],),
            ), 
            const SizedBox(height: 15,),
            Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  visualDensity: VisualDensity.comfortable,
                  dense: false,
                  childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  collapsedBackgroundColor: Colors.grey[200],
                  backgroundColor: Colors.grey[200],
                  title: Container(
                    color: Colors.grey[200],
                    child: const Row(
                    children: [Text("Waves and Optics"), Spacer(), Text("70%", style: TextStyle(color: Colors.green),)],),
                  ), 
                children: [
                  Container(color: Colors.white, height: 10,),
                  Container(
                    color: Colors.grey[200],
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [Text("Correct"), Spacer(), Text("3", style: TextStyle(color: Colors.green),) ],),
                          Row(children: [Text("Incorrect"), Spacer(), Text("1", style: TextStyle(color: Colors.red),),],),
                          Row(children: [Text("Marks Obtained"), Spacer(), Text("2.75")],),
                        ],
                      ),
                    ),
                  ),
                  ],),
            ),
            const SizedBox(height: 15,),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child:  ExpansionTile(
                dense: false,
                visualDensity: VisualDensity.comfortable,
                collapsedBackgroundColor: Colors.grey[200]!,
                backgroundColor: Colors.grey[200],
                iconColor: Colors.grey,
                title: Container(
                  color: Colors.grey[200]!,
                  child: const Row(
                    children: [Text("Photons"), Spacer(), Text("80%", style: TextStyle(color: Colors.green),)],
                  ),
                ), 
                children: [
                    Container(height: 10, color: Colors.white,),
                    Container(
                      color: Colors.grey[200],
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Row(children: [Text("Correct"), Spacer(), Text("3", style: TextStyle(color: Colors.green),) ],),
                          Row(children: [Text("Incorrect"), Spacer(), Text("1", style: TextStyle(color: Colors.red),),],),
                          Row(children: [Text("Marks Obtained"), Spacer(), Text("2.75")],),
                          ],
                        ),
                      ),
                    ),
                  ],),
            ),
          const SizedBox(height: 15,),
          Container(
            color: Colors.grey[100],
            child: DottedBorder(
              child: Padding(padding: const EdgeInsets.all(8),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    childrenPadding: const EdgeInsets.symmetric(vertical: 5),
                    backgroundColor: Colors.white,
                    title: Row(children: [
                    const Text("Physics", style: TextStyle(fontWeight: FontWeight.bold),), const Spacer(), 
                  const Text("30", style: TextStyle(fontWeight: FontWeight.bold),), const Text("/50", style: TextStyle(fontWeight: FontWeight.w200),),SizedBox(width: MediaQuery.of(context).size.width * 0.1,) 
                  ,const Text("60%", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)],),
                  children: [
                    // Container(
                    //   color: Colors.grey[200],
                    //   child: Row(Text("Correct")))
                  SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                    child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                        border: TableBorder.all(style: BorderStyle.none),
                          dividerThickness: 0,
                          headingRowColor: MaterialStateProperty.all<Color>(Colors.blueGrey[100]!),
                          columns: const [
                          DataColumn(label: Text("Correct"), ),
                          DataColumn(label: Text("Incorrect")),
                          DataColumn(label: Text("Marks")),
                          DataColumn(label: Text("Percentage")),
                        ], rows:const  [
                          /// Mechanics
                          DataRow(cells: [
                          DataCell(Text("Mechanics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                          DataCell.empty,
                          DataCell.empty,
                          DataCell.empty,
                          ],),
                          DataRow(
                            cells: [
                            DataCell(Text("4")),
                            DataCell(Text("0")),
                            DataCell(Text("4")),
                            DataCell(Text("100%", style: TextStyle(color: Colors.green),)),
                          ]),
                        
                        // Thermodynamics
                        
                        DataRow(
                          cells: [
                          DataCell(Text("Thermodynamics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                          DataCell.empty,
                          DataCell.empty,
                          DataCell.empty,
                          ],),
                          DataRow(cells: [
                            DataCell(Text("3")),
                            DataCell(Text("1")),
                            DataCell(Text("2.75")),
                            DataCell(Text("68.75%", style: TextStyle(color: Colors.green),)),
                          ]),
                        
                          //Electromagnetism
                        
                          DataRow(cells: [
                            DataCell(Text("Electromagnetism", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                            DataCell.empty,
                            DataCell.empty,
                            DataCell.empty,
                          ],),
                          DataRow(cells: [
                            DataCell(Text("4")),
                            DataCell(Text("0")),
                            DataCell(Text("4")),
                            DataCell(Text("100%", style: TextStyle(color: Colors.green),)),
                          ]),
                        
                          // Waves and Optics
                        
                          DataRow(cells: [
                            DataCell(Text("Waves and Optics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                            DataCell.empty,
                            DataCell.empty,
                            DataCell.empty,
                          ],),
                          DataRow(cells: [
                            DataCell(Text("3")),
                            DataCell(Text("1")),
                            DataCell(Text("2.75")),
                            DataCell(Text("68.75", style: TextStyle(color: Colors.green),)),
                          ]),
                        
                          // Modern Physics
                        
                          DataRow(cells: [
                            DataCell(Text("Modern Physics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                            DataCell.empty,
                            DataCell.empty,
                            DataCell.empty,
                          ],),
                          DataRow(cells: [
                            DataCell(Text("3")),
                            DataCell(Text("1")),
                            DataCell(Text("2.75")),
                            DataCell(Text("68.75%", style: TextStyle(color: Colors.green),)),
                          ]),
                        
                          ],
                        
                        ),
                      ),
                    ),
                  ),
                  ],
                  )),
              )
            ),
          ) 
          ],
        ),
      ),),
    ); 
  } 
}
