import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {

  
// Helper method to build data rows (add this outside the build method)
DataRow buildDataRow({
  required String id,
  required String customer,
  required String date,
  required String status,
  required String amount,
  required Color statusColor,
}) {
  return DataRow(
    cells: [
      DataCell(
        Text(
          id,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      DataCell(
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Text(
                customer[0],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              customer,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      DataCell(
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              date,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ),
      DataCell(
        Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ),
      DataCell(
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size(0, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
          ),
          child: Text(
            'View',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    ],
  );
}
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Sales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: Icon(Icons.filter_list, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 12),
          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 48,
              dataRowHeight: 56,
              horizontalMargin: 12,
              columnSpacing: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              headingRowColor: MaterialStateProperty.resolveWith(
                (states) => Colors.blue[50],
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'ID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Customer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
              rows: [
                buildDataRow(
                  id: '001',
                  customer: 'John Doe',
                  date: '2024-06-10',
                  status: 'Completed',
                  amount: '\$100',
                  statusColor: Colors.green,
                ),
                buildDataRow(
                  id: '002',
                  customer: 'Jane Smith',
                  date: '2024-06-09',
                  status: 'Pending',
                  amount: '\$75',
                  statusColor: Colors.orange,
                ),
                buildDataRow(
                  id: '003',
                  customer: 'Mike Johnson',
                  date: '2024-06-08',
                  status: 'Completed',
                  amount: '\$150',
                  statusColor: Colors.green,
                ),
              ],
            ),
          ),
          // Footer
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing 5 entries',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 20),
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                  Text(
                    '1 / 3',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 20),
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
 }
}