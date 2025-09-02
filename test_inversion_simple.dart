// Test simple de l'inversion améliorée
void main() {
  // Test de l'inversion avec les nouvelles regex
  String latex = r'\sum_{k=1}^{n} k = \frac{n(n+1)}{2}';
  List<String> variables = ['k', 'n'];
  
  print('🔍 TEST D\'INVERSION AMÉLIORÉE');
  print('=' * 40);
  print('Formule originale: $latex');
  print('Variables: $variables');
  
  // Simuler l'inversion améliorée
  final var1 = variables[0]; // 'k'
  final var2 = variables[1]; // 'n'
  
  String result = latex;
  
  print('\n📝 Inversion: $var1 ↔ $var2');
  
  // Nouvelle approche
  final escapedVar1 = RegExp.escape(var1);
  final escapedVar2 = RegExp.escape(var2);
  
  result = result.replaceAllMapped(
    RegExp(r'(?<![a-zA-Z])' + escapedVar1 + r'(?![a-zA-Z0-9])'),
    (match) => var2
  );
  result = result.replaceAllMapped(
    RegExp(r'(?<![a-zA-Z])' + escapedVar2 + r'(?![a-zA-Z0-9])'),
    (match) => var1
  );
  
  print('Résultat: $result');
  print('Attendu:  \\sum_{n=1}^{k} n = \\frac{k(k+1)}{2}');
  
  print('\n✅ Test terminé');
}
