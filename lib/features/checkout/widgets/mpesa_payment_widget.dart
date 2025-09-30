import 'package:flutter/material.dart';
import 'package:cobes_marketplace/localization/language_constrants.dart';
import 'package:cobes_marketplace/utill/custom_themes.dart';
import 'package:cobes_marketplace/utill/dimensions.dart';

class MpesaPaymentWidget extends StatefulWidget {
  final void Function(String phone)? onConfirm;
  const MpesaPaymentWidget({super.key, this.onConfirm});

  @override
  State<MpesaPaymentWidget> createState() => _MpesaPaymentWidgetState();
}

class _MpesaPaymentWidgetState extends State<MpesaPaymentWidget> {
  final TextEditingController _phoneController = TextEditingController();
  String? _error;

  final RegExp _mpesaRegex = RegExp(r'^(\+?258)?(84|85|86)\d{7}$|^(84|85|86)\d{7}$');

  void _validateAndConfirm() {
    final phone = _phoneController.text.trim();
    if (!_mpesaRegex.hasMatch(phone)) {
      setState(() {
        _error = getTranslated('invalid_mpesa_phone', context) ?? 'Número de telefone inválido';
      });
      return;
    }
    setState(() { _error = null; });
    widget.onConfirm?.call(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('enter_mpesa_phone', context) ?? 'Digite o número M-Pesa', style: textMedium),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '+258841234567',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAndConfirm,
              child: Text(getTranslated('confirm', context) ?? 'Confirmar'),
            ),
          ),
        ],
      ),
    );
  }
}
