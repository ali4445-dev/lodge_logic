import 'package:flutter/material.dart';

class StylishInputField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  

  const StylishInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,

  });

  @override
  State<StylishInputField> createState() => _StylishInputFieldState();
}

class _StylishInputFieldState extends State<StylishInputField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: TextField(
        obscureText: widget.isPassword ? _obscure : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          labelText: widget.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          prefixIcon: Icon(widget.icon, color: Colors.blueAccent),

          // Password Eye Button
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : null,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          // Slight shadow
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        controller: widget.controller,
      ),
    );
  }
}
