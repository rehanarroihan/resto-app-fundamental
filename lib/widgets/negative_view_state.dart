import 'package:flutter/material.dart';

class NegativeViewState extends StatelessWidget {
  final String assets;
  final String title;
  final String description;
  final String? actionButtonText;
  final Function? onActionButtonTap;

  const NegativeViewState({
    Key? key,
    required this.assets,
    required this.title,
    required this.description,
    this.actionButtonText,
    this.onActionButtonTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 16,
            bottom: 8
          ),
          child: Image.asset(assets)
        ),

        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24
          ),
        ),

        const SizedBox(height: 4),

        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 24),

        (actionButtonText != null && actionButtonText!.isNotEmpty)
            ? ElevatedButton(
                onPressed: () {
                  if (onActionButtonTap != null) {
                    onActionButtonTap!();
                  }
                },
                child: Text(actionButtonText!),
              )
            : const SizedBox()
      ],
    );
  }
}
