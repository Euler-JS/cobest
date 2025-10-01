import 'package:flutter/material.dart';

class InstallmentSuccessDialog extends StatelessWidget {
  final String orderId;
  final int period;
  final double totalAmount;
  final double perMonthAmount;
  final List<Map<String, dynamic>> schedule;

  const InstallmentSuccessDialog({
    Key? key,
    required this.orderId,
    required this.period,
    required this.totalAmount,
    required this.perMonthAmount,
    required this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pagamento a Prazo Confirmado!', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text('Pedido: $orderId'),
              Text('Período: $period meses'),
              Text('Valor total: MZN ${totalAmount.toStringAsFixed(2)}'),
              Text('Valor por mês: MZN ${perMonthAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              Text('Cronograma de Parcelas:', style: Theme.of(context).textTheme.titleMedium),
              ...schedule.map((parcel) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text('Parcela ${parcel['month'] ?? ''}'),
                  subtitle: Text('Vencimento: ${parcel['due_date'] ?? ''}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Valor: MZN ${parcel['amount'] ?? '-'}'),
                      Text('Status: ${parcel['status'] ?? 'pendente'}'),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('OK, Voltar para Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
