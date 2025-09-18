import 'package:flutter/material.dart';
import 'const.dart' as cons;
class Principal extends StatefulWidget {
  final int rows;
  final int columns;
  const Principal({super.key, this.rows = 4, this.columns = 5});
  @override
  State<Principal> createState() => _PrincipalState();
}
class _PrincipalState extends State<Principal> {
  late List<Color> cardColors;
  late List<bool> cardRevealed;
  late List<int> cardValues;
  int? firstSelectedIndex;
  int? secondSelectedIndex;
  int pairsFound = 0;
  bool gameCompleted = false;  
  @override
  void initState() {
    super.initState();
    initializeGame();
  }
  void initializeGame() {
    final totalCards = widget.rows * widget.columns;
    // Crear pares de colores
    List<Color> colorPairs = [];
    for (int i = 0; i < totalCards ~/ 2; i++) {
      Color color = cons.memoramaColors[i % cons.memoramaColors.length];
      colorPairs.add(color);
      colorPairs.add(color); // Par duplicado
    }
    // Mezclar los colores
    colorPairs.shuffle();
    cardColors = colorPairs;
    cardRevealed = List<bool>.filled(totalCards, false);
    cardValues = List<int>.generate(totalCards, (index) => index);
    firstSelectedIndex = null;
    secondSelectedIndex = null;
    pairsFound = 0;
    gameCompleted = false;
  }
  
  void _onCardTap(int index) {
    if (cardRevealed[index] || 
        secondSelectedIndex != null || 
        gameCompleted) {
      return;
    }
    setState(() {
      cardRevealed[index] = true;
      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
      } else {
        secondSelectedIndex = index;
        // Verificar si coinciden
        if (cardColors[firstSelectedIndex!] == cardColors[secondSelectedIndex!]) {
          // Coinciden - mantener visibles
          firstSelectedIndex = null;
          secondSelectedIndex = null;
          pairsFound++;
          
          // Verificar si el juego está completo
          if (pairsFound == (widget.rows * widget.columns) ~/ 2) { // Todas las parejas encontradas
            gameCompleted = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              _showGameCompletedDialog();
            });
          }
        } else {
          // No coinciden - volver a ocultar después de un delay
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              cardRevealed[firstSelectedIndex!] = false;
              cardRevealed[secondSelectedIndex!] = false;
              firstSelectedIndex = null;
              secondSelectedIndex = null;
            });
          });
        }
      }
    });
  }
  
  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Felicidades!'),
          content: const Text('Has completado el memorama.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                initializeGame();
              },
              child: const Text('Jugar de nuevo'),
            ),
          ],
        );
      },
    );
  }
  
  void _restartGame() {
    setState(() {
      initializeGame();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorama - Maximiliano Mendez Hernandez'),
        backgroundColor: cons.azul1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
            tooltip: 'Reiniciar juego',
          ),
        ],
      ),
      body: Column(
        children: [
          if (gameCompleted)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.withOpacity(0.3),
              child: const Text(
                '¡Juego Completado!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.columns,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.rows * widget.columns,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardRevealed[index] 
                          ? cardColors[index] 
                          : cons.azul1,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: cardRevealed[index]
                          ? null
                          : const Icon( // signo de interrogacion en las cartas no reveladas 
                              Icons.question_mark,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _restartGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: cons.azul1,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Reiniciar Juego',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
