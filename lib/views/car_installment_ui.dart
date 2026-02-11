import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CarInstallmentUi extends StatefulWidget {
  const CarInstallmentUi({super.key});

  @override
  State<CarInstallmentUi> createState() => _CarInstallmentUiState();
}

class _CarInstallmentUiState extends State<CarInstallmentUi> {
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController interestCtrl = TextEditingController();

  int downPercent = 10;
  int periodMonth = 24;
  double installmentValue = 0.0;

  final NumberFormat moneyFormat = NumberFormat('#,##0.00');

  void calculate() {
    if (priceCtrl.text.trim().isEmpty) {
      _showError('กรุณาป้อนราคารถ');
      return;
    }

    if (interestCtrl.text.trim().isEmpty) {
      _showError('กรุณาป้อนอัตราดอกเบี้ย');
      return;
    }

    double price =
        double.tryParse(priceCtrl.text.replaceAll(',', '').trim()) ?? -1;
    double interest =
        double.tryParse(interestCtrl.text.replaceAll(',', '').trim()) ?? -1;

    if (price <= 0) {
      _showError('ราคารถต้องมากกว่า 0');
      return;
    }

    if (interest < 0) {
      _showError('อัตราดอกเบี้ยไม่ถูกต้อง');
      return;
    }

    double financeAmount = price - (price * downPercent / 100);
    double totalInterest =
        financeAmount * (interest / 100) * (periodMonth / 12);
    double monthly = (financeAmount + totalInterest) / periodMonth;

    setState(() {
      installmentValue = monthly;
    });
  }

  void resetForm() {
    setState(() {
      priceCtrl.clear();
      interestCtrl.clear();
      downPercent = 10;
      periodMonth = 24;
      installmentValue = 0.0;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    priceCtrl.dispose();
    interestCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CI Calculator',
          style: GoogleFonts.itim(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'คำนวณค่างวดรถ',
                style: GoogleFonts.itim(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/images/car.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('ราคารถ (บาท)'),
            const SizedBox(height: 6),
            TextField(
              controller: priceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 16),
            const Text('จำนวนเงินดาวน์ (%)'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [10, 20, 30, 40, 50].map((value) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: value,
                      groupValue: downPercent,
                      onChanged: (v) =>
                          setState(() => downPercent = v ?? downPercent),
                    ),
                    Text('$value'),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('ระยะเวลาผ่อน (เดือน)'),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: periodMonth,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [24, 36, 48, 60, 72]
                  .map((m) =>
                      DropdownMenuItem(value: m, child: Text('$m เดือน')))
                  .toList(),
              onChanged: (v) => setState(() => periodMonth = v ?? 24),
            ),
            const SizedBox(height: 16),
            const Text('อัตราดอกเบี้ย (%/ปี)'),
            const SizedBox(height: 6),
            TextField(
              controller: interestCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: calculate,
                    child: Text(
                      'คำนวณ',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: resetForm,
                    child: Text(
                      'ยกเลิก',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple),
              ),
              child: Column(
                children: [
                  Text(
                    'ค่างวดรถต่อเดือนเป็นเงิน',
                    style: GoogleFonts.itim(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    moneyFormat.format(installmentValue),
                    style: GoogleFonts.itim(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'บาทต่อเดือน',
                    style: GoogleFonts.itim(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
