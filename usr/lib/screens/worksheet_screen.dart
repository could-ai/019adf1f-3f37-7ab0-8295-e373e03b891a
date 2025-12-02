import 'package:flutter/material.dart';
import '../models/fmea_item.dart';

class WorksheetScreen extends StatefulWidget {
  final List<FmeaItem> items;
  final Function(FmeaItem) onAddItem;
  final Function(String) onDeleteItem;

  const WorksheetScreen({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onDeleteItem,
  });

  @override
  State<WorksheetScreen> createState() => _WorksheetScreenState();
}

class _WorksheetScreenState extends State<WorksheetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('هنوز موردی ثبت نشده است'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('افزودن مورد جدید'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
                  columns: const [
                    DataColumn(label: Text('فرآیند', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('حالت خرابی', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('اثر', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('S', tooltip: 'شدت (Severity)')),
                    DataColumn(label: Text('O', tooltip: 'وقوع (Occurrence)')),
                    DataColumn(label: Text('D', tooltip: 'تشخیص (Detection)')),
                    DataColumn(label: Text('RPN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                    DataColumn(label: Text('اقدام پیشنهادی', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('عملیات')),
                  ],
                  rows: widget.items.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item.processName)),
                      DataCell(Text(item.failureMode)),
                      DataCell(Text(item.failureEffect)),
                      DataCell(Text(item.severity.toString())),
                      DataCell(Text(item.occurrence.toString())),
                      DataCell(Text(item.detection.toString())),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRpnColor(item.rpn).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _getRpnColor(item.rpn)),
                          ),
                          child: Text(
                            item.rpn.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getRpnColor(item.rpn),
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(item.recommendedAction)),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => widget.onDeleteItem(item.id),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getRpnColor(int rpn) {
    if (rpn > 300) return Colors.red;
    if (rpn > 100) return Colors.orange;
    return Colors.green;
  }

  void _showAddDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String process = '';
    String mode = '';
    String effect = '';
    int s = 5;
    int o = 5;
    int d = 5;
    String action = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('افزودن مورد جدید FMEA'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'نام فرآیند / قطعه', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'الزامی' : null,
                  onSaved: (v) => process = v!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'حالت خرابی (Failure Mode)', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'الزامی' : null,
                  onSaved: (v) => mode = v!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'اثر خرابی (Effect)', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'الزامی' : null,
                  onSaved: (v) => effect = v!,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: s,
                        decoration: const InputDecoration(labelText: 'شدت (S)'),
                        items: List.generate(10, (i) => i + 1)
                            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                            .toList(),
                        onChanged: (v) => s = v!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: o,
                        decoration: const InputDecoration(labelText: 'وقوع (O)'),
                        items: List.generate(10, (i) => i + 1)
                            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                            .toList(),
                        onChanged: (v) => o = v!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: d,
                        decoration: const InputDecoration(labelText: 'تشخیص (D)'),
                        items: List.generate(10, (i) => i + 1)
                            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                            .toList(),
                        onChanged: (v) => d = v!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'اقدام پیشنهادی', border: OutlineInputBorder()),
                  onSaved: (v) => action = v ?? '',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                widget.onAddItem(FmeaItem(
                  id: DateTime.now().toIso8601String(),
                  processName: process,
                  failureMode: mode,
                  failureEffect: effect,
                  severity: s,
                  occurrence: o,
                  detection: d,
                  recommendedAction: action,
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('ثبت'),
          ),
        ],
      ),
    );
  }
}
