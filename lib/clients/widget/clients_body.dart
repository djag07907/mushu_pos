import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:html' as html;

class ClientsBody extends StatefulWidget {
  const ClientsBody({super.key});

  @override
  State<ClientsBody> createState() => _ClientsBodyState();
}

class _ClientsBodyState extends State<ClientsBody> {
  final List<Map<String, dynamic>> _clients = List.generate(20, (index) {
    return {
      'number': index + 1,
      'client': 'Client name $index',
      'documentType': 'Type ${index % 3 + 1}',
      'documentNumber': 'Document Number $index',
      'phoneNumber': 'Phone Number $index',
      'email': 'Email $index',
      'address': 'Address $index',
      'status': index % 2 == 0 ? 'Active' : 'Inactive',
    };
  });

  String _filter = '';
  int _rowsPerPage = 5;
  int _currentPage = 0;

  List<Map<String, dynamic>> get _filteredClients {
    return _clients
        .where((client) => client['client']
            .toString()
            .toLowerCase()
            .contains(_filter.toLowerCase()))
        .toList();
  }

  void _generatePdfReport() async {
    final pdf = pw.Document();
    final ByteData bytes =
        await rootBundle.load('assets/images/point-of-sale.png');
    final Uint8List logo = bytes.buffer.asUint8List();
    final ByteData regularFontData =
        await rootBundle.load("assets/fonts/Roboto/Roboto-Regular.ttf");
    final ByteData boldFontData =
        await rootBundle.load("assets/fonts/Roboto/Roboto-Bold.ttf");
    final pw.Font regularFont = pw.Font.ttf(regularFontData);
    final pw.Font boldFont = pw.Font.ttf(boldFontData);
    const int maxRowsPerPage = 5;
    String formattedDate =
        DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    print("Filtered Clients: $_filteredClients");

    for (int i = 0; i < _filteredClients.length; i += maxRowsPerPage) {
      final chunk = _filteredClients.sublist(
          i,
          (i + maxRowsPerPage < _filteredClients.length)
              ? i + maxRowsPerPage
              : _filteredClients.length);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(pw.MemoryImage(logo), width: 100, height: 100),
                pw.SizedBox(height: 20),
                pw.Text('Clients Report',
                    style: pw.TextStyle(fontSize: 24, font: boldFont)),
                pw.SizedBox(height: 20),
                pw.Text('Generated on: $formattedDate',
                    style: pw.TextStyle(fontSize: 12, font: regularFont)),
                pw.SizedBox(height: 20),
                pw.Text('User: Admin',
                    style: pw.TextStyle(fontSize: 18, font: regularFont)),
                pw.SizedBox(height: 20),
                pw.Text('Total Clients: ${_filteredClients.length}',
                    style: pw.TextStyle(fontSize: 18, font: regularFont)),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: const {
                    0: pw.FixedColumnWidth(50.0),
                    1: pw.FixedColumnWidth(100.0),
                    2: pw.FixedColumnWidth(100.0),
                    3: pw.FixedColumnWidth(100.0),
                    4: pw.FixedColumnWidth(100.0),
                    5: pw.FixedColumnWidth(100.0),
                    6: pw.FixedColumnWidth(100.0),
                    7: pw.FixedColumnWidth(50.0),
                    8: pw.FixedColumnWidth(50.0),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Client Name',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: boldFont,
                                  fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Document Type',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: boldFont,
                                  fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Document Number',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: boldFont,
                                  fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Phone Number',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: boldFont,
                                  fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Email',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: boldFont,
                                  fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Address',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: boldFont,
                                  fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Status',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: boldFont,
                                  fontSize: 10)),
                        ),
                      ],
                    ),
                    ...chunk.map((client) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(client['client'] ?? 'N/A',
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(client['documentType'] ?? 'N/A',
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(client['documentNumber'] ?? 'N/A',
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(client['phoneNumber'] ?? 'N/A',
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(client['email'] ?? 'N/A',
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(client['address'] ?? 'N/A',
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 9)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(client['status'] ?? 'N/A',
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 9)),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    final Uint8List pdfData = await pdf.save();
    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'clients_report.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void _showAddClientDialog() {
    String clientName = '';
    String documentType = 'Type 1';
    String documentNumber = '';
    String phoneNumber = '';
    String email = '';
    String address = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Register Client'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Client Name'),
                onChanged: (value) {
                  clientName = value;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Document Type'),
                value: documentType,
                items: const [
                  DropdownMenuItem(value: 'Type 1', child: Text('Type 1')),
                  DropdownMenuItem(value: 'Type 2', child: Text('Type 2')),
                  DropdownMenuItem(value: 'Type 3', child: Text('Type 3')),
                ],
                onChanged: (value) {
                  documentType = value!;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Document Number'),
                onChanged: (value) {
                  documentNumber = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) {
                  address = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (clientName.isNotEmpty &&
                    documentType.isNotEmpty &&
                    documentNumber.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty &&
                    address.isNotEmpty) {
                  setState(() {
                    _clients.add({
                      'number': _clients.length + 1,
                      'client': clientName,
                      'documentType': documentType,
                      'documentNumber': documentNumber,
                      'phoneNumber': phoneNumber,
                      'email': email,
                      'address': address,
                      'status': 'Active',
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditClientDialog(int index) {
    String clientName = _clients[index]['client'];
    String documentType = _clients[index]['documentType'];
    String documentNumber = _clients[index]['documentNumber'];
    String phoneNumber = _clients[index]['phoneNumber'];
    String email = _clients[index]['email'];
    String address = _clients[index]['address'];
    String clientStatus = _clients[index]['status'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Client'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Client Name'),
                controller: TextEditingController(text: clientName),
                onChanged: (value) {
                  clientName = value;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Document Type'),
                value: documentType,
                items: const [
                  DropdownMenuItem(value: 'Type 1', child: Text('Type 1')),
                  DropdownMenuItem(value: 'Type 2', child: Text('Type 2')),
                  DropdownMenuItem(value: 'Type 3', child: Text('Type 3')),
                ],
                onChanged: (value) {
                  documentType = value!;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Document Number'),
                controller: TextEditingController(text: documentNumber),
                onChanged: (value) {
                  documentNumber = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                controller: TextEditingController(text: phoneNumber),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: TextEditingController(text: email),
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Address'),
                controller: TextEditingController(text: address),
                onChanged: (value) {
                  address = value;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                value: clientStatus,
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                ],
                onChanged: (value) {
                  clientStatus = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _clients[index]['client'] = clientName;
                  _clients[index]['documentType'] = documentType;
                  _clients[index]['documentNumber'] = documentNumber;
                  _clients[index]['phoneNumber'] = phoneNumber;
                  _clients[index]['email'] = email;
                  _clients[index]['address'] = address;
                  _clients[index]['status'] = clientStatus;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Clients List', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _showAddClientDialog,
                  child: const Text('Add Client'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _generatePdfReport,
                  child: const Text('PDF Report'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Export Excel functionality
                  },
                  child: const Text('Excel Report'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Filter by client',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  header: const Text('Clients List'),
                  rowsPerPage: _rowsPerPage,
                  onPageChanged: (pageIndex) {
                    setState(() {
                      _currentPage = pageIndex;
                    });
                  },
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Client')),
                    DataColumn(label: Text('Document Type')),
                    DataColumn(label: Text('Document Number')),
                    DataColumn(label: Text('Phone Number')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Edit')),
                    DataColumn(label: Text('Change Status')),
                  ],
                  source: _ClientsDataSource(
                    data: _filteredClients,
                    onEdit: (index) => _showEditClientDialog(index),
                    onChangeStatus: (index) {
                      setState(() {
                        _filteredClients[index]['status'] =
                            _filteredClients[index]['status'] == 'Active'
                                ? 'Inactive'
                                : 'Active';
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientsDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final Function(int index) onEdit;
  final Function(int index) onChangeStatus;

  _ClientsDataSource({
    required this.data,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final client = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(client['number'].toString())),
        DataCell(Text(client['client'] ?? 'N/A')),
        DataCell(Text(client['documentType'] ?? 'N/A')),
        DataCell(Text(client['documentNumber'] ?? 'N/A')),
        DataCell(Text(client['phoneNumber'] ?? 'N/A')),
        DataCell(Text(client['email'] ?? 'N/A')),
        DataCell(Text(client['address'] ?? 'N/A')),
        DataCell(
          Text(
            client['status'],
            style: TextStyle(
              color: client['status'] == 'Active' ? Colors.green : Colors.red,
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(index),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(
              client['status'] == 'Active' ? Icons.toggle_on : Icons.toggle_off,
              color: client['status'] == 'Active' ? Colors.green : Colors.red,
            ),
            onPressed: () => onChangeStatus(index),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;
}
