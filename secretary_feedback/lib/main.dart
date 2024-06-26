import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secretary feedback',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Secretary feedback'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: const CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Center(
          child: Text(
            'Welcome to information page for XXX mess',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Vendor's Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/profile_icon.jpg',
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Name:", "John"),
                      _buildInfoRow("Email:", "john@example.com"),
                      _buildInfoRow("Phone:", "+919234567890"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Student's Feedback",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                child: Table(
                  border: TableBorder.all(),
                  children: [
                    _buildTableRow("Roll No.", "Date", "Feedback",
                        isFirstRow: true),
                    _buildTableRow("", "", ""),
                    _buildTableRow("", "", ""),
                    _buildTableRow("", "", ""),
                    _buildTableRow("", "", ""),
                    _buildTableRow("", "", ""),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2, String col3,
      {bool isFirstRow = false}) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 20), // Adjust the vertical padding here
            child: SizedBox(
              width: 20, // Decrease width of the first column
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isFirstRow
                    ? Text(col1)
                    : SizedBox(), // Use SizedBox for spacing in non-first rows
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 20), // Adjust the vertical padding here
            child: SizedBox(
              width: 100, // Decrease width of the second column
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isFirstRow
                    ? Text(col2)
                    : SizedBox(), // Use SizedBox for spacing in non-first rows
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 20), // Adjust the vertical padding here
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isFirstRow
                  ? Text(col3)
                  : SizedBox(), // Use SizedBox for spacing in non-first rows
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
