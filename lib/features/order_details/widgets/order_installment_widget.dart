import 'package:flutter/material.dart';
import 'package:cobes_marketplace/features/order_details/domain/models/installment_model.dart';
import 'package:cobes_marketplace/utill/custom_themes.dart';
import 'package:cobes_marketplace/utill/dimensions.dart';

class OrderInstallmentWidget extends StatelessWidget {
  final OrderInstallmentDetailsModel? installmentDetails;

  const OrderInstallmentWidget({
    super.key,
    required this.installmentDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (installmentDetails == null || 
        installmentDetails!.installmentSchedule == null || 
        installmentDetails!.installmentSchedule!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).hintColor.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          Row(
            children: [
              Icon(
                Icons.payment,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                'Detalhes do Parcelamento',
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Informações gerais do parcelamento
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  'Método de Pagamento:',
                  _formatPaymentMethod(installmentDetails!.paymentMethod),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                _buildInfoRow(
                  context,
                  'Número de Parcelas:',
                  '${installmentDetails!.paymentPeriod}x',
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                _buildInfoRow(
                  context,
                  'Valor da Parcela:',
                  'MT ${installmentDetails!.installmentValue?.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Lista de parcelas
          Text(
            'Cronograma de Pagamentos:',
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ...installmentDetails!.installmentSchedule!.map((installment) => 
            _buildInstallmentCard(context, installment)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        Text(
          value,
          style: titilliumSemiBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildInstallmentCard(BuildContext context, InstallmentModel installment) {
    Color statusColor = _getStatusColor(context, installment.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Número da parcela
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '${installment.installmentNumber}',
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: statusColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          // Informações da parcela
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MT ${installment.amountFormatted}',
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        installment.statusText ?? '',
                        style: titilliumRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(
                  'Vencimento: ${installment.dueDateFormatted}',
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPaymentMethod(String? method) {
    switch (method?.toLowerCase()) {
      case 'pagamento_a_prazo':
        return 'Pagamento a Prazo';
      case 'credit_card':
        return 'Cartão de Crédito';
      case 'debit_card':
        return 'Cartão de Débito';
      default:
        return method ?? 'N/A';
    }
  }

  Color _getStatusColor(BuildContext context, String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}