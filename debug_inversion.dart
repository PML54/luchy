// Debug de l'inversion de variables
void main() {
  // Test de l'inversion manuelle
  String latex = r'\sum_{k=1}^{n} k = \frac{n(n+1)}{2}';
  List<String> variables = ['k', 'n'];
  
  print('🔍 TEST D\'INVERSION DE VARIABLES');
  print('=' * 40);
  print('Formule originale: $latex');
  print('Variables: $variables');
  
  // Simuler l'inversion
  String result = latex;
  final var1 = variables[0]; // 'k'
  final var2 = variables[1]; // 'n'
  
  print('\n📝 Inversion: $var1 ↔ $var2');
  
  result = result.replaceAllMapped(
    RegExp(r'\b' + RegExp.escape(var1) + r'\b'),
    (match) => var2
  );
  result = result.replaceAllMapped(
    RegExp(r'\b' + RegExp.escape(var2) + r'\b'),
    (match) => var1
  );
  
  print('Résultat: $result');
  
  print('\n✅ Test terminé');
}
