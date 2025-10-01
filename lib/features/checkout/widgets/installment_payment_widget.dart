import 'package:flutter/material.dart';

class InstallmentPaymentWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? schedule;
  final double? totalAmount;
  final double? perMonthAmount;
  final int? period;
  final bool isLoading;
  final Function(int)? onPeriodSelected;

  const InstallmentPaymentWidget({
    Key? key,
    required this.schedule,
    required this.totalAmount,
    required this.perMonthAmount,
    required this.period,
    required this.isLoading,
    this.onPeriodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (schedule == null || schedule!.isEmpty) {
      return const Center(child: Text('Nenhuma opção de parcelamento disponível.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pagamento a Prazo', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text('Total: MZN ${totalAmount?.toStringAsFixed(2) ?? '-'}'),
        Text('Por mês: MZN ${perMonthAmount?.toStringAsFixed(2) ?? '-'}'),
        Text('Período: $period meses'),
        const SizedBox(height: 16),
        Text('Cronograma de Parcelas:', style: Theme.of(context).textTheme.titleMedium),
        ...schedule!.map((parcel) => Card(
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
        const SizedBox(height: 16),
        if (onPeriodSelected != null)
          ElevatedButton(
            onPressed: () => onPeriodSelected!(period ?? 1),
            child: const Text('Selecionar este período'),
          ),
      ],
    );
  }
}
