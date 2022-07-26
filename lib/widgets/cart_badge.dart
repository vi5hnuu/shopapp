import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;
  const Badge({required this.child,required this.value,this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 32,right: 10),
            child: child
        ),
        Positioned(
          right: 18,
          top: 8,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: color ?? Theme.of(context).colorScheme.secondary
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
              maxHeight: 16,
            ),
            child: Text(
                value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        )
      ],
    );
  }
}
