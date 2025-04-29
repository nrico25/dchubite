import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tadchubite/widget/color.dart';

class CardFinance extends StatelessWidget {
  final String title;
  final double penjualanKotor;
  final double modalAwal;
  final double penjualanBersih;
  final int produkTerjual;

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ', decimalDigits: 0);

  CardFinance({
    Key? key,
    required this.title,
    required this.penjualanKotor,
    required this.modalAwal,
    required this.penjualanBersih,
    required this.produkTerjual,
    required List items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Omset $title",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 12),
          Divider(height: 1, color: Color(0xFFE2E8F0)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(
                  "Penjualan Kotor", currencyFormatter.format(penjualanKotor)),
              _buildItem("Modal Awal", currencyFormatter.format(modalAwal)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem("Produk Terjual", produkTerjual.toString()),
              _buildItem("Penjualan Bersih",
                  currencyFormatter.format(penjualanBersih)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
