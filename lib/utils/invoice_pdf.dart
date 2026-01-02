import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:vegiffyy_vendor/models/Booking/booking_model.dart';
import 'package:vegiffyy_vendor/models/order.dart';
import 'package:vegiffyy_vendor/utils/invoice_html_builder.dart';

/// Converts BookingModel → Order → HTML → PDF
Future<void> generateInvoicePdf(BookingModel booking) async {
  /// 🔁 Map BookingModel → Order (IMPORTANT)
  final order = Order.fromBooking(booking);

  final html = buildInvoiceHtml(order);

  await Printing.convertHtml(
    html: html,
    format: PdfPageFormat.a4,
  );
}
