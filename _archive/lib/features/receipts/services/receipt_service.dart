import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class ReceiptService {
  static final ReceiptService _instance = ReceiptService._internal();
  factory ReceiptService() => _instance;
  ReceiptService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Generate receipt for booking
  Future<String> generateReceipt({
    required String bookingId,
    bool isPdf = true,
  }) async {
    try {
      final response = await _supabase.rpc('generate_receipt', params: {
        'booking_id_param': bookingId,
        'format': isPdf ? 'pdf' : 'html',
      });

      final receiptUrl = response as String;

      // Save receipt URL to database
      await _supabase
          .from('bookings')
          .update({'receipt_url': receiptUrl})
          .eq('id', bookingId);

      return receiptUrl;
    } catch (e) {
      throw Exception('Failed to generate receipt: $e');
    }
  }

  // Download receipt
  Future<Uint8List> downloadReceipt(String receiptUrl) async {
    try {
      final response = await _supabase.storage
          .from('receipts')
          .download(receiptUrl.replaceAll('receipts/', ''));

      return response;
    } catch (e) {
      throw Exception('Failed to download receipt: $e');
    }
  }

  // Email receipt
  Future<void> emailReceipt({
    required String bookingId,
    required String email,
  }) async {
    try {
      await _supabase.functions.invoke('send-receipt-email', body: {
        'booking_id': bookingId,
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to email receipt: $e');
    }
  }

  // Get receipt for booking
  Future<String?> getReceiptUrl(String bookingId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select('receipt_url')
          .eq('id', bookingId)
          .single();

      return response['receipt_url'] as String?;
    } catch (e) {
      return null;
    }
  }

  // Generate receipt data (for custom formatting)
  Future<Map<String, dynamic>> getReceiptData(String bookingId) async {
    try {
      final response = await _supabase.rpc('get_receipt_data', params: {
        'booking_id_param': bookingId,
      });

      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      throw Exception('Failed to get receipt data: $e');
    }
  }

  // Create receipt HTML (client-side)
  String createReceiptHtml({
    required Map<String, dynamic> receiptData,
  }) {
    final booking = receiptData['booking'] as Map<String, dynamic>;
    final venue = receiptData['venue'] as Map<String, dynamic>;
    final user = receiptData['user'] as Map<String, dynamic>;
    final lineItems = receiptData['line_items'] as List;

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Receipt - ${booking['id']}</title>
  <style>
    body {
      font-family: 'Helvetica', 'Arial', sans-serif;
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
      color: #333;
    }
    .header {
      text-align: center;
      border-bottom: 2px solid #FF6B00;
      padding-bottom: 20px;
      margin-bottom: 30px;
    }
    .logo {
      font-size: 32px;
      font-weight: bold;
      color: #FF6B00;
    }
    .receipt-info {
      display: flex;
      justify-content: space-between;
      margin-bottom: 30px;
    }
    .receipt-info div {
      flex: 1;
    }
    .line-items {
      margin: 30px 0;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th {
      text-align: left;
      border-bottom: 2px solid #ddd;
      padding: 10px;
      background: #f5f5f5;
    }
    td {
      padding: 10px;
      border-bottom: 1px solid #eee;
    }
    .total-row {
      font-weight: bold;
      font-size: 18px;
      border-top: 2px solid #333;
    }
    .footer {
      margin-top: 50px;
      text-align: center;
      color: #999;
      font-size: 12px;
    }
  </style>
</head>
<body>
  <div class="header">
    <div class="logo">BottlesUp</div>
    <p>Digital Receipt</p>
  </div>

  <div class="receipt-info">
    <div>
      <strong>Receipt #:</strong> ${booking['id']}<br>
      <strong>Date:</strong> ${booking['created_at']}<br>
      <strong>Status:</strong> ${booking['status']}
    </div>
    <div>
      <strong>Customer:</strong><br>
      ${user['full_name']}<br>
      ${user['email']}
    </div>
    <div>
      <strong>Venue:</strong><br>
      ${venue['name']}<br>
      ${venue['address']}
    </div>
  </div>

  <div class="line-items">
    <table>
      <thead>
        <tr>
          <th>Description</th>
          <th>Quantity</th>
          <th>Price</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        ${lineItems.map((item) => '''
          <tr>
            <td>${item['description']}</td>
            <td>${item['quantity']}</td>
            <td>\$${item['price']}</td>
            <td>\$${item['total']}</td>
          </tr>
        ''').join()}
        <tr class="total-row">
          <td colspan="3">Total</td>
          <td>\$${booking['total_amount']}</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="footer">
    <p>Thank you for choosing BottlesUp!</p>
    <p>For questions, contact support@bottlesup.app</p>
  </div>
</body>
</html>
    ''';
  }
}
